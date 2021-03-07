**ST446 Distributed Computing for Big Data**, LT 2021

# Seminar Class 7: scalable machine learning I

This class session contains three notebooks. Please make sure that you can run them at home, using your Google Cloud Platform account, and that you obtain reasonable results. You can also try them with clusters of different sizes and different data partitioning.

To run any of these notebooks on GCP, you can:

1. set up a plain vanilla dataproc cluster with jupyter-notebook initialisation actions. You can use the following command on you local machine terminal OR create this cluster through your GCP Console.

**Remember to specify your cluster name, change the project name, choose the proper region and zone you are using in your GCP account, and enable component gateways. Please also observe we are using an image version < 2.0 as Anaconda and Jupyer can present some incompatibilities with version 2.0.**

```
gcloud beta dataproc clusters create cluster-meb01 --enable-component-gateway --region europe-west2 \
--zone europe-west2-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 \
--worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 1.5-centos8 \
--optional-components ANACONDA,JUPYTER --project st446-lt2021
```

2. Upload the three notebooks to your Dataproc cluster using i) a bucket to transfer from your local computer to your VM instance on your Dataproc cluster (see Week1 for reference) OR ii) using the Google Cloud Console panel, go to your Dataproc cluster page, click on VM instances and then on the SSH menu, and choose Open a new browser window. When your VM instance terminal is shown, click in the gear symbol and choose Upload file.

3. Once your have uploaded all the three notebooks, you can go to your Dataproc cluster page, click on Web interfaces and select Jupyter. When the Jupyter notebook interface is shown, you should have all the three notebooks into your `Local Disk/home/<username>`. Those notebooks are automatically attached to a PySpark kernel when opened.

All three notebooks consider the **training of logistic regression models on different training data in Spark**, but they cover different aspects.

## 1. Batch gradient descent:
[logistic_regression_batch_gradient_descent.ipynb](logistic_regression_batch_gradient_descent.ipynb)

## 2. Comparison of L-BFGS and SGD:
[logistic_regression_lbfgs_vs.sgd.ipynb](logistic_regression_lbfgs_vs_sgd.ipynb)

## 3. Use of DataFrame API and pipelines:
 [logistic_regression_pipeline.ipynb](logistic_regression_pipeline.ipynb)

___

The [first](logistic_regression_batch_gradient_descent.ipynb) one shows how to implement learning of the parameter vector of a logistic regression model using the gradient descent algorithm in a distributed setting in Spark (Python API). This shows how to implement the concepts covered in the lecture using a Spark engine and the underlying RDD functionalities.

The [second](logistic_regression_lbfgs_vs_sgd.ipynb) notebook is about the comparison of the accuracy and speed of learning the parameter vector of the logistic regression model using stochastic gradient descent (SGD) and the quasi-Newton method L-BFGS (limited memory Broyden–Fletcher–Goldfarb–Shanno), both of which we covered in the lecture. This notebook demonstrates properties discussed in class, such as that in general L-BFGS is superior to SGD with respect to accuracy, but is computationally more expensive and thus it requires more computation time.

The [third](logistic_regression_pipeline.ipynb) notebook shows how to develop a machine learning pipeline for a classification task using a logistic regression model with the DataFrame API of the [Spark machine learning library *ML*](https://spark.apache.org/docs/1.2.2/ml-guide.html). For the concept of pipelines in Spark, you may want to read the relevant section of the Spark programming guide document referred in the notebook. Note that the DataFrame API is chosen for further development in *ML* over the RDD API, which is put in maintainance mode. The notebook demonstrates how, in principle, one would write code for a classification task in Spark when addressing a real-life problem.

We encourage you to go through these notebooks in the given order, read through the code and try understand what is going on, and run the code as you go on.
