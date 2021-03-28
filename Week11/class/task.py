import tensorflow_datasets as tfds
import tensorflow as tf
import os
import json

"""
Remember to set the TF_CONFIG envrionment variable.
For example:
export TF_CONFIG='{"cluster": {"worker": ["35.246.44.98:12345", "35.234.141.101:12345"]}, "task": {"type": "worker", "index": 0}}'
"""

strategy = tf.distribute.experimental.MultiWorkerMirroredStrategy()

tfds.disable_progress_bar()

BUFFER_SIZE = 10000
BATCH_SIZE = 64


def make_datasets_unbatched():
    # Scaling MNIST data from (0, 255] to (0., 1.]
    def scale(image, label):
        image = tf.cast(image, tf.float32)
        image /= 255
        return image, label

    datasets, info = tfds.load(name='mnist',
                               with_info=True,
                               as_supervised=True)

    return datasets['train'].map(scale).cache().shuffle(BUFFER_SIZE)


train_datasets = make_datasets_unbatched().batch(BATCH_SIZE)


def build_and_compile_cnn_model():
    model = tf.keras.Sequential([
        tf.keras.layers.Conv2D(32, 3, activation='relu',
                               input_shape=(28, 28, 1)),
        tf.keras.layers.MaxPooling2D(),
        tf.keras.layers.Flatten(),
        tf.keras.layers.Dense(64, activation='relu'),
        tf.keras.layers.Dense(10)
    ])
    model.compile(
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        optimizer=tf.keras.optimizers.SGD(learning_rate=0.001),
        metrics=['accuracy'])
    return model


NUM_WORKERS = 2
# Here the batch size scales up by number of workers since
# `tf.data.Dataset.batch` expects the global batch size. Previously we used 64,
# and now this becomes 128.
GLOBAL_BATCH_SIZE = 64 * NUM_WORKERS

# Creation of dataset needs to be after MultiWorkerMirroredStrategy object
# is instantiated.
train_datasets = make_datasets_unbatched().batch(GLOBAL_BATCH_SIZE)

with strategy.scope():
    # Model building/compiling need to be within `strategy.scope()`.
    multi_worker_model = build_and_compile_cnn_model()

# Keras' `model.fit()` trains the model with specified number of epochs and
# number of steps per epoch. Note that the numbers here are for demonstration
# purposes only and may not sufficiently produce a model with good quality.
multi_worker_model.fit(x=train_datasets, epochs=3, steps_per_epoch=5)
