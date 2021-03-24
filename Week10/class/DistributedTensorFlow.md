**ST446 Distributed Computing for Big Data**

# Seminar class 9: Distributed TensorFlow

## Introduction

This week, we are exploring how to make use of GCP to train neural networks in TensorFlow. We will use the classic example of predicting whether a taxi driver will get tips given features about the trip. The dataset is from [Chicago Taxi Trips](https://console.cloud.google.com/marketplace/details/city-of-chicago-public-data/chicago-taxi-trips?filter=solution-type:dataset&id=13c38348-0610-4185-a8f7-b5add142fcbe).
This is just one example of a **parameter server architecture with asynchronous updates**, here conveniently hosted on GCP.

In particular, we are using **data-parallel training**. This means that the training data will be distributed across nodes, but parameters are shared between nodes via a central parameter node.

![google_ps](https://cloud.google.com/solutions/images/distributed-tf-arch.png)

We are closely following this [ai-platform-samples](https://github.com/GoogleCloudPlatform/ai-platform-samples) that contains many examples.
The code about Chicago Taxi trips is in [training](https://github.com/GoogleCloudPlatform/ai-platform-samples/tree/master/training/tensorflow/structured/base) and [prediction](https://github.com/GoogleCloudPlatform/ai-platform-samples/tree/master/prediction/tensorflow)

## Introduction and Overview

This week, we are using Google's AI platform (as opposed to compute engines). AI platform lets you train and store models in the cloud. This means that you do not need to think about the underlying hardware.

Have a look at the following picture to understand the underlying data-parallel architecture.

![illustration](https://cloud.google.com/ml-engine/docs/images/dist-tf-datalab-async-updates.svg) 

Next, have a look at the [example code](https://github.com/GoogleCloudPlatform/ai-platform-samples/tree/master/training/tensorflow/structured).
It contains the code to train the neural network in different setting, e.g. using GPU, using TPU, and distributed training.
The [base](https://github.com/GoogleCloudPlatform/ai-platform-samples/tree/master/training/tensorflow/structured/base) folder contains the Python code and all other folders only contain the scripts to submit the training job to Google's AI platform.

## Understanding the code
Every node will execute the main file in [task.py](https://github.com/GoogleCloudPlatform/ai-platform-samples/blob/master/training/tensorflow/structured/base/trainer/task.py). There are two major steps executed in `task.py`:

1. Line 271: create a neural network defined in [model.py](https://github.com/GoogleCloudPlatform/ai-platform-samples/blob/master/training/tensorflow/structured/base/trainer/model.py) using the `tensorflow.estimator` module.
2. Line 280: run an experiment to train and evaluate the neural network we specified using a user-defined [experiment](https://github.com/GoogleCloudPlatform/ai-platform-samples/blob/master/training/tensorflow/structured/base/trainer/experiment.py) module.

As you can see in `create()` in [model.py](https://github.com/GoogleCloudPlatform/ai-platform-samples/blob/master/training/tensorflow/structured/base/trainer/model.py), we are using a TensorFlow built-in `DNNLinearCombinedClassifier` to predict whether a trip will be tipped or not. More details about this classifier can be found [here](https://www.tensorflow.org/api_docs/python/tf/estimator/DNNLinearCombinedClassifier).

### Adding LogWrite permission

Follow the steps in the selected answers in [this Stackflow post](https://stackoverflow.com/questions/49434874/tensorflow-on-ml-engine-the-replica-master-0-exited-with-a-non-zero-status-of-1).

## Training and using the model

We will follow precisely the steps in this [Google tutorial](https://github.com/GoogleCloudPlatform/ai-platform-samples/tree/master/training/tensorflow/structured/base). And the reference for Google's AI platform commands are [here](https://cloud.google.com/sdk/gcloud/reference/ai-platform).

### Steps for training the model

1. Open the cloud shell. You can access the cloud shell by going to `console.cloud.google.com` and using the `activate cloud shell` button in the top right corner.

2. List models with `gcloud ai-platform models list`. There should be none.

3. Clone the example code
```
git clone https://github.com/GoogleCloudPlatform/ai-platform-samples.git
```

4. Create a bucket: `gsutil mb gs://<YOUR_BUCKET_NAME>`. This bucket name will be also required in the `train-cloud-ps.sh` file.

5. Upload the files `config_ps.yaml` and `train-cloud-ps.sh` to your cloud shell. To do that, click the three bullet points sign in the top right corner of your cloud shell window and choose *Upload file*.

6. Change directory to `~/ai-platform-samples/training/tensorflow/structured/base/` and have a look at `config.yaml` which configures the parameter server architecture, e.g. the machine types and the number of workers.
We can change the `scaleTier` value in `config.yaml` to get different cluster structures. For example, `scaleTier: STANDARD_1` specifies that we are using manny worker nodes and few parameter servers. If you prefer more accurate specifications, you can use the `CUSTOM` tier as we did in `config_ps.yaml` (see [here](https://cloud.google.com/ai-platform/training/docs/reference/rest/v1/projects.jobs#scaletier)).
In `config_ps.yaml`, we created a cluster of 1 parameter server and 4 workers.

7. Edit the file `train-cloud-ps.sh` to reflect your bucket name (created in step 4).

8. To train the model, copy the [`train-cloud-ps.sh`](./train-cloud-ps.sh) to `~/ai-platform-samples/training/tensorflow/structured/base/scripts`  and copy [`config_ps.yaml`](./config-ps.yaml) to `~/ai-platform-samples/training/tensorflow/structured/base/` then change directory back to `~/ai-platform-samples/training/tensorflow/structured/base` and submit a training job to Google Cloud AI Platform by runnning

```
source ./scripts/train-cloud-ps.sh
```

* **Running the job may take a while.**

* In the end, you should see output like this:

```
ps-replica-0 Clean up finished. ps-replica-0
Finished tearing down training program.
Job completed successfully.
```

8.1 (OPTIONAL) While the job is running, you can monitor it [here](https://console.cloud.google.com/ai-platform/jobs?_ga=2.224504346.1489042821.1585267313-1894457944.1576246827).

Have a look at the log files. Can you see the different workers and parameter servers (PS) do different things?

* Each job running on a node is called a *replica*. You should be able to identify *Master* replicas that coordinates other jobs. *Worker* replicas perform a portion of the work, and *parameter servers* communicate the parameter vector (that is being updated during the training) between workers.

8.2 (OPTIONAL) We will look at the tensor board to look at the training process. You can open a new cloud shell (click in the `+` sign at the top of your terminal) and run the following command:

```
tensorboard --port 8080 --logdir ${MODEL_DIR}
```

Then, you can click on the Web Preview button (top right corner, close to the three bullets points sign) and choose "Preview on port 8080" to observe the progress.
The tensorboard provides some nice visualisation.

## Deleting the model and data

Please do **not** delete your entire project as suggested in the Google tutorial.

9. In the end, please make sure to delete your trained model and all data that comes with it to avoid continuing cost.

You can look at all the stored versions and delete them like this:

```
$ gcloud ai-platform models list 
$ gcloud ai-platform models delete 
```

Let's also look at the jobs and cancel them as required

```
gcloud ai-platform jobs list
gcloud ai-platform jobs cancel
```

We can see that the jobs have already terminated.

```
JOB_ID                                 STATUS     CREATED
train_tensorflow_taxi_20200327_115752  FAILED     2020-03-27T11:57:55
train_tensorflow_taxi_20200327_114324  SUCCEEDED  2020-03-27T11:43:28
train_tensorflow_taxi_20200327_113548  FAILED     2020-03-27T11:35:53
train_tensorflow_taxi_20200327_112301  FAILED     2020-03-27T11:23:05
train_tensorflow_taxi_20200327_110053  FAILED     2020-03-27T11:01:00
train_tensorflow_taxi_20200327_034847  CANCELLED  2020-03-27T03:48:52
train_tensorflow_taxi_20200327_015155  CANCELLED  2020-03-27T02:03:51
```

10. Delete all compute engines that have been created in the process! Also, delete any bucket you have created.

