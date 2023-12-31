import tensorflow.keras as keras
import tensorflow as tf
import logging
import wandb
from wandb.keras import WandbCallback
from evaluation import evaluate_multiclass, evaluate_binary
import sklearn.metrics


class WandbLogger(tf.keras.callbacks.Callback):
    def __init__(self, config, model, ds_train, ds_val):
        super(WandbLogger, self).__init__()
        self.config = config
        self.model = model
        self.ds_train = ds_train
        self.ds_val = ds_val


    def on_epoch_end(self, epoch, logs):
        # on epoch end validate the model and log the result
        if self.config.mode == "multi_class":
            _, train_precision, train_recall, train_f1, _, train_quadratic_weighted_kappa = evaluate_multiclass(self.config, self.model, self.ds_train)
            _, val_precision, val_recall, val_f1, _, val_quadratic_weighted_kappa = evaluate_multiclass(self.config, self.model, self.ds_val)
            wandb.log({"train_precision": train_precision,
                        "train_recall": train_recall,
                        "train_f1": train_f1,
                        "train_quadratic_weighted_kappa": train_quadratic_weighted_kappa,
                        "val_precision": val_precision,
                        "val_recall": val_recall,
                        "val_f1": val_f1,
                        "val_quadratic_weighted_kappa": val_quadratic_weighted_kappa,
                        "epoch": epoch})
        if self.config.mode == "binary_class":
            accuracy, train_precision, train_recall, train_f1 = evaluate_binary(self.config, self.model, self.ds_train)
            val_accuarcy, val_precision, val_recall, val_f1 = evaluate_binary(self.config, self.model, self.ds_val)
            wandb.log({"train_acc": accuracy,
                        "train_precision": train_precision,
                        "train_recall": train_recall,
                        "train_f1": train_f1,
                        "val_acc": val_accuarcy,
                        "val_precision": val_precision,
                        "val_recall": val_recall,
                        "val_f1": val_f1,
                        "epoch": epoch})
        

def train(config, model, ds_train, ds_val): 
    # select sgd or Adam optimizer
    if config.optimizer=="sgd":
        opt = keras.optimizers.SGD(learning_rate=config.learning_rate, momentum=config.momentum)
    elif config.optimizer=="adam":
        opt = keras.optimizers.Adam(learning_rate=config.learning_rate)
    else:
        print("no optimizer specified!!!")
    
    # select the loss function that corresponds to the mode
    if config.mode == "binary_class":
        loss = "binary_crossentropy"
        metrics = ["accuracy"]
    elif config.mode == "multi_class":
        loss = "categorical_crossentropy"
        metrics = ["accuracy"]    

    model.compile(optimizer=opt, 
                    loss = loss,
                    metrics = metrics)

    # define the learning rate scheduling:
    def lr_scheduler(epoch, lr):
        # exponential decay
        # e.g. if epoch = 100 and lr_decay = 10: 0.1^0.01 = 0.977 -> the factor the lr is reduced each round
        if epoch == 0:
            return lr # use the starting learning_rate for the first epoch
        if epoch == config.epochs:  # only in case of fine-tuning: if number of epochs is reached, start fine tuning and make model trainable
            model.trainable = True
            model.summary() 
        if epoch >= config.epochs: # relevant only for the fine tuning epochs
            return config.fine_tuning_learning_rate
        return lr * (1/config.learning_rate_decay) ** (1 / (config.epochs-1))  # perform learning rate decay if configured

    learning_rate_callback = keras.callbacks.LearningRateScheduler(lr_scheduler, verbose=0) # verbose 0: quiet, verbose 1: output
    total_epochs = config.epochs + config.fine_tuning_epochs  # train the network in total for epochs + fine_tuning_epochs
    model.fit(ds_train,  
                batch_size=config.batch_size,
                epochs=total_epochs,
                verbose=2,
                validation_data=ds_val,
                callbacks=[WandbCallback(), WandbLogger(config, model, ds_train, ds_val), learning_rate_callback])


if __name__ == "__main__":
    pass