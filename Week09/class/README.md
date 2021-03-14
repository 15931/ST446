**ST446 Distributed Computing for Big Data**, LT 2021
# Seminar class 8: scalable machine learning II

This class session contains 3 notebooks:

1. ALS recommendation system: [als_movielens.ipynb](als_movielens.ipynb)

2. SVD on news text data: [LSA.ipynb](LSA.ipynb)

3. LDA on news text data: [LDA.ipynb](LDA.ipynb)

To run the notebooks, you will need to instantiate a cluster specific initialisation actions, such that the right libraries and data are installed on all nodes of the cluster. This week, we well even need to add custom initialisation actions.

Please adjust the code below and use it to create your cluster.

In order to install **nltk** and download the data that it requires to all worker nodes of the cluster, we will need to add a custom initialisation script.

1. create a bucket

```
REGION=europe-west2
CLUSTERNAME=jialin-cluster
PROJECT=st446-lent
BUCKET=jialin-bucket

gsutil mb gs://${BUCKET}
```

2. have a look at [`my-actions.sh`](./my-actions.sh) and upload it to the bucket like so:

```
gsutil cp my-actions.sh gs://${BUCKET}
```

for Windows users, you need to use [dos2unix](http://dos2unix.sourceforge.net/) to convert the end-of-line character before uploading to the bucket.

3. create a cluster (this could take a significant amount of time) using one of the following commands. (Just choose the one that works for you)

```
gcloud dataproc clusters create ${CLUSTERNAME} \
    --project ${PROJECT} --region ${REGION} \
    --subnet default --zone europe-west2-a --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 2 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 1.3-deb9 \
    --initialization-actions gs://dataproc-initialization-actions/jupyter/jupyter.sh,gs://dataproc-initialization-actions/python/pip-install.sh,gs://${BUCKET}/my-actions.sh \
    --metadata 'PIP_PACKAGES=sklearn nltk pandas numpy'
```

or

```
gcloud beta dataproc clusters create ${CLUSTERNAME} --project ${PROJECT} \
    --bucket ${BUCKET} --region ${REGION} \
    --image-version=preview \
    --optional-components=ANACONDA,JUPYTER \
    --enable-component-gateway \
    --initialization-actions \
    gs://goog-dataproc-initialization-actions-${REGION}/python/pip-install.sh,gs://${BUCKET}/my-actions.sh \
    --metadata 'PIP_PACKAGES=sklearn nltk pandas numpy'
```

4. upload and run the jupyter notebook in the `Dataproc->Web interfaces`


