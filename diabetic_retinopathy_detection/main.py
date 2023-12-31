import numpy as np
import tensorflow as tf
import tensorflow.keras as keras
import matplotlib.pyplot as plt

import wandb
import os
import argparse

from input import load
from architecture import transfer_model
from train import train
from evaluation import evaluate_multiclass, evaluate_binary

def main(args): 
    # seeds
    np.random.seed(42)
    tf.random.set_seed(42)

    args_config = vars(args)
    # wandb uses the yaml file and overrides the values with the args_config
    wandb.init(project="diabetic_retinopathy", entity=args_config["user"], mode=args_config["log_wandb"])
    wandb.config.update(args, allow_val_change=True)
    config = wandb.config

    os.environ['WANDB_DIR'] = config.data_dir + "wandb/"
    

    ds_train, ds_val, ds_test = load(config)

    

    if config.train:
        model = transfer_model(config)
        train(config, model, ds_train, ds_val)
        model.save(os.path.join(wandb.run.dir, "model.h5"))

    else:
        print("Evaluating given model")
        api = wandb.Api()
        run = api.run(config.evaluate_run)
        run.file("model.h5").download(replace=True)
        model = tf.keras.models.load_model('model.h5')
        print(model.summary())
        if config.mode == "binary_class":
            acc, p, r, f1 = evaluate_binary(config, model, ds_test)
            print(f"Accuracy: {acc}")
            print(f"Precision: {p}")
            print(f"Recall: {r}")
            print(f"f1-Score: {f1}")
        if config.mode == "multi_class":
            acc, p, r, f1, confm, quadratic_weighted_kappa = evaluate_multiclass(config, model, ds_test)
            print(f"Accuracy: {acc}")
            print(f"Precision: {p}")
            print(f"Recall: {r}")
            print(f"f1-Score: {f1}")
            print(f"Confusion-Matrix: \n{confm}")
            print(f"Quadratic WeightedKappa: {quadratic_weighted_kappa}")

if __name__ == "__main__":

    # pass arguments via command line to the program. If default=SUPPRESS and no arg is passed, the value of the default yaml is used
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--train', type=bool, help='True=Train, False=Evaluate', default=True)
    parser.add_argument('-l', '--log_wandb', type=str, help='mode of wandb', default="online")  # "online" / "disabled"
    parser.add_argument('-u', '--user', type=str, help='specify the entity name for the wandb logging', default="stuttgartteam8")
    parser.add_argument('-p', '--data_dir', type=str, help='path to the dataset and wandb logging', default=argparse.SUPPRESS)
    parser.add_argument('-e', '--epochs', type=int, help='number of epochs to train the network', default=argparse.SUPPRESS)
    args = parser.parse_args()
    main(args)

