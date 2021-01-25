# ST446 Distributed Computing for Big Data

## Seminar class 2: getting started with Apache Hadoop

In this class exercise, you will:

* gain hands-on experience working with the Apache Hadoop Distributed File System (HDFS)

* get a better understanding of distributed file systems in general and

* learn how to run a simple MapReduce job on Hadoop. This is an example of a batch processing job.

# 0. Preparation (pre class)
Please try to complete this section before class.

Google cloud platform dataproc is a fast, easy-to-use, fully-managed cloud service for running Apache Spark and Apache Hadoop clusters in a simple, cost-efficient way.
During last week's class, we have already learned how to set up a dataproc cluster. This type of cluster comes with Hadoop installed.

Before the class, please try to follow these steps.

Set up a dataproc cluster as discussed last week. To avoid following the same steps again, it is a good idea to use and save gcloud terminal commands.

```
gcloud beta dataproc clusters create jialin-cluster --optional-components=ANACONDA,JUPYTER     --image-version=1.3     --enable-component-gateway  --bucket jialin-bucket --project st446-lent
```

Hadoop resource can be checked via the Web UI. To do this, you can go to the GCP console page and navigate to `Dataproc - Clusters` as we did to open jupyter notebook last week.

<img src="../figs/google_dataproc.png" style="width: 1000px;" alt="googledataproc">

<img src="../figs/google_hadoop_UI.png" style="width: 1000px;" alt="googlehadoopUI">

Clicking on `Utilities - Browse the file system`, we will see
<img src="../figs/hadoop_namenode.png" style="width: 1000px;" alt="hadoopnamenode">

Once you have stablished that you can run a dataproc cluster with hadoop, please delete it using the commands from last week. (DO IT when the class ends!)


# 1. HDFS (in class)

### Connect to remote host

To access the dataproc cluster, click Resources -> Computer Engines. Go to VM instances tab, and you will see several VM instances like in the following picture.

<img src="../figs/dataproc.png" style="width: 1000px;" alt="dataproc">

Clicking on the `SSH` will open a Linux terminal, which you have seen before.

Note that you can either use the terminal that opens up in a browser window, if you click SSH, or copy the terminal command from `View gcloud command` and ssh into the VM from your own terminal. Both worked for me (Jialin).

```
(base) LSE021353-2:~ st446$ gcloud beta compute --project "st446-lent" ssh --zone "europe-west2-a" "jialin-cluster-m"
```

### Download dataset

