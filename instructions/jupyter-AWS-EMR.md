**ST446 Distributed Computing for Big Data - LT 2020-2021**

# Launching a jupyter/PySpark notebook on a Amazon Web Services (AWS) EMR cluster
Note: This is only for those who have problems to access Google Cloud Platform (GCP). EMR from AWS plays similar roles as dataproc from GCP. You can following steps to lunch a jupyter/PySpark note book on a AWS EMR cluster.

1, Create an AWS account and sign in to the console. (Note: you need to provide credit card details to create an account.)

2, Follow the step-by-step guidance from this [instruction](https://towardsdatascience.com/getting-started-with-pyspark-on-amazon-emr-c85154b6b921) to lunch a jupyter/Pyspark notebook on a AWS EMR cluster. (Note: check carefully how much it will cost for different types of instances from this [link](https://aws.amazon.com/emr/pricing/)! For example, this [instruction](https://towardsdatascience.com/getting-started-with-pyspark-on-amazon-emr-c85154b6b921) uses m5.xlarge instances, which will cost $0.192 per hour.)

3, Last but not least! Delete all buckets and clusters after you use them to avoid a huge bill!!!
