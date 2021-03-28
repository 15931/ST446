### ST446 Distributed Computing for Big Data, LT 2020

# Seminar 10: Distributed dataflow graph computations

## Exercise 2: Distributed training with `MultiWorkersMirroredStrategy()`: multiple machines 

This tutorial demonstrates multi-worker distributed training of a neural network with Keras using `tf.distribute.Strategy` API. With the help of the distribution strategies specifically designed for multi-worker training settings, the model and code developed to run on a single machine (worker node) can seamlessly work on multiple workers with only minimal code changes.
This tutorial is adapted from [tensorflow-2-0-tutorial-05-distributed-training-multi-node](https://lambdalabs.com/blog/tensorflow-2-0-tutorial-05-distributed-training-multi-node/) and [multi_worker_with_keras](https://www.tensorflow.org/tutorials/distribute/multi_worker_with_keras).

## Setup

Create two instances `worker-0` and `worker-1` using Google's deep learning platform images (TensorFlow 2.x included), each of them are attached with one NVIDIA Tesla T4 GPU.

Here is the code to create `worker-0` and change the `INSTANCE_NAME` to create `worker-1`.

```
export INSTANCE_NAME="worker-0"
export IMAGE_FAMILY="tf2-latest-gpu" # TensorFlow 2
export ZONE="europe-west2-a"
export INSTANCE_TYPE="n1-standard-4"
gcloud compute instances create $INSTANCE_NAME \
  --zone=$ZONE \
  --image-family=$IMAGE_FAMILY \
  --machine-type=$INSTANCE_TYPE \
  --image-project=deeplearning-platform-release \
  --maintenance-policy=TERMINATE \
  --accelerator='type=nvidia-tesla-t4,count=1' \
  --no-boot-disk-auto-delete \
  --boot-disk-device-name=$INSTANCE_NAME-disk \
  --boot-disk-size=200GB \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --metadata='install-nvidia-driver=True,proxy-mode=project_editors'
```

Then upload [task.py](task.py) to both of the worker instances.

## Multi-worker configuration

In TensorFlow 2.x, `TF_CONFIG` environment variable needs to be set for training on multiple machines, each of which possibly having a different role. `TF_CONFIG` is used to specify the cluster configuration on each worker that is part of the cluster.

There are two components of `TF_CONFIG`: `cluster` and `task`. `cluster` contains information about the training cluster, which is a dict consisting of different types of jobs such as `worker`. In multi-worker training, there is usually one `worker` that takes responsibility of tasks like saving checkpoints and writing summary file for TensorBoard in addition to what a regular `worker` does. Such worker is referred to as the 'chief' worker, and it is customary that the `worker` with `index` 0 is appointed as the chief `worker` (in fact this is how `tf.distribute.Strategy` is implemented). `task`, on the other hand, provides information about the current task.  

In this example, we set the task `type` to `"worker"` and the task `index` to `0`. This means the machine that has such setting is the first worker, which will be appointed as the chief worker and do more work than other workers. Note that other machines will need to have `TF_CONFIG` environment variable set as well, and it should have the same `cluster` dict, but different task `type` or task `index` depending on what the roles of those machines are.

For illustration purposes, this tutorial shows how one may set a `TF_CONFIG` with 2 workers on `localhost`.  In practice, users would create multiple workers on external IP addresses/ports, and set `TF_CONFIG` on each worker appropriately.

Warning: Do not execute the following code in Colab.  TensorFlow's runtime will attempt to create a gRPC server at the specified IP address and port, which will likely fail.

There are two ways to assign `TF_CONFIG` environment variable:

* Run the python code snippet below

```
import os
import json

os.environ['TF_CONFIG'] = json.dumps({
    'cluster': {
        'worker': ["localhost:12345", "localhost:23456"]
    },
    'task': {'type': 'worker', 'index': 0}
})
```

or 

* Run the following commands in the terminal

```
export TF_CONFIG='{"cluster": {"worker": ["35.246.44.98:12345", "35.234.141.101:12345"]}, "task": {"type": "worker", "index": 0}}'
```

## Start distributed training

To run distributed training, the training script [task.py](task.py) needs to be customized and copied to all nodes.

Last but not least, run the script simultaneously on both nodes.

```
# On the first node
export TF_CONFIG='{"cluster": {"worker": ["10.1.10.58:12345", "10.1.10.250:12345"]}, "task": {"index": 0, "type": "worker"}}' 
python worker.py

# On the second node
export TF_CONFIG='{"cluster": {"worker": ["10.1.10.58:12345", "10.1.10.250:12345"]}, "task": {"index": 1, "type": "worker"}}' 
python worker.py
```