Below we use the dataset `dblp` in our examples. You can download the `dblp.xml` from [http://dblp.uni-trier.de/xml/dblp.xml.gz](http://dblp.uni-trier.de/xml/dblp.xml.gz) and `author-large.txt` from [http://webdam.inria.fr/Jorge/files/author-large.txt](http://webdam.inria.fr/Jorge/files/author-large.txt) (by now you should know how to download a file from a command line, hints: `wget`).
(`gunzip -k dblp.xml.gz` lets you un-zip the file to get dblp.xml)

Put both files in the `dblp` directory.
By the end, you should see

```
st446@jialin-cluster-m:~$ ls -al dblp
total 3470692
drwxr-xr-x 2 st446 st446       4096 Jan 30 17:56 .
drwxr-xr-x 4 st446 st446       4096 Jan 30 17:56 ..
-rw-r--r-- 1 st446 st446  223281915 Mar 29  2016 author-large.txt
-rw-r--r-- 1 st446 st446 2787736891 Jan 29 23:01 dblp.xml
-rw-r--r-- 1 st446 st446  542948307 Jan 29 23:01 dblp.xml.gz
```


Like on your local file system, we can manipulate files in HDFS from a command line. Establish a SSH connection to your dataproc cluster before you try running the following commands.

## 1.A Basic HDFS commands

### Check version: `version`

To check the version of Hadoop installed on the cluster, run this command on your master node:
```
hadoop version
 ```
This command will yield this kind of output:

```
st446@jialin-cluster-m:~$ hadoop version
Hadoop 2.9.2
Subversion https://bigdataoss-internal.googlesource.com/third_party/apache/hadoop -r 849ee9eda72c7e8b1eb9fc5a830432c887914111
Compiled by bigtop on 2020-01-07T11:17Z
Compiled with protoc 2.5.0
From source with checksum 65eda08445b5ea54391fe9ba69cd7ad
This command was run using /usr/lib/hadoop/hadoop-common-2.9.2.jar
```

HDFS commands are very similar to  usual Linux commands. They can be run by using either `hadoop fs <args>` or `hdfs dfs <args>`. The former is generic and allows you to work with file systems other than HDFS, too (e.g. local file system or Amazon's S3a). The latter is specific to HDFS. One may also use `hadoop dfs` but this is deprecated. See discussion [here](https://stackoverflow.com/questions/18142960/whats-the-difference-between-hadoop-fs-shell-commands-and-hdfs-dfs-shell-co).


### List files: `ls`
```
hadoop fs -ls /
```

Example:
```
st446@jialin-cluster-m:~$ hadoop fs -ls /
```

```
Found 3 items
drwx------   - mapred hadoop          0 2020-01-30 17:29 /hadoop
drwxrwxrwt   - hdfs   hadoop          0 2020-01-30 17:29 /tmp
drwxrwxrwt   - hdfs   hadoop          0 2020-01-30 17:28 /user
```
The `/` is important.  It denotes the root directory.


### Upload / download files: `put` and `get`

Here we use `put` to upload the data `dplp/` from your remote host `st446@jialin-cluster-m` to your hadoop file system `/dblp`, using the command
```
hadoop fs -put dblp/ /dblp
```

Check the content of `/dblp` directory in HDFS: `hadoop fs -ls /dblp/*`

```
st446@jialin-cluster-m:~$ hadoop fs -ls /dblp/*
-rw-r--r--   2 st446 hadoop  223281915 2020-01-30 18:01 /dblp/author-large.txt
-rw-r--r--   2 st446 hadoop 2787736891 2020-01-30 18:01 /dblp/dblp.xml
-rw-r--r--   2 st446 hadoop  542948307 2020-01-30 18:01 /dblp/dblp.xml.gz
```

You may use `get` to download files:
```
hadoop fs -get /dblp
```

See [hadoop-common](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html#help) for `help` and other common commands: 


## 1.B. Some HDFS admin commands

### Generate a report of HDFS

Check the system administration report of your HDFS system by running the following command:

```
hdfs dfsadmin -report
```

Example:

```
st446@jialin-cluster-m:~$ hdfs dfsadmin -report
Configured Capacity: 1056751181824 (984.18 GB)
Present Capacity: 997560250002 (929.05 GB)
DFS Remaining: 990396678144 (922.38 GB)
DFS Used: 7163571858 (6.67 GB)
DFS Used%: 0.72%
Under replicated blocks: 0
Blocks with corrupt replicas: 0
Missing blocks: 0
Missing blocks (with replication factor 1): 0
Pending deletion blocks: 0

-------------------------------------------------
Live datanodes (2):

Name: 10.154.0.32:9866 (jialin-cluster-w-0.europe-west2-a.c.st446-lent.internal)
Hostname: jialin-cluster-w-0.europe-west2-a.c.st446-lent.internal
Decommission Status : Normal
Configured Capacity: 528375590912 (492.09 GB)
DFS Used: 3581785929 (3.34 GB)
Non DFS Used: 7997274295 (7.45 GB)
DFS Remaining: 495198343168 (461.19 GB)
DFS Used%: 0.68%
DFS Remaining%: 93.72%
Configured Cache Capacity: 0 (0 B)
Cache Used: 0 (0 B)
Cache Remaining: 0 (0 B)
Cache Used%: 100.00%
Cache Remaining%: 0.00%
Xceivers: 2
Last contact: Thu Jan 30 18:08:44 UTC 2020
Last Block Report: Thu Jan 30 17:28:50 UTC 2020


Name: 10.154.0.33:9866 (jialin-cluster-w-1.europe-west2-a.c.st446-lent.internal)
Hostname: jialin-cluster-w-1.europe-west2-a.c.st446-lent.internal
Decommission Status : Normal
Configured Capacity: 528375590912 (492.09 GB)
DFS Used: 3581785929 (3.34 GB)
Non DFS Used: 7997282487 (7.45 GB)
DFS Remaining: 495198334976 (461.19 GB)
DFS Used%: 0.68%
DFS Remaining%: 93.72%
Configured Cache Capacity: 0 (0 B)
Cache Used: 0 (0 B)
Cache Remaining: 0 (0 B)
Cache Used%: 100.00%
Cache Remaining%: 0.00%
Xceivers: 2
Last contact: Thu Jan 30 18:08:42 UTC 2020
Last Block Report: Thu Jan 30 17:28:42 UTC 2020
```

Observe that we are using three computers in total and there are two data nodes (workers) that we are seeing from the master node.

How to connect to the worker machine from the master machine? __Answer:__ use `ping` command. It small data packages to an IP address, from which they're sent back, and measures the time it takes.

```
st446@jialin-cluster-m:~$ ping 10.154.0.32
PING 10.154.0.32 (10.154.0.32) 56(84) bytes of data.
64 bytes from 10.154.0.32: icmp_seq=1 ttl=64 time=1.24 ms
64 bytes from 10.154.0.32: icmp_seq=2 ttl=64 time=0.211 ms
64 bytes from 10.154.0.32: icmp_seq=3 ttl=64 time=0.191 ms
64 bytes from 10.154.0.32: icmp_seq=4 ttl=64 time=0.203 ms
64 bytes from 10.154.0.32: icmp_seq=5 ttl=64 time=0.208 ms
^C
--- 10.154.0.32 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4058ms
rtt min/avg/max/mdev = 0.191/0.412/1.248/0.418 ms
```

### Check blocks and replications

You may also use the command `hdfs fsck /`.

Example:

```
st446@jialin-cluster-m:~$ hdfs fsck /
Connecting to namenode via http://jialin-cluster-m:9870/fsck?ugi=st446&path=%2F
FSCK started by st446 (auth:SIMPLE) from /10.154.0.34 for path / at Thu Jan 30 18:20:19 UTC 2020
.....Status: HEALTHY
 Total size:	3553967147 B
 Total dirs:	1031
 Total files:	5
 Total symlinks:		0
 Total blocks (validated):	30 (avg. block size 118465571 B)
 Minimally replicated blocks:	30 (100.0 %)
 Over-replicated blocks:	0 (0.0 %)
 Under-replicated blocks:	0 (0.0 %)
 Mis-replicated blocks:		0 (0.0 %)
 Default replication factor:	2
 Average block replication:	2.0
 Corrupt blocks:		0
 Missing replicas:		0 (0.0 %)
 Number of data-nodes:		2
 Number of racks:		1
FSCK ended at Thu Jan 30 18:20:19 UTC 2020 in 55 milliseconds


The filesystem under path '/' is HEALTHY
```

What does ` Default replication factor:	2` mean? __Answer:__ It means that by default, HDFS wants to keep two copies of every block in the configuration we're using here.


You may also check the information about a specific file using the command `hdfs fsck <filename> -files -blocks -racks`.

Example:

```
st446@jialin-cluster-m:~$ hdfs fsck /dblp/author-large.txt -files -blocks -racks
Connecting to namenode via http://jialin-cluster-m:9870/fsck?ugi=st446&files=1&blocks=1&racks=1&path=%2Fdblp%2Fauthor-large.txt
FSCK started by st446 (auth:SIMPLE) from /10.154.0.34 for path /dblp/author-large.txt at Thu Jan 30 18:24:59 UTC 2020
/dblp/author-large.txt 223281915 bytes, 2 block(s):  OK
0. BP-634013962-10.154.0.34-1580405307126:blk_1073741827_1003 len=134217728 Live_repl=2 [/default-rack/10.154.0.33:9866, /default-rack/10.154.0.32:9866]
1. BP-634013962-10.154.0.34-1580405307126:blk_1073741828_1004 len=89064187 Live_repl=2 [/default-rack/10.154.0.33:9866, /default-rack/10.154.0.32:9866]

Status: HEALTHY
 Total size:	223281915 B
 Total dirs:	0
 Total files:	1
 Total symlinks:		0
 Total blocks (validated):	2 (avg. block size 111640957 B)
 Minimally replicated blocks:	2 (100.0 %)
 Over-replicated blocks:	0 (0.0 %)
 Under-replicated blocks:	0 (0.0 %)
 Mis-replicated blocks:		0 (0.0 %)
 Default replication factor:	2
 Average block replication:	2.0
 Corrupt blocks:		0
 Missing replicas:		0 (0.0 %)
 Number of data-nodes:		2
 Number of racks:		1
FSCK ended at Thu Jan 30 18:24:59 UTC 2020 in 1 milliseconds


The filesystem under path '/dblp/author-large.txt' is HEALTHY
```

The line `Number of racks: 1` essentially means that both of the computers (nodes) sit on the same shelf (server rack).


To print the network topology information for your Hadoop cluster, run `hdfs dfsadmin -printTopology`.

Example:

```
st446@jialin-cluster-m:~$ hdfs dfsadmin -printTopology
Rack: /default-rack
   10.154.0.32:9866 (jialin-cluster-w-0.europe-west2-a.c.st446-lent.internal)
   10.154.0.33:9866 (jialin-cluster-w-1.europe-west2-a.c.st446-lent.internal)
```

You can see two different workers with different IP addresses.


**References**:
* Apache Hadoop docs: [File System Shell](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html)


# 2. Optional: Install Hadoop on your computer (this is not required, as you will use GCP)

You can install Hadoop on your own laptop. Installation on different systems may require some modification. You can find the installation guide for Mac OS Sierra (10.12.x) and Windows systems here: [Stand_alone_Hadoop_installation.md](Stand_alone_Hadoop_installation.md).

# 3. Running a MapReduce job

In this exercise, we will run a simple MapReduce job to count the number of times an author's name appear in the `dblp/author-large.txt` file. We will learn about MapReduce computation model in our next class.
This exercise only serves the purpose of getting started with running a MapReduce job on Hadoop that has input and output files in HDFS.

The file `author-large.txt` contains a list of authors and associated books. Here, we will make use of distributed computing to count the number of books per author and store them in multiple files.

But first, we'll have to compile some java code to run the computations on the dataproc cluster.



## 3.A. Create a jar file from the AuthorsJob.java

You need to download the java files and code from [AuthorsJob.java](AuthorsJob.java) to create a jar file.

### How to get files into the google cloud?
As an alternative to downloading files from GitHub, you can upload the files into a bucket and then download them onto the master node, like so:
On your computer, do something like this
```
gsutil cp * gs://jialin-bucket/
```
and on the VM, download the right files

```
st446@jialin-cluster-m:~$ gsutil cp gs://jialin-bucket/*.java .
Copying gs://jialin-bucket/AuthorsJob.java...
/ [1 files][  2.6 KiB/  2.6 KiB]                                                
Operation completed over 1 objects/2.6 KiB. 
```

Once your `.java` file is on the GCP VM, you can execute the following commands there.

### Compile the java code

First do the following
`export HADOOP_CLASSPATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar`.

You should be inside the directory that contains `AuthorsJob.java`.
Ignore the warnings that the java compiler yields.

Then you can run the following code to create all the required java files.

```
st446@jialin-cluster-m:~$ export HADOOP_CLASSPATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar
st446@jialin-cluster-m:~$ hadoop com.sun.tools.javac.Main AuthorsJob.java
Note: AuthorsJob.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
st446@jialin-cluster-m:~$ jar cf AuthorsJob.jar AuthorsJob*.class
st446@jialin-cluster-m:~$ ls -l
total 24
-rw-r--r-- 1 st446 st446 1729 Jan 30 18:46 AuthorsJob$AuthorsMapper.class
-rw-r--r-- 1 st446 st446 1563 Jan 30 18:46 AuthorsJob.class
-rw-r--r-- 1 st446 st446 1740 Jan 30 18:46 AuthorsJob$CountReducer.class
-rw-r--r-- 1 st446 st446 3111 Jan 30 18:47 AuthorsJob.jar
-rw-r--r-- 1 st446 st446 2652 Jan 30 18:45 AuthorsJob.java
drwxr-xr-x 2 st446 st446 4096 Jan 30 17:56 dblp
```

If you have difficulties in creating the jar file, you can download the jar file [here](AuthorsJob.jar)

## 3.C. Run the MapReduce job

Now that we have created the jar file from the java code, we can run it to count the numbers of books per author in the `author-large.txt` file.

Don't worry too much about what the java code does for now.

Generally, we run a jar file on hadoop using the `hadoop jar <jarFileName> <mainClassname> <input> <output>` command.

In our specific example, it should work with the following commands on GCP.

```
st446@jialin-cluster-m:~$ hadoop jar AuthorsJob.jar AuthorsJob /dblp/author-large.txt /dblp/author-output-large
20/01/30 18:49:08 INFO client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.0.34:8032
20/01/30 18:49:08 INFO client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.0.34:10200
20/01/30 18:49:08 WARN mapreduce.JobResourceUploader: Hadoop command-line option parsing not performed. Implement the Tool interface and execute your application with ToolRunner to remedy this.
20/01/30 18:49:08 INFO input.FileInputFormat: Total input files to process : 1
20/01/30 18:49:08 INFO mapreduce.JobSubmitter: number of splits:2
20/01/30 18:49:09 INFO Configuration.deprecation: yarn.resourcemanager.system-metrics-publisher.enabled is deprecated. Instead, use yarn.system-metrics-publisher.enabled
20/01/30 18:49:09 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1580405310004_0001
20/01/30 18:49:09 INFO impl.YarnClientImpl: Submitted application application_1580405310004_0001
20/01/30 18:49:09 INFO mapreduce.Job: The url to track the job: http://jialin-cluster-m:8088/proxy/application_1580405310004_0001/
20/01/30 18:49:09 INFO mapreduce.Job: Running job: job_1580405310004_0001
20/01/30 18:49:16 INFO mapreduce.Job: Job job_1580405310004_0001 running in uber mode : false
20/01/30 18:49:16 INFO mapreduce.Job:  map 0% reduce 0%
20/01/30 18:49:32 INFO mapreduce.Job:  map 50% reduce 0%
20/01/30 18:49:35 INFO mapreduce.Job:  map 100% reduce 0%
20/01/30 18:49:42 INFO mapreduce.Job:  map 100% reduce 29%
20/01/30 18:49:43 INFO mapreduce.Job:  map 100% reduce 57%
20/01/30 18:49:45 INFO mapreduce.Job:  map 100% reduce 71%
20/01/30 18:49:46 INFO mapreduce.Job:  map 100% reduce 86%
20/01/30 18:49:47 INFO mapreduce.Job:  map 100% reduce 100%
20/01/30 18:49:47 INFO mapreduce.Job: Job job_1580405310004_0001 completed successfully
20/01/30 18:49:47 INFO mapreduce.Job: Counters: 50
	File System Counters
		FILE: Number of bytes read=46846079
		FILE: Number of bytes written=95556966
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=223286231
		HDFS: Number of bytes written=9866278
		HDFS: Number of read operations=41
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=21
	Job Counters 
		Killed map tasks=1
		Launched map tasks=3
		Launched reduce tasks=7
		Data-local map tasks=3
		Total time spent by all maps in occupied slots (ms)=87069
		Total time spent by all reduces in occupied slots (ms)=127473
		Total time spent by all map tasks (ms)=29023
		Total time spent by all reduce tasks (ms)=42491
		Total vcore-milliseconds taken by all map tasks=29023
		Total vcore-milliseconds taken by all reduce tasks=42491
		Total megabyte-milliseconds taken by all map tasks=89158656
		Total megabyte-milliseconds taken by all reduce tasks=130532352
	Map-Reduce Framework
		Map input records=2225370
		Map output records=2225370
		Map output bytes=42395297
		Map output materialized bytes=46846121
		Input split bytes=220
		Combine input records=0
		Combine output records=0
		Reduce input groups=581765
		Reduce shuffle bytes=46846121
		Reduce input records=2225370
		Reduce output records=581765
		Spilled Records=4450740
		Shuffled Maps =14
		Failed Shuffles=0
		Merged Map outputs=14
		GC time elapsed (ms)=1796
		CPU time spent (ms)=44620
		Physical memory (bytes) snapshot=4653780992
		Virtual memory (bytes) snapshot=39679475712
		Total committed heap usage (bytes)=4260888576
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	File Input Format Counters 
		Bytes Read=223286011
	File Output Format Counters 
		Bytes Written=9866278
```

You will understand what this log is saying in the next week.

You should find the output file (with the path `/dblp/author-output-large`, as specified above) in the HDFS:

```
st446@jialin-cluster-m:~$ hadoop fs -ls /dblp/author-output-large
Found 8 items
-rw-r--r--   2 st446 hadoop          0 2020-01-30 18:49 /dblp/author-output-large/_SUCCESS
-rw-r--r--   2 st446 hadoop    1414197 2020-01-30 18:49 /dblp/author-output-large/part-r-00000
-rw-r--r--   2 st446 hadoop    1414935 2020-01-30 18:49 /dblp/author-output-large/part-r-00001
-rw-r--r--   2 st446 hadoop    1408102 2020-01-30 18:49 /dblp/author-output-large/part-r-00002
-rw-r--r--   2 st446 hadoop    1408265 2020-01-30 18:49 /dblp/author-output-large/part-r-00003
-rw-r--r--   2 st446 hadoop    1400456 2020-01-30 18:49 /dblp/author-output-large/part-r-00004
-rw-r--r--   2 st446 hadoop    1415529 2020-01-30 18:49 /dblp/author-output-large/part-r-00005
-rw-r--r--   2 st446 hadoop    1404794 2020-01-30 18:49 /dblp/author-output-large/part-r-00006
```

Download the output file `part-r-00000`:

```
st446@jialin-cluster-m:~$ hadoop fs -get /dblp/author-output-large/part-r-00000 part-r-00000
st446@jialin-cluster-m:~$ ls -l
total 1408
-rw-r--r-- 1 st446 st446    1729 Jan 30 18:46 AuthorsJob$AuthorsMapper.class
-rw-r--r-- 1 st446 st446    1563 Jan 30 18:46 AuthorsJob.class
-rw-r--r-- 1 st446 st446    1740 Jan 30 18:46 AuthorsJob$CountReducer.class
-rw-r--r-- 1 st446 st446    3111 Jan 30 18:47 AuthorsJob.jar
-rw-r--r-- 1 st446 st446    2652 Jan 30 18:45 AuthorsJob.java
drwxr-xr-x 2 st446 st446    4096 Jan 30 17:56 dblp
-rw-r--r-- 1 st446 st446 1414197 Jan 30 18:53 part-r-00000
```

Check the content of the output file:

```
st446@jialin-cluster-m:~$ less part-r-00000

. Akin  2
. Aydemir       2
. Belmonte Fernndez     1
. Michels       1
A-Youn Park     1
A. A. Abdel-Aziz        1
A. A. Adekunle  1
A. A. Alexanyan 1
A. A. Aziz      1
A. A. Babaev    1
A. A. Ball      2
A. A. Bolotov   1
A. A. Borsei    1
A. A. C. de Souza       1
A. A. Faieza    1
A. A. Fouda     1
A. A. Ghatol    1
A. A. Holzbacher        2
A. A. Ignatiev  2
A. A. Jennifer Adgey    2
A. A. Liapounov 1
A. A. M. Nurunnabi      1
A. A. Melikyan  1
A. A. Popov     1
A. A. Safavi    1
A. A. Silva Wagner      1
A. A. Stetsko   1
A. Abbassene    1
A. Abdulraheem  1
A. Abe  1
A. Abella       1
A. Adhipathi Reddy      2
```

The file contains key-value pairs where each key is an author's name and the corresponding value is the count of the number of occurrences of the author's name in the input file.

You will see that the number of output files on the dataproc cluster is larger than one. This is, because the job has been run by several workers in parallel.

## Afterwards, please make sure to delete all dataproc clusters.
