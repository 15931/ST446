# ST446 Distributed Computing for Big Data

## Seminar class 4: Hive using GCP

Reference:

* [Hive on GCP](https://cloud.google.com/sdk/gcloud/reference/beta/dataproc/jobs/submit/hive)
* [Getting started with Hive on Gogle Cloud Dataproc](http://holowczak.com/getting-started-with-hive-on-google-cloud-dataproc/6/)

## Preparation
* Create your own cluster and bucket. See [google_cloud_platform_class_activity.md](../../Week01/class/google_cloud_platform_class_activity.md) from Week 1.

Here, I will call the cluster `jialin-cluster` and the bucket `gs://jialin-bucket`.

* Make sure the `author_large.txt` is in your GCP bucket. If not, copy it to your bucket:

  ```
  gsutil cp [path of author_large.txt] gs://[your bucket name]/data/author_large.txt
  ```
  It is important that the file lives in a sub-directory of the bucket (here called `/data`).

* Please make sure to delete the cluster and bucket after you are done with all of this week's exercises!

## 1. Submit a Hive job with a file

Here we create a table using [dblp_gcp.q](dblp_gcp.q). 

The first step is to have a look at the file and edit it to reflect your bucket name: replace `'gs://jialin-bucket/data/';` with your GCP bucket name and folder in which you put `author-large.txt`


Then submit the Hive job by running the following commands in terminal of your laptop:

```
gcloud beta dataproc jobs submit hive --cluster [your cluster name] --file [path/to/dblp_gcp.q]
```
the results are as follows:

```
gcloud beta dataproc jobs submit hive --cluster jialin-cluster --file /Users/st446/Documents/ST446/lectures2020/Week04/class/dblp_gcp.q

Job [1d330ba4d979400db870d2919d41a996] submitted.
Waiting for job output...
Connecting to jdbc:hive2://jialin-cluster-m:10000
Connected to: Apache Hive (version 2.3.6)
Driver: Hive JDBC (version 2.3.6)
Transaction isolation: TRANSACTION_REPEATABLE_READ
0: jdbc:hive2://jialin-cluster-m:10000> CREATE DATABASE IF NOT EXISTS dblp;
No rows affected (0.135 seconds)
0: jdbc:hive2://jialin-cluster-m:10000> 
0: jdbc:hive2://jialin-cluster-m:10000> USE dblp;
No rows affected (0.045 seconds)
0: jdbc:hive2://jialin-cluster-m:10000> 
0: jdbc:hive2://jialin-cluster-m:10000> DROP TABLE IF EXISTS authorlarge;
No rows affected (0.048 seconds)
0: jdbc:hive2://jialin-cluster-m:10000> 
0: jdbc:hive2://jialin-cluster-m:10000> CREATE EXTERNAL TABLE authorlarge (
. . . . . . . . . . . . . . . . . . . >   author STRING,
. . . . . . . . . . . . . . . . . . . >   journal STRING,
. . . . . . . . . . . . . . . . . . . >   title STRING,
. . . . . . . . . . . . . . . . . . . >   year INT
. . . . . . . . . . . . . . . . . . . >   )
Y '\t'. . . . . . . . . . . . . . . . > ROW FORMAT DELIMITED FIELDS TERMINATED B 
. . . . . . . . . . . . . . . . . . . > LOCATION 'gs://jialin-bucket/data/';
No rows affected (1.691 seconds)
0: jdbc:hive2://jialin-cluster-m:10000> 
0: jdbc:hive2://jialin-cluster-m:10000> Closing: 0: jdbc:hive2://jialin-cluster-m:10000
Job [1d330ba4d979400db870d2919d41a996] finished successfully.
driverControlFilesUri: gs://jialin-bucket/google-cloud-dataproc-metainfo/4778b388-4a34-467a-8ba2-6a71a47fdccb/jobs/1d330ba4d979400db870d2919d41a996/
driverOutputResourceUri: gs://jialin-bucket/google-cloud-dataproc-metainfo/4778b388-4a34-467a-8ba2-6a71a47fdccb/jobs/1d330ba4d979400db870d2919d41a996/driveroutput
hiveJob:
  queryFileUri: gs://jialin-bucket/google-cloud-dataproc-metainfo/4778b388-4a34-467a-8ba2-6a71a47fdccb/jobs/1d330ba4d979400db870d2919d41a996/staging/dblp_gcp.q
jobUuid: 6b40098b-680f-3f24-ac5f-c2d9e824b037
placement:
  clusterName: jialin-cluster
  clusterUuid: 4778b388-4a34-467a-8ba2-6a71a47fdccb
reference:
  jobId: 1d330ba4d979400db870d2919d41a996
  projectId: st446-lent
status:
  state: DONE
  stateStartTime: '2020-02-13T14:31:45.015Z'
statusHistory:
- state: PENDING
  stateStartTime: '2020-02-13T14:31:36.757Z'
- state: SETUP_DONE
  stateStartTime: '2020-02-13T14:31:36.800Z'
- details: Agent reported job success
  state: RUNNING
  stateStartTime: '2020-02-13T14:31:37.079Z'
submittedBy: jason.yijialin@gmail.com
```

## 2. Submit a Hive job with a Hive command

### `show database` command

Now, we show all the databases by running on your laptop:
```
gcloud beta dataproc jobs submit hive --cluster [your cluster name] -e "show databases;"
```


```
(base) LSE021353-2:class st446$ gcloud beta dataproc jobs submit hive --cluster jialin-cluster -e "show databases;"
Job [fc9320e9460943fa8aab9484a889b80c] submitted.
Waiting for job output...
Connecting to jdbc:hive2://jialin-cluster-m:10000
Connected to: Apache Hive (version 2.3.6)
Driver: Hive JDBC (version 2.3.6)
Transaction isolation: TRANSACTION_REPEATABLE_READ
+----------------+
| database_name  |
+----------------+
| dblp           |
| default        |
+----------------+
2 rows selected (0.305 seconds)
Beeline version 2.3.6 by Apache Hive
Closing: 0: jdbc:hive2://jialin-cluster-m:10000
Job [fc9320e9460943fa8aab9484a889b80c] finished successfully.
driverControlFilesUri: gs://jialin-bucket/google-cloud-dataproc-metainfo/4778b388-4a34-467a-8ba2-6a71a47fdccb/jobs/fc9320e9460943fa8aab9484a889b80c/
driverOutputResourceUri: gs://jialin-bucket/google-cloud-dataproc-metainfo/4778b388-4a34-467a-8ba2-6a71a47fdccb/jobs/fc9320e9460943fa8aab9484a889b80c/driveroutput
hiveJob:
  queryList:
    queries:
    - show databases;
jobUuid: 99895cd6-5370-37cb-a18f-4450814263d0
placement:
  clusterName: jialin-cluster
  clusterUuid: 4778b388-4a34-467a-8ba2-6a71a47fdccb
reference:
  jobId: fc9320e9460943fa8aab9484a889b80c
  projectId: st446-lent
status:
  state: DONE
  stateStartTime: '2020-02-13T14:37:37.727Z'
statusHistory:
- state: PENDING
  stateStartTime: '2020-02-13T14:37:31.567Z'
- state: SETUP_DONE
  stateStartTime: '2020-02-13T14:37:31.598Z'
- details: Agent reported job success
  state: RUNNING
  stateStartTime: '2020-02-13T14:37:31.881Z'
submittedBy: jason.yijialin@gmail.com
```

### `select` command
Next, we show the first 10 rows of the *authorlarge* table

```
(base) LSE021353-2:class st446$ gcloud beta dataproc jobs submit hive --cluster jialin-cluster -e "use dblp; select * from authorlarge limit 10;"
Job [8cd59c33bc5c4c43bc87b029a98a0d83] submitted.
Waiting for job output...
Connecting to jdbc:hive2://jialin-cluster-m:10000
Connected to: Apache Hive (version 2.3.6)
Driver: Hive JDBC (version 2.3.6)
Transaction isolation: TRANSACTION_REPEATABLE_READ
No rows affected (0.084 seconds)
+-----------------------+--------------------------+----------------------------------------------------+-------------------+
|  authorlarge.author   |   authorlarge.journal    |                 authorlarge.title                  | authorlarge.year  |
+-----------------------+--------------------------+----------------------------------------------------+-------------------+
| Jurgen Annevelink     | Modern Database Systems  | Object SQL - A Language for the Design and Implementation of Object Databases. | 1995              |
| Rafiul Ahad           | Modern Database Systems  | Object SQL - A Language for the Design and Implementation of Object Databases. | 1995              |
| Amelia Carlson        | Modern Database Systems  | Object SQL - A Language for the Design and Implementation of Object Databases. | 1995              |
| Daniel H. Fishman     | Modern Database Systems  | Object SQL - A Language for the Design and Implementation of Object Databases. | 1995              |
| Michael L. Heytens    | Modern Database Systems  | Object SQL - A Language for the Design and Implementation of Object Databases. | 1995              |
| William Kent          | Modern Database Systems  | Object SQL - A Language for the Design and Implementation of Object Databases. | 1995              |
| Jos A. Blakeley       | Modern Database Systems  | OQL[C++]: Extending C++ with an Object Query Capability. | 1995              |
| Yuri Breitbart        | Modern Database Systems  | Transaction Management in Multidatabase Systems.   | 1995              |
| Hector Garcia-Molina  | Modern Database Systems  | Transaction Management in Multidatabase Systems.   | 1995              |
| Abraham Silberschatz  | Modern Database Systems  | Transaction Management in Multidatabase Systems.   | 1995              |
+-----------------------+--------------------------+----------------------------------------------------+-------------------+
10 rows selected (3.741 seconds)
Beeline version 2.3.6 by Apache Hive
Closing: 0: jdbc:hive2://jialin-cluster-m:10000
Job [8cd59c33bc5c4c43bc87b029a98a0d83] finished successfully.
driverControlFilesUri: gs://jialin-bucket/google-cloud-dataproc-metainfo/4778b388-4a34-467a-8ba2-6a71a47fdccb/jobs/8cd59c33bc5c4c43bc87b029a98a0d83/
driverOutputResourceUri: gs://jialin-bucket/google-cloud-dataproc-metainfo/4778b388-4a34-467a-8ba2-6a71a47fdccb/jobs/8cd59c33bc5c4c43bc87b029a98a0d83/driveroutput
hiveJob:
  queryList:
    queries:
    - use dblp; select * from authorlarge limit 10;
jobUuid: 605c52d5-92c6-30a8-8e19-2040af754cdc
placement:
  clusterName: jialin-cluster
  clusterUuid: 4778b388-4a34-467a-8ba2-6a71a47fdccb
reference:
  jobId: 8cd59c33bc5c4c43bc87b029a98a0d83
  projectId: st446-lent
status:
  state: DONE
  stateStartTime: '2020-02-13T14:40:03.575Z'
statusHistory:
- state: PENDING
  stateStartTime: '2020-02-13T14:39:53.398Z'
- state: SETUP_DONE
  stateStartTime: '2020-02-13T14:39:53.432Z'
- details: Agent reported job success
  state: RUNNING
  stateStartTime: '2020-02-13T14:39:53.715Z'
submittedBy: jason.yijialin@gmail.com
```

This should look familiar!
