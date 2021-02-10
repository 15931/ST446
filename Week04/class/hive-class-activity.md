# ST446 Distributed Computing for Big Data
## Seminar class 4: Hive

Here, we will look at different ways to load data that comes in different formats and perform simple manipulations.

As usual, we will run a simple map-reduce job to count words.

# 1. Load the data
All the datasets are available from [here](https://www.dropbox.com/sh/89xbpcjl4oq0j4w/AACrbtUzm3oCW1OcpL7BasRfa?dl=0). Please download them to your cluster and save them to a directory as you go where your SQL files are before running the commands in this file.

## a. Facebook flow dataset

![Altoona Data Center](https://engineering.fb.com/wp-content/uploads/2018/05/data-center-shot.jpg)

Traffic flow data in the Facebook [Altoona Data Center](https://www.facebook.com/AltoonaDataCenter/).

Have a look at this [document](https://www.dropbox.com/sh/89xbpcjl4oq0j4w/AACTTp4wO6yCl0csvY1R6uGca/fbflow?dl=0&preview=README.docx&subfolder_nav_tracking=1) to see where it comes from. The flow data specifies what packet is sent from where to where at what time.

A fast way to download Facebook Flow dataset is using curl and then zip all files into a newly created `fbflow` folder:

```
st446@jialin-cluster-m:~$ curl -L -o dropboxdata.zip https://www.dropbox.com/sh/89xbpcjl4oq0j4w/AACTTp4wO6yCl0csvY1R6uGca/fbflow?dl=1 && unzip dropboxdata.zip -d fbflow
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
100 30.5M  100 30.5M    0     0  2465k      0  0:00:12  0:00:12 --:--:-- 4334k
Archive:  dropboxdata.zip
warning:  stripped absolute path spec from /
mapname:  conversion of  failed
 extracting: fbflow/README.docx      
 extracting: fbflow/10000000_220627975019916_5597249363521830912_n.bz2  
 extracting: fbflow/__MACOSX/._README.docx
```
Now all the files from the zipped dropbox file will be stored in `fbflow` folder

```
st446@jialin-cluster-m:~$ ls -al fbflow/
total 31256
drwxr-xr-x 3 st446 st446     4096 Feb 13 14:55 .
drwxr-xr-x 6 st446 st446     4096 Feb 13 14:55 ..
-rwxr--r-- 1 st446 st446 31898964 Feb  4  2017 10000000_220627975019916_5597249363521830912_n.bz2
drwxr-xr-x 2 st446 st446     4096 Feb 13 14:55 __MACOSX
-rwxr--r-- 1 st446 st446    92514 Feb  4  2017 README.docx
```

## b. Load fbflow data to a Hive table: `hive -f`


The Facebook flows dataset is in the format of a delimiter-separated text file, which can be loaded into a Hive table using the Hive commands given in the script [hive-fbflow.sql](hive-fbflow.sql). 

After uploading the `hive-fbflow.sql` to the cluster machine (see [how to upload files into GCP VMs here](https://cloud.google.com/compute/docs/instances/transfer-files)), you can create a table and load the data by executing the command:

```
hive -f hive-fbflow.sql
```

Example:

```
st446@jialin-cluster-m:~$ hive -f hive-fbflow.sql

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
OK
Time taken: 0.925 seconds
OK
Time taken: 0.057 seconds
OK
Time taken: 0.479 seconds
OK
Time taken: 0.516 seconds
Loading data to table fbflow.flows
OK
Time taken: 0.966 seconds
```

Looking at the databases, we can see that we have created a new one:

```
st446@jialin-cluster-m:~$ hive -e "show databases;"

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
OK
dblp
default
fbflow
Time taken: 1.075 seconds, Fetched: 3 row(s)
```
We also see that the `dblp` data we had submitted earlier is still around!

Looking at the first entries, we can see the structure of the data:

```
st446@jialin-cluster-m:~$ hive -e "use fbflow; select * from flows limit 10;"

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
OK
Time taken: 0.907 seconds
OK
1475378205	80	760af029f8c65f0b	09c61dc484e184c6	9374d216	71cf2dc9	6	d9ac464b	c0ff2d8e	44e830f8	bef209c1	cdb6761b	a26f9a59	1	1
1475378205	1025	760af029f8c65f0b	8e61d7f1179f6938	787294ad	8667ecd2	6	d9ac464b	3c52b4d4	44e830f8	6f147a0f	cdb6761b	51cb849f	1	1
1475378205	2750	760af029f8c65f0b	17e5f88ede51f96f	07ee83bf	53b20ee2	6	d9ac464b	5626c616	44e830f8	cd344ef1	cdb6761b	d2c039e9	0	0
1475378235	1500	399a2d8f40ca9903	144bf2176f929625	c41c76b9	89e10f4b	6	d9ac464b	3c52b4d4	cb2b3c29	084daf67	2c9f382f	ccb6f75c	1	1
1475378235	511	399a2d8f40ca9903	230532045b4603f4	c41c76b9	9a1aadde	6	d9ac464b	3c52b4d4	cb2b3c29	17386555	2c9f382f	7f59624f	1	1
1475378263	221	399a2d8f40ca9903	fbc7197a32334698	c8dc10dd	2b4155e8	6	d9ac464b	c0ff2d8e	cb2b3c29	24eced8d	2c9f382f	6ece8550	1	1
1475378263	695	399a2d8f40ca9903	d22c3f2aa6a44681	e6b85c49	a192c7c1	6	d9ac464b	3c52b4d4	cb2b3c29	eb09c1b9	2c9f382f	7f59624f	1	1
1475378228	80	399a2d8f40ca9903	b14b4ef33d689572	707eb0fe	e1c48341	6	d9ac464b	c0ff2d8e	cb2b3c29	f28ced04	2c9f382f	d52d0f42	1	1
1475378263	72	399a2d8f40ca9903	5c68d673932592ea	3af02c0b	e95b743d	6	d9ac464b	c0ff2d8e	cb2b3c29	fb488b74	2c9f382f	5be6af8c	1	0
1475378228	7212	399a2d8f40ca9903	508c415e9b2b21cd	54cc8db4	e829b054	6	d9ac464b	c0ff2d8e	cb2b3c29	35fc92d8	2c9f382f	64ade777	1	0
Time taken: 2.278 seconds, Fetched: 10 row(s)
```
This is data of packets being send around in clusters that form part of one of facebooks data centres. 

## c. Load three other datasets (this is your job!)

Create a table and load the data for the following three other datasets from [here](https://www.dropbox.com/sh/89xbpcjl4oq0j4w/AACrbtUzm3oCW1OcpL7BasRfa?dl=0):

* StackExchange users: [`hive-stackexchange.sql`](hive-stackexchange.sql) (note that this requires an additional python script `xml_mapper.py` to modify the xml files.)

* web logs: [`hive-weblogs.sql`](hive-weblogs.sql)
* dblp: [`hive-dblp.sql`](hive-dblp.sql) (this one should exist already by now!)

_Hints_:
This commands might help downloading the `StackExchange` data to your cluster:

```
curl -L -o dropboxdata.zip https://www.dropbox.com/sh/89xbpcjl4oq0j4w/AADH_WaHRE2rpOgkUUSmVmrsa/StackExchange-academic?dl=1 && unzip dropboxdata.zip -d StackExchange
```
change the command accordingly for `webblog` data and `dblp` data (look at the ST446 folder in Dropbox), at the end you should have 3 folders containing 3 data sets respectively.

```
st446@jialin-cluster-m:~$ ls -l
total 390736
-rw-r--r-- 1 st446 st446 223281915 Mar 29  2016 author-large.txt
-rw-r--r-- 1 st446 st446 176811939 Feb 13 16:39 dropboxdata.zip
drwxr-xr-x 3 st446 st446      4096 Feb 13 15:23 fbflow
-rw-r--r-- 1 st446 st446       532 Feb 13 14:50 hive-fbflow.sql
drwxr-xr-x 2 st446 st446      4096 Feb 13 16:38 StackExchange
drwxr-xr-x 2 st446 st446      4096 Feb 13 16:39 webserverlogs
```

Look at the hive script files: `hive-stackexchange.sql`,  `hive-weblogs.sql` , `hive-dblp.sql`and understand what is done in these scripts and what directories are needed.

Try to understand what the data sets are (based on the description in the dropbox directory).

## d. Check that the data is loaded correctly

#### Show all databases

```
st446@jialin-cluster-m:~$ hive

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
hive> SHOW DATABASES;
OK
dblp
default
fbflow
stackexchange
weblogs
Time taken: 0.574 seconds, Fetched: 5 row(s)
```

Below we use dblp as an example.
You can do the same for other Hive databases.

#### Work with  dblp database

```
hive> USE dblp;
OK
Time taken: 0.037 seconds
```

#### Show all tables in dblp

```
hive> SHOW TABLES;
OK
authorlarge
Time taken: 0.045 seconds, Fetched: 1 row(s)
```

#### See the schema of the table

```
hive> DESCRIBE authorlarge;
OK
author              	string              	                    
journal             	string              	                    
title               	string              	                    
year                	int                 	                    
Time taken: 0.042 seconds, Fetched: 4 row(s)
```

#### Show the first 10 rows

```
hive> SELECT * FROM authorlarge limit 10;
OK
Jurgen Annevelink	Modern Database Systems	Object SQL - A Language for the Design and Implementation of Object Databases.	1995
Rafiul Ahad	Modern Database Systems	Object SQL - A Language for the Design and Implementation of Object Databases1995
Amelia Carlson	Modern Database Systems	Object SQL - A Language for the Design and Implementation of Object Databases1995
Daniel H. Fishman	Modern Database Systems	Object SQL - A Language for the Design and Implementation of Object Databases.	1995
Michael L. Heytens	Modern Database Systems	Object SQL - A Language for the Design and Implementation of Object Databases.	1995
William Kent	Modern Database Systems	Object SQL - A Language for the Design and Implementation of Object Databases1995
Jos A. Blakeley	Modern Database Systems	OQL[C++]: Extending C++ with an Object Query Capability.	1995
Yuri Breitbart	Modern Database Systems	Transaction Management in Multidatabase Systems.	1995
Hector Garcia-Molina	Modern Database Systems	Transaction Management in Multidatabase Systems.	1995
Abraham Silberschatz	Modern Database Systems	Transaction Management in Multidatabase Systems.	1995
Time taken: 1.79 seconds, Fetched: 10 row(s)
```

# 2. Simple queries

Throughout this section, we use the dblp database.

### Count the number of rows in a table using *Count*

```
hive> SELECT Count(*) FROM authorlarge;
Query ID = fluid_20190203193118_e1862fe0-9b4e-4815-a0f0-f0866d7adee6
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1549217041670_0008)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      5          5        0        0       0       0  
Reducer 2 ...... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 11.62 s    
----------------------------------------------------------------------------------------------
OK
2225380
Time taken: 14.167 seconds, Fetched: 1 row(s)
```

### Count the number of distinct authors using *DISTINCT*

```
hive> SELECT Count(DISTINCT author) FROM authorlarge;
Query ID = fluid_20190203193330_ebf25dc5-464a-445e-8680-1b4aebb8b2b6
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1549217041670_0008)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      5          5        0        0       0       0  
Reducer 2 ...... container     SUCCEEDED      1          1        0        0       0       0  
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 15.29 s    
----------------------------------------------------------------------------------------------
OK
581765
Time taken: 15.972 seconds, Fetched: 1 row(s)
```
We see that there ratio of publications to distinct authors is about 3.8. That makes sense.

### Show the authors that have the highest number of published titles using *GROUP BY*
```
hive> SELECT author, Count(title) AS count FROM authorlarge GROUP BY author ORDER BY count DESC LIMIT 10;
Query ID = fluid_20190203193517_4436d2d5-e86a-4294-9528-77465ba6a9ed
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1549217041670_0008)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      5          5        0        0       0       0  
Reducer 2 ...... container     SUCCEEDED      1          1        0        0       0       0  
Reducer 3 ...... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 03/03  [==========================>>] 100%  ELAPSED TIME: 15.15 s    
----------------------------------------------------------------------------------------------
OK
Philip S. Yu	370
Wen Gao	370
Thomas S. Huang	368
Edwin R. Hancock	353
Mahmut T. Kandemir	346
Mario Piattini	320
Wei Li	319
Elisa Bertino	319
Sudhakar M. Reddy	314
Alberto L. Sangiovanni-Vincentelli	309
Time taken: 15.747 seconds, Fetched: 10 row(s)
```
This is the list of the top authors. This seems plausible, looking at [Philip S. Yu's](https://scholar.google.com/citations?user=D0lL1r0AAAAJ&hl=en) and [Wen Gao's](https://scholar.google.com/citations?user=b0vWahYAAAAJ&hl=en) publications.

Use command `exit;` to exit the Hive shell.

# 3. Transformation

You can explicitely specify a transformation by writing your own script. Here we demonstrate this for the Map-Reduce author count example that counts the number of publications per author. This is a more complicated way of arriving at the same result as before.

First upload `hiveMapper.py` and `word_count_reducer.py` to your master node.

Have a look at the two Python programs used to understand what's happening!

Then upload the file `hive-map-reduce.sql` to your master node. This file contains the following SQL commands:



```
USE dblp;
DROP TABLE IF EXISTS word_count;

CREATE TABLE word_count (
  word STRING,
  count INT
)
STORED AS TEXTFILE;

ADD FILE hiveMapper.py;
ADD FILE word_count_reducer.py;

FROM (
  FROM authorlarge
  MAP authorlarge.author
  USING 'hiveMapper.py'
  AS (word, count)
  CLUSTER BY word) map_output
INSERT OVERWRITE TABLE word_count  
  REDUCE map_output.word, map_output.count
  USING 'word_count_reducer.py'
  AS (word, count);

select * from word_count order by count desc limit 20;
```

Then run the code:


```
st446@jialin-cluster-m:~$ hive -f hive-map-reduce.sql 

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
OK
Time taken: 0.981 seconds
OK
Time taken: 0.231 seconds
OK
Time taken: 0.493 seconds
Added resources: [hiveMapper.py]
Added resources: [word_count_reducer.py]
Query ID = st446_20200213180743_df6a9dcc-b710-4434-8389-dd4b07e23b5a
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1581603498748_0014)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      5          5        0        0       0       0  
Reducer 2 ...... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 20.20 s    
----------------------------------------------------------------------------------------------
Loading data to table dblp.word_count
OK
Time taken: 29.539 seconds
Query ID = st446_20200213180813_db7b06c3-702f-4eb0-81a9-626f97104f42
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1581603498748_0014)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0  
Reducer 2 ...... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 1.47 s     
----------------------------------------------------------------------------------------------
OK
Philip S. Yu	370
Wen Gao	370
Thomas S. Huang	368
Edwin R. Hancock	353
Mahmut T. Kandemir	346
Mario Piattini	320
Wei Li	319
Elisa Bertino	319
Sudhakar M. Reddy	314
Alberto L. Sangiovanni-Vincentelli	309
Wei Wang	295
Jiawei Han	289
Makoto Takizawa	273
Irith Pomeranz	272
Wei Zhang	270
Lei Zhang	269
Ming Li	268
Li Zhang	267
Hai Jin	262
Hector Garcia-Molina	258
Time taken: 3.217 seconds, Fetched: 20 row(s)
```

As you can see, the output matches the output from before.

## Note on Hive output for StackExchange dataset
Note that the StackExchange data will take some time to process and will produce output similar to this:

```
st446@jialin-cluster-m:~$ hive -f hive-stackexchange.sql

Logging initialized using configuration in file:/etc/hive/conf.dist/hive-log4j2.properties Async: true
OK
Time taken: 0.906 seconds
OK
Time taken: 0.055 seconds
OK
Time taken: 0.276 seconds
OK
Time taken: 0.168 seconds
OK
Time taken: 0.467 seconds
OK
Time taken: 0.092 seconds
Added resources: [xml_mapper.py]
OK
Time taken: 0.059 seconds
OK
Time taken: 0.119 seconds
Loading data to table stackexchange.usersxml
OK
Time taken: 0.939 seconds
Query ID = st446_20200213174911_3bf1d482-dd87-456f-957a-0ffae8d43bc3
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1581603498748_0008)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 01/01  [==========================>>] 100%  ELAPSED TIME: 5.41 s     
----------------------------------------------------------------------------------------------
Loading data to table stackexchange.usersxml_prsd
OK
Time taken: 14.704 seconds
Query ID = st446_20200213174926_9e00f364-e6fe-459d-aa7f-2b60b4e6a683
Total jobs = 1
Launching Job 1 out of 1
Status: Running (Executing on YARN cluster with App id application_1581603498748_0008)

----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 01/01  [==========================>>] 100%  ELAPSED TIME: 45.42 s    
----------------------------------------------------------------------------------------------
Loading data to table stackexchange.users
OK
Time taken: 47.879 seconds
OK
Time taken: 0.136 seconds
OK
Time taken: 0.116 seconds

```
