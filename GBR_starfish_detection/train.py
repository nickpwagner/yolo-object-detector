import tensorflow.keras as keras
import tensorflow as tf
import wandb
from wandb.keras import WandbCallback
import tensorflow_addons as tfa
from tensorflow import math as tfm


def train(config, model, ds_train, ds_test): 
    # select the optimizer
    if config.optimizer=="sgd":
        opt = keras.optimizers.SGD(learning_rate=config.learning_rate, momentum=config.momentum)
    elif config.optimizer=="adam":
        opt = keras.optimizers.Adam(learning_rate=config.learning_rate)
    else:
        print("no optimizer specified!!!")
    
    ############################# -- CUSTOM LOSS SECTION -- #################################################################
    """
    implementation of a simplified but customized yolo loss function
    can e.g. use cross entropy for objectness unlike yolo loss function
    """
    mae = keras.losses.MeanAbsoluteError()
    bce = keras.losses.BinaryCrossentropy(from_logits=True)
    mse = keras.losses.MeanSquaredError()

    def objectness_loss(y_true, y_pred):
        """
        computes the confidence loss for channel 0 (objectness)
        returns: weighted objectness loss value
        """
        # objectness is stored in channel 0
        if config.objectness_loss == "mse":
            objectness_loss = mse(y_true[..., 0], y_pred[..., 0])  # is a starfish in the grid cell
        elif config.objectness_loss == "bce": 
            objectness_loss = bce(y_true[..., 0], y_pred[..., 0])  # is a starfish in the grid cell
        elif config.objectness_loss == "weighted_bce":
            objectness_loss = tf.nn.weighted_cross_entropy_with_logits(y_true[..., 0], y_pred[..., 0], config.bce_weighting)
        else:
            objectness_loss = 0
        return config.objectness_loss_weighting * objectness_loss

    def bbox_loss(y_true, y_pred):
        """
        computes the bounding box loss for channel 1 to 4 (center coordinates and size)
        returns: bounding box loss value
        """
        # objectness is stored in channels 1-4
        mask = y_true[..., 0]
        # remove cell values from all out_channels which have objectness 0
        # therefore focus on cells which have objects in them
        mask = tf.stack([mask, mask, mask, mask, mask], axis=3) 
        y_pred = tf.multiply(y_pred, mask)  # mask the channels
        if config.bbox_loss == "mse":
            bbox_loss = mse(y_true[..., 1:], y_pred[..., 1:])
        elif config.bbox_loss == "mae":
            bbox_loss = mae(y_true[..., 1:], y_pred[..., 1:]) # where is the bbox located and whats the size
        elif config.bbox_loss == "giou":
            bbox_loss = gIOU(y_true, y_pred)
        return bbox_loss

    def custom_loss(y_true, y_pred):
        """
        adds up objectness and bounding box loss
        returns: custom loss value
        """
        return objectness_loss(y_true, y_pred) + bbox_loss(y_true, y_pred)

    ############################# -- YOLO LOSS SECTION -- ####################################################################

    def yolo_bbox_center_loss(y_true, y_pred): # mse
        """
        computes the yolo bounding box center loss of channel 1 and 2
        returns: yolo bounding box center loss value
        """
        # only use cell entries which have an object in them
        mask = y_true[...,0]
        mask = tf.stack([mask,mask,mask,mask,mask], axis=3)
        y_pred_m = tfm.multiply(mask, y_pred)
        # box center coordinate loss
        bbox_center_x_loss = tfm.square(y_true[...,1] - y_pred_m[...,1])  # index 1: center x
        bbox_center_y_loss = tfm.square(y_true[...,2] - y_pred_m[...,2])  # index 2: center y
        bbox_center_loss = tf.reduce_sum(bbox_center_x_loss + bbox_center_y_loss, axis=(1,2))
        #alternative one liner: weight_coord * tf.reduce_sum(tf.reduce_sum(tfm.square(y_true[...,1:3] - y_pred_m[...,1:3], axis=3)), axis=(1,2))
        return config.yolo_weight_center * tf.reduce_mean(bbox_center_loss)

    def yolo_bbox_size_loss(y_true, y_pred): # mse of sqrt
        """
        computes the yolo bounding box size loss of channel 3 and 4
        square root ensure that deviations for small bounding boxes are more important
        returns: yolo bounding box size loss value
        """
        # only use cell entries which have an object in them
        mask = y_true[...,0]
        mask = tf.stack([mask,mask,mask,mask,mask], axis=3)
        y_pred_m = tfm.multiply(mask, y_pred)
        # box size loss
        # use absolute values and sign to avoid sqrt of negative vales (nan)
        # add small value to sqrt for predicted values to ensure numerical stability (derivative with input zero > inf)
        bbox_width_loss = tfm.square(tfm.sqrt(y_true[...,3]) - tfm.multiply(tfm.sign(y_pred_m[...,3]), tfm.sqrt(tfm.abs(y_pred_m[...,3]) + 1e-10)))
        bbox_height_loss = tfm.square(tfm.sqrt(y_true[...,4]) - tfm.multiply(tfm.sign(y_pred_m[...,4]), tfm.sqrt(tfm.abs(y_pred_m[...,4]) + 1e-10)))
        bbox_size_loss = tf.reduce_sum(bbox_width_loss + bbox_height_loss, axis=(1,2))

        return config.yolo_weight_size * tf.reduce_mean(bbox_size_loss)

    def yolo_no_obj_loss(y_true, y_pred):
        """
        confidence (objectness) loss for cells without objects
        returns: no objects cell loss
        """
        # confidence (objectness) loss for cells without objects
        no_obj_mask = 1 - y_true[...,0]
        no_obj_loss = tf.reduce_sum(tfm.multiply(no_obj_mask, tfm.square(y_true[...,0] - y_pred[...,0])), axis=(1,2))
        
        return config.yolo_weight_noobj * tf.reduce_mean(no_obj_loss)

    def yolo_obj_loss(y_true, y_pred):
        """
        confidence (objectness) loss for cells with objects
        returns: objects cell loss
        """
        # confidence (objectness) loss for cells with objects
        y_pred_obj_m = tfm.multiply(y_true[...,0], y_pred[...,0])
        obj_loss = tf.reduce_sum(tfm.square(y_true[...,0] - y_pred_obj_m), axis=(1,2))
        
        return config.yolo_weight_obj * tf.reduce_mean(obj_loss)

    def yolo_loss(y_true, y_pred):
        """
        adds up all yolo sub-losses
        returns: final yolo loss
        """
        return yolo_bbox_center_loss(y_true, y_pred) + yolo_bbox_size_loss(y_true, y_pred) + yolo_obj_loss(y_true, y_pred) + yolo_no_obj_loss(y_true, y_pred)

    ############################# -- METRICS SECTION -- #######################################################################

    def bbox_center_size_to_bbox_min_max(y):  
        """
        converts bounding boxes from center/size to [y_min, x_min, y_max, x_max]
        required for IOU and gIOU, inputs 4 channels
        returns: [y_min, x_min, y_max, x_max]
        """
        y_out = tf.zeros((config.batch_size, config.grid_size, config.grid_size, 4)) #[y_min, x_min, y_max, x_max]
        y_min = tf.subtract(y[..., 1], tf.divide(y[..., 3], 2))  # y_min = y_center - height/2
        x_min = tf.subtract(y[..., 0], tf.divide(y[..., 2], 2)) # x_min = x_center - width/2
        y_max = tf.add(y[..., 1], tf.divide(y[..., 3], 2))  # y_max = y_center + height/2
        x_max = tf.add(y[..., 0], tf.divide(y[..., 2], 2)) # x_max = x_center + width/2
        y_out = tf.stack([y_min, x_min, y_max, x_max], axis=3)
        return y_out

    def IOU(y_true, y_pred):  
        """
        calculates the intersection over union of y_pred and y_true
        in the range 0 ...1:  1=worst IOU, 0=ideal or identical Bboxes
        returns: iou values 
        """
        # assumes that the width and height is in grid-size scale
        if tf.reduce_sum(y_true[...,0]) == 0:  # if no object in the batch of images, return 0 loss!
            return tf.cast(0.0, dtype=tf.float32)
        # only use loss for samples where y_true has an object and weight those samples up
        sample_weighting = y_true[..., 0] * config.batch_size*config.grid_size*config.grid_size/tf.reduce_sum(y_true[...,0])
        y_pred = bbox_center_size_to_bbox_min_max(y_pred[..., 1:])
        y_true = bbox_center_size_to_bbox_min_max(y_true[..., 1:])
        iou = tfa.losses.GIoULoss(mode="iou")
        return iou(y_true, y_pred, sample_weight=sample_weighting)

    def gIOU(y_true, y_pred):
        """
        calculates the general intersection over union of y_pred and y_true
        additional to iou: take proximity of boxes into account
        returns: general iou values 
        """
        # assumes that the width and height is in grid-size scale
        if tf.reduce_sum(y_true[...,0]) == 0:  # if no object in the batch of images, return 0 loss!
            return tf.cast(0.0, dtype=tf.float32)
        # only use loss for samples where y_true has an object and weight those samples up
        sample_weighting = y_true[..., 0] * config.batch_size*config.grid_size*config.grid_size/tf.reduce_sum(y_true[...,0])
        y_pred = bbox_center_size_to_bbox_min_max(y_pred[..., 1:])
        y_true = bbox_center_size_to_bbox_min_max(y_true[..., 1:])
        iou = tfa.losses.GIoULoss(mode="giou")
        return iou(y_true, y_pred, sample_weight=sample_weighting)

    def TP_rate(y_true, y_pred):
        """
        calculates how many positives were detected as such
        returns: true positive rate
        """
        # check if starfish objectness is correct. 
        P = tf.cast(tf.reduce_sum(y_true[..., 0]), dtype=tf.int32)  # positive in ground truth
        if P == 0:  # if there are no trues, assume TP rate = 0
            return tf.cast(0.0, dtype=tf.float64)
        else:
            y_pred = tf.where(y_pred[..., 0] > 0.5, 1, 0)  # thesholding of y_pred-objectness
            TP = tf.reduce_sum(tf.multiply(y_pred, tf.cast(y_true[..., 0], dtype=tf.int32)))  # multiply y_pred and y_true and you get the true positives
            TP_rate = TP / P
            return TP_rate

    def TN_rate(y_true, y_pred):
        """
        calculates how many negatives were detected as such
        returns: true negative rate
        """
        N = tf.reduce_sum(tf.where(y_true[..., 0] == 0, 1, 0))  # sum up all elements where y_true = 0
        TN = tf.reduce_sum(tf.multiply(tf.where(y_pred[..., 0] < 0.5, 1, 0), tf.where(y_true[..., 0] == 0, 1, 0)))  # multiply the pred.negativ with GT negative
        TN_rate = TN / N
        return TN_rate

    ############################# -- TRAINING SECTION -- #######################################################################
    # select the loss function and metrics
    if config.loss_function == "custom":
        loss = custom_loss
        metrics = [objectness_loss, bbox_loss, TP_rate, TN_rate, IOU, gIOU]
    elif config.loss_function == "yolo":
        loss = yolo_loss
        metrics = [yolo_bbox_center_loss, yolo_bbox_size_loss, yolo_obj_loss, yolo_no_obj_loss, TP_rate, TN_rate, IOU, gIOU]
    # compile the model with the optimizer loss and metrics
    model.compile(optimizer=opt, 
                    loss =  loss,
                    metrics = metrics)

    def lr_scheduler(epoch, lr):
        """
        Exponential learning rate decay
        returns: decayed learning rate value
        """
        # exponential decay = initial_learning_rate * decay_rate ^ (steps / decay_step_rate)
        # e.g. if epoch = 100 and lr_decay = 10: 0.1^0.01 = 0.977 -> the factor the lr is reduced each round
        if epoch == 0:
            return lr
        return lr * (1/config.learning_rate_decay) ** (1 / (config.epochs-1))

    # start the training
    learning_rate_callback = keras.callbacks.LearningRateScheduler(lr_scheduler, verbose=0) # verbose 0: quiet, verbose 1: output
    model.fit(ds_train,  
                batch_size=config.batch_size,
                epochs=config.epochs,
                verbose=2,
                validation_data=ds_test,
                callbacks=[WandbCallback(), learning_rate_callback])


if __name__ == "__main__":
    # run prediction on a pretrained model
    import wandb
    import tensorflow as tf
    from input import load, annotate_image
    import tensorflow.keras as keras
    import matplotlib.pyplot as plt
    import os

    wandb.init(project="protect_gbr", entity="stuttgartteam8", mode="disabled") 
    config = wandb.config
    _, ds_train, ds_test = load(config) 
    model_filename = "_".join(config.wandb_run.split("/")) + ".h5"
    if os.path.isfile(model_filename):
        print("Using model from local .h5 file")
    else:
        print("Download model from wandb")
        api = wandb.Api()
        run = api.run(config.wandb_run)
        run.file("model.h5").download(replace=True)
        os.rename("model.h5", model_filename)
    model = tf.keras.models.load_model(model_filename, compile=False) 

    plt.figure("GBR", figsize=(10,10))
    for images, y_true in ds_train:
        for i in range(config.batch_size):
            y_pred = model.predict(images)
            img = annotate_image(config, images[i], y_pred[i], y_true[i])
            plt.imshow(img)
            plt.show()