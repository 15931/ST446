# ST446 Distributed Computing for Big Data

## Seminar class 3: MapReduce using Python

In this exercise, we learn how to run MapReduce jobs in Hadoop with *map()* and *reduce()* functions written in Python using the Hadoop Streaming API.

## 0. Background

![dblp](https://dblp.uni-trier.de/img/logo.320x120.png)

[DBLP](https://dblp.uni-trier.de/) is a computer science bibliography website. (Translate: Aha! It's a dataset about the computer scientists publication records)

<!--- ![milan](./figs/jeff.png) -->

How large is it?

- publications: 4,936,497
- authors: 2,441,360
- conferences: 5,879
- journals: 1,675

Imagine you are a data scientist in [Google Scholar](https://scholar.google.com/schhp?hl=en).

Boss: "We plan to add a killer feature to our website --- showing the number of publications for every [verified scholar](https://scholar.google.com/citations?user=z4JhSBwAAAAJ&hl=en&oi=ao) on our website. Can you do that?"

You: "Yeah...well...basically...."

A job-saver question: given many publication records, can we count the number of publications for each of the author?
 
We use the same dataset `author-large.txt` we used in our last week class exercise and show it how to save our jobs using `Hadoop` and `PySpark`

## 1. Writing map and reduce functions in Python

Download [myAggregatorForKeyCount.py](myAggregatorForKeyCount.py) and [modelReduce.py](modelReduce.py). Open these files and try to read and understand the code. What does it do?

Source: [Hadoop_Aggregate_Package](https://hadoop.apache.org/docs/current/hadoop-streaming/HadoopStreaming.html#Hadoop_Aggregate_Package)

Set up a Dataproc cluster, SSH into the master node and copy the Python files into the (remote) directory that you would like to work in.

An easy way to copy files onto the cluster's home directory is by using a bucket. See the [class tutorial in Week 1](../../Week01/class/google_cloud_platform_class_activity.md).

## 2. Checking the map and reduce functions by running them from a command line

Before we test the code, we should make sure `myAggregatorForKeyCount.py` and `modelReduce.py` are executable. You can check this using `ls -la`.

```
st446@jialin-cluster-m:~$ ls -l
total 8
-rw-r--r-- 1 st446 st446 1075 Feb  6 19:56 modelReduce.py
-rw-r--r-- 1 st446 st446  435 Feb  6 19:56 myAggregatorForKeyCount.py
```

If the permission of these two files indicates they are not executable (right permission should be `-rwxr-xr-x`), run:

```
st446@jialin-cluster-m:~$ chmod a+x *.py
```

Now they have the right permission

```
st446@jialin-cluster-m:~$ ls -l
total 8
-rwxr-xr-x 1 st446 st446 1075 Feb  6 19:56 modelReduce.py
-rwxr-xr-x 1 st446 st446  435 Feb  6 19:56 myAggregatorForKeyCount.py
```

You can download `author-large.txt` again from [here](http://webdam.inria.fr/Jorge/files/author-large.txt)

```
st446@jialin-cluster-m:~$ wget http://webdam.inria.fr/Jorge/files/author-large.txt
```


Next, we test the Python code for the __map__ step via the following command:

```
st446@jialin-cluster-m:~$ cat author-large.txt | ./myAggregatorForKeyCount.py > intermediate.txt
st446@jialin-cluster-m:~$ head intermediate.txt 
LongValueSum:Jurgen Annevelink	1
LongValueSum:Rafiul Ahad	1
LongValueSum:Amelia Carlson	1
LongValueSum:Daniel H. Fishman	1
LongValueSum:Michael L. Heytens	1
LongValueSum:William Kent	1
LongValueSum:Jos A. Blakeley	1
LongValueSum:Yuri Breitbart	1
LongValueSum:Hector Garcia-Molina	1
LongValueSum:Abraham Silberschatz	1
```

Do you understand what this command does? 
__Answer:__ It creates a tab-separated file with key-value pairs, where the key describes the Author name with some prefix and the value is the integer 1.

Next, let's sort the output of the map step (takes some time):

```
st446@jialin-cluster-m:~$ cat author-large.txt | ./myAggregatorForKeyCount.py | sort -k1,1 > intermediate.txt
st446@jialin-cluster-m:~$ head intermediate.txt 
LongValueSum:. Akin	1
LongValueSum:. Akin	1
LongValueSum:. Aydemir	1
LongValueSum:. Aydemir	1
LongValueSum:. Belmonte Fernndez	1
LongValueSum:. Chamberland	1
LongValueSum:. Erkan Mumcuoglu	1
LongValueSum:. Erkan Mumcuoglu	1
LongValueSum:. Glat	1
LongValueSum:. K. Co	1
```

Now, we use `modelReduce.py` to execute a __reduce__ step without making use of distributed computing. Note that when using Hadoop, we will use a built-in reducer (again, it takes some time).

```
st446@jialin-cluster-m:~$ cat author-large.txt | ./myAggregatorForKeyCount.py | sort -k1,1 | ./modelReduce.py > output.txt
st446@jialin-cluster-m:~$ head output.txt 
. Akin	2
. Aydemir	2
. Belmonte Fernndez	1
. Chamberland	1
. Erkan Mumcuoglu	2
. Glat	1
. K. Co	1
. Kovcs	1
. Lille	1
. Michels	1
```

Importantly, we got similar output to last week!

## 3. Running a MapReduce job in Hadoop

In order to run a MapReduce job on Hadoop with a __map__ function written in Python, we make use of the streaming Java executable. You may find out where it is in the following way:

```
st446@jialin-cluster-m:~$ export HADOOP_HOME="/usr/lib/hadoop-mapreduce/"
st446@jialin-cluster-m:~$ find $HADOOP_HOME -type f | grep streaming | grep jar
/usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar
```
Then you will get the path to the `jar` file: `/usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar`

Again, you should be able to understand the commands above.

Create a `dblp` folder, move the `author-large.txt` to the folder and copy the folder into the Hadoop file system, if you haven't done so yet.
(`hadoop fs -put dblp /dblp`)

Now, you may run the MapReduce job on Hadoop using the following command (**you may need to change the path to the right jar file found earlier**):

```
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar \
-input /dblp/author-large.txt \
-output /dblp/author-output-py \
-mapper myAggregatorForKeyCount.py \
-reducer aggregate \
-file myAggregatorForKeyCount.py
```

Observe that the mapper function was constructed in such a way that the **build-in** `aggregate` function sums up the values corresponding to matching keys.
Check out the documentation for [other aggregate functions](https://hadoop.apache.org/docs/current/api/org/apache/hadoop/mapred/lib/aggregate/package-summary.html).

You should get similar output to the following:

```
st446@jialin-cluster-m:~$ hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar \
> -input /dblp/author-large.txt \
> -output /dblp/author-output-py \
> -mapper myAggregatorForKeyCount.py \
> -reducer aggregate \
> -file myAggregatorForKeyCount.py
20/02/06 20:24:09 WARN streaming.StreamJob: -file option is deprecated, please use generic option -files instead.
packageJobJar: [myAggregatorForKeyCount.py] [/usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar] /tmp/streamjob5596096305766466401.jar tmpDir=null
20/02/06 20:24:10 INFO client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.0.44:8032
20/02/06 20:24:10 INFO client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.0.44:10200
20/02/06 20:24:11 INFO client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.0.44:8032
20/02/06 20:24:11 INFO client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.0.44:10200
20/02/06 20:24:11 INFO mapred.FileInputFormat: Total input files to process : 1
20/02/06 20:24:11 INFO net.NetworkTopology: Adding a new node: /default-rack/10.154.0.45:9866
20/02/06 20:24:11 INFO net.NetworkTopology: Adding a new node: /default-rack/10.154.0.46:9866
20/02/06 20:24:11 INFO mapreduce.JobSubmitter: number of splits:21
20/02/06 20:24:11 INFO Configuration.deprecation: yarn.resourcemanager.system-metrics-publisher.enabled is deprecated. Instead, use yarn.system-metrics-publisher.enabled
20/02/06 20:24:11 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1581018588210_0002
20/02/06 20:24:12 INFO impl.YarnClientImpl: Submitted application application_1581018588210_0002
20/02/06 20:24:12 INFO mapreduce.Job: The url to track the job: http://jialin-cluster-m:8088/proxy/application_1581018588210_0002/
20/02/06 20:24:12 INFO mapreduce.Job: Running job: job_1581018588210_0002
20/02/06 20:24:19 INFO mapreduce.Job: Job job_1581018588210_0002 running in uber mode : false
20/02/06 20:24:19 INFO mapreduce.Job:  map 0% reduce 0%
20/02/06 20:24:30 INFO mapreduce.Job:  map 5% reduce 0%
20/02/06 20:24:31 INFO mapreduce.Job:  map 14% reduce 0%
20/02/06 20:24:34 INFO mapreduce.Job:  map 29% reduce 0%
20/02/06 20:24:35 INFO mapreduce.Job:  map 33% reduce 0%
20/02/06 20:24:39 INFO mapreduce.Job:  map 43% reduce 0%
20/02/06 20:24:40 INFO mapreduce.Job:  map 48% reduce 0%
20/02/06 20:24:45 INFO mapreduce.Job:  map 57% reduce 0%
20/02/06 20:24:46 INFO mapreduce.Job:  map 67% reduce 0%
20/02/06 20:24:48 INFO mapreduce.Job:  map 76% reduce 0%
20/02/06 20:24:49 INFO mapreduce.Job:  map 81% reduce 0%
20/02/06 20:24:55 INFO mapreduce.Job:  map 86% reduce 0%
20/02/06 20:24:56 INFO mapreduce.Job:  map 95% reduce 0%
20/02/06 20:24:57 INFO mapreduce.Job:  map 100% reduce 0%
20/02/06 20:25:03 INFO mapreduce.Job:  map 100% reduce 14%
20/02/06 20:25:04 INFO mapreduce.Job:  map 100% reduce 29%
20/02/06 20:25:05 INFO mapreduce.Job:  map 100% reduce 43%
20/02/06 20:25:06 INFO mapreduce.Job:  map 100% reduce 57%
20/02/06 20:25:07 INFO mapreduce.Job:  map 100% reduce 71%
20/02/06 20:25:09 INFO mapreduce.Job:  map 100% reduce 86%
20/02/06 20:25:10 INFO mapreduce.Job:  map 100% reduce 100%
20/02/06 20:25:10 INFO mapreduce.Job: Job job_1581018588210_0002 completed successfully
20/02/06 20:25:10 INFO mapreduce.Job: Counters: 51
	File System Counters
		FILE: Number of bytes read=40623053
		FILE: Number of bytes written=87146088
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=223365872
		HDFS: Number of bytes written=9866278
		HDFS: Number of read operations=98
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=21
	Job Counters 
		Killed map tasks=1
		Killed reduce tasks=1
		Launched map tasks=21
		Launched reduce tasks=7
		Data-local map tasks=21
		Total time spent by all maps in occupied slots (ms)=584889
		Total time spent by all reduces in occupied slots (ms)=143373
		Total time spent by all map tasks (ms)=194963
		Total time spent by all reduce tasks (ms)=47791
		Total vcore-milliseconds taken by all map tasks=194963
		Total vcore-milliseconds taken by all reduce tasks=47791
		Total megabyte-milliseconds taken by all map tasks=598926336
		Total megabyte-milliseconds taken by all reduce tasks=146813952
	Map-Reduce Framework
		Map input records=2225370
		Map output records=2225370
		Map output bytes=66874367
		Map output materialized bytes=40623893
		Input split bytes=2037
		Combine input records=2225370
		Combine output records=1270718
		Reduce input groups=581765
		Reduce shuffle bytes=40623893
		Reduce input records=1270718
		Reduce output records=581765
		Spilled Records=2541436
		Shuffled Maps =147
		Failed Shuffles=0
		Merged Map outputs=147
		GC time elapsed (ms)=6239
		CPU time spent (ms)=104970
		Physical memory (bytes) snapshot=14142906368
		Virtual memory (bytes) snapshot=123392741376
		Total committed heap usage (bytes)=13154385920
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	File Input Format Counters 
		Bytes Read=223363835
	File Output Format Counters 
		Bytes Written=9866278
20/02/06 20:25:10 INFO streaming.StreamJob: Output directory: /dblp/author-output-py
```

Next, download the output to your local file system:

```
st446@jialin-cluster-m:~$ hadoop fs -get /dblp/author-output-py/part-0*
st446@jialin-cluster-m:~$ ls part* -al
-rw-r--r-- 1 st446 st446 1404622 Feb  6 20:34 part-00000
-rw-r--r-- 1 st446 st446 1417749 Feb  6 20:34 part-00001
-rw-r--r-- 1 st446 st446 1409610 Feb  6 20:34 part-00002
-rw-r--r-- 1 st446 st446 1406689 Feb  6 20:34 part-00003
-rw-r--r-- 1 st446 st446 1404832 Feb  6 20:34 part-00004
-rw-r--r-- 1 st446 st446 1412756 Feb  6 20:34 part-00005
-rw-r--r-- 1 st446 st446 1410020 Feb  6 20:34 part-00006
```

Why are there seven parts? 
__Answer:__ Because there were seven reducers.

Check that the output is the same output that you previously computed:

```
st446@jialin-cluster-m:~$ head part-00000
. Aydemir	2
. Kovcs	1
. Michels	1
A. A. Alexanyan	1
A. A. C. de Souza	1
A. A. El-Kadi	1
A. A. El-Sallam	1
A. A. Holzbacher-Valero	1
A. A. Klyachko	1
A. A. M. van der Wouden	1

st446@jialin-cluster-m:~$ head part-00001
. Skomedal	1
. Snchez	1
A. A. Abouda	1
A. A. Adams	2
A. A. Al Naamani	1
A. A. Allam	1
A. A. Anosov	1
A. A. Arroyo	1
A. A. Aziz	1
A. A. B. Prisker	1

st446@jialin-cluster-m:~$ head part-00006
A-Chuan Hsueh	1
A-Young Cho	3
A. A. Aaby	3
A. A. Abdel-Raouf	1
A. A. Adekunle	1
A. A. Babaev	1
A. A. Bolotov	1
A. A. Borsei	1so
A. A. Castro Jr.	1
A. A. Dorodnicyn	1
```


Now, let's see whether we can change the number of output files by modifying the number of reducers.

```
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar \
-D mapreduce.job.reduces=2 \
-input /dblp/author-large.txt \
-output /dblp/author-output-py-B \
-mapper myAggregatorForKeyCount.py \
-reducer aggregate \
-file myAggregatorForKeyCount.py
```

This yields very similar output:

```
st446@jialin-cluster-m:~$ hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar \
> -D mapreduce.job.reduces=2 \
> -input /dblp/author-large.txt \
> -output /dblp/author-output-py-B \
> -mapper myAggregatorForKeyCount.py \
> -reducer aggregate \
> -file myAggregatorForKeyCount.py

20/02/06 20:47:06 WARN streaming.StreamJob: -file option is deprecated, please use generic option -files instead.
packageJobJar: [myAggregatorForKeyCount.py] [/usr/lib/hadoop-mapreduce/hadoop-streaming-2.9.2.jar] /tmp/streamjob6714319566602390567.jar tmpDir=null
20/02/06 20:47:07 INFO client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.0.44:8032
20/02/06 20:47:07 INFO client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.0.44:10200
20/02/06 20:47:08 INFO client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.0.44:8032
20/02/06 20:47:08 INFO client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.0.44:10200
20/02/06 20:47:08 INFO mapred.FileInputFormat: Total input files to process : 1
20/02/06 20:47:08 INFO net.NetworkTopology: Adding a new node: /default-rack/10.154.0.45:9866
20/02/06 20:47:08 INFO net.NetworkTopology: Adding a new node: /default-rack/10.154.0.46:9866
20/02/06 20:47:08 INFO mapreduce.JobSubmitter: number of splits:21
20/02/06 20:47:08 INFO Configuration.deprecation: yarn.resourcemanager.system-metrics-publisher.enabled is deprecated. Instead, use yarn.system-metrics-publisher.enabled
20/02/06 20:47:09 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1581018588210_0003
20/02/06 20:47:09 INFO impl.YarnClientImpl: Submitted application application_1581018588210_0003
20/02/06 20:47:09 INFO mapreduce.Job: The url to track the job: http://jialin-cluster-m:8088/proxy/application_1581018588210_0003/
20/02/06 20:47:09 INFO mapreduce.Job: Running job: job_1581018588210_0003
20/02/06 20:47:15 INFO mapreduce.Job: Job job_1581018588210_0003 running in uber mode : false
20/02/06 20:47:15 INFO mapreduce.Job:  map 0% reduce 0%
20/02/06 20:47:25 INFO mapreduce.Job:  map 10% reduce 0%
20/02/06 20:47:26 INFO mapreduce.Job:  map 14% reduce 0%
20/02/06 20:47:27 INFO mapreduce.Job:  map 33% reduce 0%
20/02/06 20:47:33 INFO mapreduce.Job:  map 43% reduce 0%
20/02/06 20:47:34 INFO mapreduce.Job:  map 48% reduce 0%
20/02/06 20:47:36 INFO mapreduce.Job:  map 52% reduce 0%
20/02/06 20:47:37 INFO mapreduce.Job:  map 57% reduce 0%
20/02/06 20:47:39 INFO mapreduce.Job:  map 67% reduce 0%
20/02/06 20:47:40 INFO mapreduce.Job:  map 71% reduce 0%
20/02/06 20:47:41 INFO mapreduce.Job:  map 76% reduce 0%
20/02/06 20:47:43 INFO mapreduce.Job:  map 81% reduce 0%
20/02/06 20:47:47 INFO mapreduce.Job:  map 86% reduce 0%
20/02/06 20:47:49 INFO mapreduce.Job:  map 100% reduce 0%
20/02/06 20:47:56 INFO mapreduce.Job:  map 100% reduce 100%
20/02/06 20:47:56 INFO mapreduce.Job: Job job_1581018588210_0003 completed successfully
20/02/06 20:47:56 INFO mapreduce.Job: Counters: 50
	File System Counters
		FILE: Number of bytes read=40623023
		FILE: Number of bytes written=86089249
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=223365872
		HDFS: Number of bytes written=9866278
		HDFS: Number of read operations=73
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=6
	Job Counters 
		Killed map tasks=1
		Launched map tasks=21
		Launched reduce tasks=2
		Data-local map tasks=21
		Total time spent by all maps in occupied slots (ms)=551313
		Total time spent by all reduces in occupied slots (ms)=23478
		Total time spent by all map tasks (ms)=183771
		Total time spent by all reduce tasks (ms)=7826
		Total vcore-milliseconds taken by all map tasks=183771
		Total vcore-milliseconds taken by all reduce tasks=7826
		Total megabyte-milliseconds taken by all map tasks=564544512
		Total megabyte-milliseconds taken by all reduce tasks=24041472
	Map-Reduce Framework
		Map input records=2225370
		Map output records=2225370
		Map output bytes=66874367
		Map output materialized bytes=40623263
		Input split bytes=2037
		Combine input records=2225370
		Combine output records=1270718
		Reduce input groups=581765
		Reduce shuffle bytes=40623263
		Reduce input records=1270718
		Reduce output records=581765
		Spilled Records=2541436
		Shuffled Maps =42
		Failed Shuffles=0
		Merged Map outputs=42
		GC time elapsed (ms)=4845
		CPU time spent (ms)=89680
		Physical memory (bytes) snapshot=12643581952
		Virtual memory (bytes) snapshot=101248290816
		Total committed heap usage (bytes)=11789139968
	Shuffle Errors
		BAD_ID=0
		CONNECTION=0
		IO_ERROR=0
		WRONG_LENGTH=0
		WRONG_MAP=0
		WRONG_REDUCE=0
	File Input Format Counters 
		Bytes Read=223363835
	File Output Format Counters 
		Bytes Written=9866278
20/02/06 20:47:56 INFO streaming.StreamJob: Output directory: /dblp/author-output-py-B
```

Now we only get 2 files, as expected:

```
st446@jialin-cluster-m:~$ rm part*
st446@jialin-cluster-m:~$ hadoop fs -get /dblp/author-output-py-B/part-0*
st446@jialin-cluster-m:~$ ls part* -la
-rw-r--r-- 1 st446 st446 4925237 Feb  6 20:50 part-00000
-rw-r--r-- 1 st446 st446 4941041 Feb  6 20:50 part-00001

st446@jialin-cluster-m:~$ head part-00000
. Akin	2
. Aydemir	2
. Chamberland	1
. Erkan Mumcuoglu	2
. K. Co	1
. Michels	1
. Nikodemusz	1
. Snchez	1
A Min Tjoa	6
A-Ning Du	1

st446@jialin-cluster-m:~$ head part-00001
. Belmonte Fernndez	1
. Glat	1
. Kovcs	1
. Lille	1
. Mnsson	1
. Skomedal	1
. Weum	1
A-Chuan Hsueh	1
A-Imam Al-Sammak	1
A-Nasser Ansari	5
```

Do you think that for the given file size it made sense to use Hadoop? 
__Answer:__ Probably not, as running the Python commands from the terminal was faster than running the Hadoop streaming jobs.
