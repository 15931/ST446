**ST446 Distributed Computing for Big Data**, LT 2021

# Seminar class 3

This week, we will look at using Hadoop and PySpark for MapReduce type computations (for example on GCP). This will allow us to better understand the differences between the two.

TO DO: Pregel (week 5)....

[Spark](https://spark.apache.org/) is a fast, general purpose framework for data processing on clusters and can sit on top of different file systems. It uses in-memory processing and resilient distributed datasets (RDD).

As a rule of thumb, Spark is suitable for real-time/stream processing when a lot of RAM is available, whereas Hadoop is suited to batch processing on commodity hardware.

## 0. Preparation (before class)

Before the class, please do the following:


1. Make sure you have Hadoop ready (and in particular that you know how to get it to run on GCP, see [hadoop_class_activity.md](../../Week02/class/hadoop_class_activity.md)).

2. **(This is optional, as we will be using GCP. Clearly, if you use your own computer, you will not be able to take advantage of distributing computations between multiple machines.)**

If you would like to install PySpark on your computer please read [InstallingSpark.pdf](InstallingSpark.pdf), follow the installation instructions and test if your installation is successful.

The document suggests multiple ways to download PySpark. The easiest way should be to download the pre-built version from https://spark.apache.org/downloads.html. Because some of the information from [InstallingSpark.pdf](InstallingSpark.pdf) may not be up-to-date, please also check https://spark.apache.org/docs/latest/index.html.  

**(This is from Lent Term 2020)** If you can't manage to install PySpark and you are using Java9, you may try to use use Java8 instead. This is because PySpark may not be compatible with Java9. Check your Java version by ```java -version```. If you are currently using Java9, you can either uninstall Java9, or you can force your computer to use Java8 by changing the PATH variable in "~/.bash_profile"

## 1. Running MapReduce on Hadoop using Python (in class)

Read [word_count_python.md](word_count_python.md) and follow the instructions to run the same MapReduce job that we ran [last week](../../Week02/class/hadoop_class_activity.md).

## 2. Introduction to PySpark and RDD (in class)

For this exercise, we will run a PySpark notebook (remotely on a dataproc machine on GCP, or – if all else fails – on your own computer).  
Please let us know, if you have problems setting it up.

We will walk you through [pyspark_rdd.ipynb](pyspark_rdd.ipynb) during class.

## 3. Exercise: run MapReduce in PySpark (homework)

In this exercise, we use Pyspark for a simple MapReduce job. This will help you to get familiar with Pyspark and RDD.

### 3.1. Word count
In this exercise, you are asked to perform a word count on the same `author-large.txt` file we used for week 2 and this week. You can download it again from [this link](http://webdam.inria.fr/Jorge/files/author-large.txt). We would like to produce the same output as [here](https://github.com/lse-st446/lectures/blob/master/week03/class/word_count_python.md) but this time we will run it using Pyspark instead.

Hint:

* Make yourself familiar with Pyspark RDD. Also have a look at [DataCamp's PySpak cheat sheet](./PySparkCheatSheetPython.pdf).

* You may find the functions `.sortByKey()` and `.reduceByKey()` helpful.

### 3.2. Sort the word count output
Once your have successfully run the word count on PySpark, sort the output using Pyspark code. Show the 30 authors that appear most frequently in `author-large.txt`.

The solution will be available next class
