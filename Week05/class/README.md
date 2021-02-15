**ST446 Distributed Computing for Big Data**, LT 2021

# Seminar class 5

## Lecture

This week's lecture is about _graph data processing_ in Spark.

## Class
This week, we will look at data from Stack Exchange. Please have a look at this [notebook](ExploreStackexchangeData.ipynb).

Please run the notebook in a cluster that was initialised as follows. The reason for this is that specific initialisation actions are required to use graphframes.

For `Mac OS` and `Linux` user, please run the following commands in Terminal:

```
gcloud dataproc clusters create [your cluster name] --project [your project id] \
  --properties=^#^spark:spark.jars.packages=graphframes:graphframes:0.5.0-spark2.1-s_2.11,com.databricks:spark-xml_2.11:0.4.1 \
  --subnet default --zone europe-west2-a --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 1.3-deb9 \
  --initialization-actions 'gs://dataproc-initialization-actions/jupyter/jupyter.sh','gs://dataproc-initialization-actions/python/pip-install.sh','gs://dataproc-initialization-actions/zookeeper/zookeeper.sh','gs://dataproc-initialization-actions/kafka/kafka.sh' \
  --metadata 'PIP_PACKAGES=sklearn nltk pandas graphframes'
```

For `Windows` user, please go to the cloud shell provided on your GCP console webpage.
1. initialize your gcloud setting by `gcloud init`
2. set up your region by `gcloud config set dataproc/region europe-west2`
3. run the same commands used by `Mac OS` and `Linux` users.

## Homework

Have a look at the section "2. Graph of user co-contributions" in the [notebook](ExploreStackexchangeData.ipynb). Try to fill in the gaps.
