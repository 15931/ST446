**ST446 Distributed Computing for Big Data**, LT 2021

# Seminar class 4

This week we are looking at [Hive](https://hive.apache.org/), a data warehouse system built on top of Hadoop. You can think of Hive as a collection of software that lets you interact with HDFS storage in an easy, SQL-like manner.

We will also look at [Spark Dataframes](https://spark.apache.org/docs/2.3.0/sql-programming-guide.html), which have more structure than RDDs, and can be thought of as two-dimensional arrays/tables.

## 0. Preparation (before class)

Before the class, please do the following:

1. Please make sure you have Hadoop and PySpark ready (See [hadoop_class_activity.md](../../Week02/class/hadoop_class_activity.md) and [InstallingSpark.pdf](../../Week03/class/InstallingSpark.pdf))

2. If you would like to use Hive on your own computer, please read [install_hive.md](install_hive.md). Follow it to install Hive and test if your installation is successful.

<!--- 3. Make sure that you managed to accept week 4's assignment on GitHub classoom and upload/push a file. Please let us know, if you have problems. -->


## 1. Hive (in class)

* Try to run Hive on GCP following the instructions in [hive_gcp.md](hive_gcp.md)

* Read and following the instructions in [hive-class-activity.md](hive-class-activity.md)

## 2. Spark Dataframes (in class)

Compared to RDDs, DataFrames are a more structured way to interact with data.
Go to [spark-dataframe-sql.ipynb](spark-dataframe-sql.ipynb).
We will walk you through the notebook.

## 3. Use Spark with Hive (homework, or in class if you have time.)

Have a look at this notebook and run it on a cluster [spark-hive-conn.ipynb](spark-hive-conn.ipynb). You will learn how to use SQL-like queries.

## References

* [Comparing Apache Hive vs. Spark](https://logz.io/blog/hive-vs-spark/#:~:text=Hive%20and%20Spark%20are%20both,more%20modern%20alternative%20to%20MapReduce.)
* [System Properties Comparison HBase vs. Hive vs. Spark SQL](https://db-engines.com/en/system/HBase%3BHive%3BSpark+SQL)
* [Apache Iceberg](https://www.datanami.com/2021/02/08/apache-iceberg-the-hub-of-an-emerging-data-service-ecosystem/) - The Hub of an Emerging Data Service Ecosystem?
* [Apache Iceberg (Dremio Free Trial)](https://www.dremio.com/data-lake/apache-iceberg/)
* [Introduction to DataFrames - Databricks](https://docs.databricks.com/spark/latest/dataframes-datasets/introduction-to-dataframes-python.html)


## Note that there is a formative assignment is coming up. You will receive a GitHub classroom invite via e-mail.
