**ST446 Distributed Computing for Big Data**

# Seminar Class 9: Scaling up machine learning models

This week, we are looking at how to use distributed computing to train large-scale machine learning models. The first example illustrates the *data parallel computational model* discussed in the lecture through the compression of gradient updates sent by worker nodes to the parameter server. In the second example, we make use of the Google AI Platform to train neural networks in TensorFlow.

For the first example, follow these steps: 

1. Please, use the script below (same from Week08) to configure your Dataproc cluster for this activity. **Remember to change for your project name, cluster name and region/zone**.

```
gcloud beta dataproc clusters create cluster-meb01 --enable-component-gateway --region europe-west2 \
--zone europe-west2-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 \
--worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 1.4-debian10 \
--optional-components ANACONDA,JUPYTER --project st446-lt2021
```
2. Go to [qsgd.md](qsgd.md) and follow the instructions there.

3. Upload and run the Jupyter notebook (QSGD.ipynb) through the `Dataproc->Web interfaces`

For the second example, go to [DistributedTensorFlow.md](DistributedTensorFlow.md) and follow the instructions there.
