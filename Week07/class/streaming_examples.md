# Streaming data processing

Here we are going to demonstrate the use of PySpark streaming via the examples under `$SPARK_HOME/examples/src/main/python/streaming/`.

Please set up a *gcloud dataproc cluster* using the full command below. **Remember to set appropriate cluster and projects names, as well as choose the region you which your GCP project is running**. 

```
gcloud dataproc clusters create jialin-cluster --project st446-lent \
 --subnet default --zone europe-west2-a --master-machine-type n1-standard-4 --master-boot-disk-size 500 --num-workers 0 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 1.3-deb9 \
 --initialization-actions 'gs://dataproc-initialization-actions/jupyter/jupyter.sh','gs://dataproc-initialization-actions/python/pip-install.sh','gs://dataproc-initialization-actions/zookeeper/zookeeper.sh','gs://dataproc-initialization-actions/kafka/kafka.sh' \
 --metadata 'PIP_PACKAGES=sklearn nltk pandas graphframes pyspark kafka-python tweepy'
```

Observe this configuration uses only the master node and no worker nodes. This is sufficient for this week's task.

Also observe some flags and initialization actions we have included in this command, so we can install PySpark and get Kafka (which relies on Zookeper) running.

```
--initialization-actions 'gs://dataproc-initialization-actions/jupyter/jupyter.sh','gs://dataproc-initialization-actions/python/pip-install.sh','gs://dataproc-initialization-actions/zookeeper/zookeeper.sh','gs://dataproc-initialization-actions/kafka/kafka.sh' \
--metadata 'PIP_PACKAGES=sklearn nltk pandas graphframes pyspark kafka-python tweepy'
```
### 1. Streaming data processing using `PySpark`

#### 1.1. Basic streaming example

Go to your dataproc cluster details page and choose *VM INSTANCES*. You will see the master node of your cluster. Click on the SSH menu and choose *Open in a browser window*. We will call this tab as *tab #0*.

Go to directory the in which PySpark lives:

```
cd $SPARK_HOME
```

a. Take a look of the example (you can use the *vi* or *nano* editors):

```
vi examples/src/main/python/streaming/network_wordcount.py
```
You can exit `vi` by typing `:q` and pressing Enter. You can exit `nano` by typing `ctrl+x` and pressing Enter.

b. Open a new tab connecting to the cluster (called this *tab #1*). To do so, you can repeat the same process when opening the first tab OR you can click on the gear symbol in your current tab (*tab #0*) and choose *New connection to <your cluster name>*.
 
c. Run a Netcat server to send data at port 9999 in the *tab #1*:

```
nc -lk -p 9999
```
then leave the *tab #1* running.

d. Back to *tab #0*, run the following program to connect to port 9999 in the first console (the first screen).

```
unset PYSPARK_DRIVER_PYTHON
bin/spark-submit examples/src/main/python/streaming/network_wordcount.py localhost 9999
```

e. type something in the Netcat server console in *tab #1* (e.g. type a couple of times `hello hello world`) and hit return.

```
st446@jialin-cluster-m:~$ nc -lk -p 9999
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
hello hello hello world world
```

In the Python console (*tab #0*) you should get something like the following:

```
st446@jialin-cluster-m:/usr/lib/spark$ bin/spark-submit examples/src/main/python/streaming/network_wordcount.py localhost 9999
20/03/05 15:51:33 INFO org.spark_project.jetty.util.log: Logging initialized @2232ms
20/03/05 15:51:33 INFO org.spark_project.jetty.server.Server: jetty-9.3.z-SNAPSHOT, build timestamp: unknown, git hash: unknown
20/03/05 15:51:33 INFO org.spark_project.jetty.server.Server: Started @2319ms
20/03/05 15:51:33 INFO org.spark_project.jetty.server.AbstractConnector: Started ServerConnector@5c09a323{HTTP/1.1,[http/1.1]}{0.0.0.0:4040}
20/03/05 15:51:33 WARN org.apache.spark.scheduler.FairSchedulableBuilder: Fair Scheduler configuration file not found so jobs will be scheduled in FIFO order. To use fair scheduling, configure pools in fairscheduler.xml or set spark.scheduler.allocation.file to a file that contains the configuration.
20/03/05 15:51:34 INFO org.apache.hadoop.yarn.client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.15.212:8032
20/03/05 15:51:34 INFO org.apache.hadoop.yarn.client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.15.212:10200
20/03/05 15:51:36 INFO org.apache.hadoop.yarn.client.api.impl.YarnClientImpl: Submitted application application_1583421947446_0005
20/03/05 15:51:41 WARN org.apache.spark.streaming.StreamingContext: Dynamic Allocation is enabled for this application. Enabling Dynamic allocation for Spark Streaming applications can cause data loss if Write Ahead Log is not enabled for non-replayable sources like Flume. See the programming guide for details on how to enable the Write Ahead Log.
-------------------------------------------
Time: 2020-03-05 15:51:46
-------------------------------------------


[...]

-------------------------------------------
Time: 2020-03-05 15:51:58
-------------------------------------------
('world', 22)
('hello', 33)

-------------------------------------------
Time: 2020-03-05 15:51:59
-------------------------------------------
('world', 2)
('hello', 3)

-------------------------------------------
Time: 2020-03-05 15:52:00
-------------------------------------------
('', 1)

```
Observe that the stream is chopped into blocks of 1s duration.

Reference: [`network_wordcount.py`](https://github.com/apache/spark/blob/v2.2.1/examples/src/main/python/streaming/network_wordcount.py)

#### 1.2. DataFrames and SQL example

a. Interrupt the spark-client running in *tab #0* by `ctrl-c`.

b. Run the `sql_network_wordcount.py` with the procedure similar to above. (**You can keep netcat running from the previous task.**)
This example is very similar to the one above except this time we are using SQL and Dataframe to perform word counts.

```
unset PYSPARK_DRIVER_PYTHON
bin/spark-submit examples/src/main/python/streaming/sql_network_wordcount.py localhost 9999
```

For example, run it like this, in *tab #0*:

```
st446@jialin-cluster-m:/usr/lib/spark$ unset PYSPARK_DRIVER_PYTHON
st446@jialin-cluster-m:/usr/lib/spark$ bin/spark-submit examples/src/main/python/streaming/sql_network_wordcount.py localhost 9999
```

Then type a couple of words in *tab #1* that is running Netcat.

Sample output (yours could be different depending on the words you typed):

```
20/03/05 15:55:28 INFO org.spark_project.jetty.util.log: Logging initialized @2333ms
20/03/05 15:55:28 INFO org.spark_project.jetty.server.Server: jetty-9.3.z-SNAPSHOT, build timestamp: unknown, git hash: unknown
20/03/05 15:55:28 INFO org.spark_project.jetty.server.Server: Started @2420ms
20/03/05 15:55:28 INFO org.spark_project.jetty.server.AbstractConnector: Started ServerConnector@6157cfe4{HTTP/1.1,[http/1.1]}{0.0.0.0:4040}
20/03/05 15:55:28 WARN org.apache.spark.scheduler.FairSchedulableBuilder: Fair Scheduler configuration file not found so jobs will be scheduled in FIFO order. To use fair scheduling, configure pools in fairscheduler.xml or set spark.scheduler.allocation.file to a file that contains the configuration.
20/03/05 15:55:29 INFO org.apache.hadoop.yarn.client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.15.212:8032
20/03/05 15:55:29 INFO org.apache.hadoop.yarn.client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.15.212:10200
20/03/05 15:55:31 INFO org.apache.hadoop.yarn.client.api.impl.YarnClientImpl: Submitted application application_1583421947446_0006
20/03/05 15:55:37 WARN org.apache.spark.streaming.StreamingContext: Dynamic Allocation is enabled for this application. Enabling Dynamic allocation for Spark Streaming applications can cause data loss if Write Ahead Log is not enabled for non-replayable sources like Flume. See the programming guide for details on how to enable the Write Ahead Log.
========= 2020-03-05 15:55:42 =========
[...]
========= 2020-03-05 15:55:55 =========
+-----+-----+
| word|total|
+-----+-----+
|hello|   33|
|world|   22|
+-----+-----+

========= 2020-03-05 15:55:56 =========
+-----+-----+
| word|total|
+-----+-----+
|hello|    3|
|world|    2|
+-----+-----+
```

Reference: [`sql_network_wordcount.py`](https://github.com/apache/spark/blob/v2.2.1/examples/src/main/python/streaming/sql_network_wordcount.py)

#### 1.3. Stateful operations example

a. Interrupt the spark-client running in *tab #0* by `ctrl-c`.

b. Run the `stateful_network_wordcount.py`.
(`/usr/lib/sparkexamples/src/main/python/streaming/stateful_network_wordcount.py`)

```
bin/spark-submit examples/src/main/python/streaming/stateful_network_wordcount.py localhost 9999
```

In the previous examples, the count information is for each new stream. In this example, the count information is updated with the new stream.

In *tab #0*:

```
st446@jialin-cluster-m:/usr/lib/spark$ bin/spark-submit examples/src/main/python/streaming/stateful_network_wordcount.py localhost 9999
```


We can see that we are now keeping track of the word count, and by typing additional words in *tab #1*, it will be incremented:

```
20/03/05 16:00:03 INFO org.spark_project.jetty.util.log: Logging initialized @2326ms
20/03/05 16:00:03 INFO org.spark_project.jetty.server.Server: jetty-9.3.z-SNAPSHOT, build timestamp: unknown, git hash: unknown
20/03/05 16:00:03 INFO org.spark_project.jetty.server.Server: Started @2431ms
20/03/05 16:00:03 INFO org.spark_project.jetty.server.AbstractConnector: Started ServerConnector@17b3787b{HTTP/1.1,[http/1.1]}{0.0.0.0:4040}
20/03/05 16:00:04 WARN org.apache.spark.scheduler.FairSchedulableBuilder: Fair Scheduler configuration file not found so jobs will be scheduled in FIFO order. To use fair scheduling, configure pools in fairscheduler.xml or set spark.scheduler.allocation.file to a file that contains the configuration.
20/03/05 16:00:05 INFO org.apache.hadoop.yarn.client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.15.212:8032
20/03/05 16:00:05 INFO org.apache.hadoop.yarn.client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.15.212:10200
20/03/05 16:00:07 INFO org.apache.hadoop.yarn.client.api.impl.YarnClientImpl: Submitted application application_1583421947446_0007
20/03/05 16:00:12 WARN org.apache.spark.streaming.StreamingContext: Dynamic Allocation is enabled for this application. Enabling Dynamic allocation for Spark Streaming applications can cause data loss if Write Ahead Log is not enabled for non-replayable sources like Flume. See the programming guide for details on how to enable the Write Ahead Log.
-------------------------------------------
Time: 2020-03-05 16:05:14
-------------------------------------------
('world', 7)
('', 6)
('hello', 7)

-------------------------------------------
Time: 2020-03-05 16:05:15
-------------------------------------------
('world', 8)
('', 6)
('hello', 7)

-------------------------------------------
Time: 2020-03-05 16:05:16
-------------------------------------------
('world', 8)
('', 6)
('hello', 7)

-------------------------------------------
Time: 2020-03-05 16:05:17
-------------------------------------------
('world', 8)
('', 6)
('hello', 7)

```
**Check yourself:** What new information was typed in this example?

Reference: [`stateful_network_wordcount.py`](https://github.com/apache/spark/blob/v2.2.1/examples/src/main/python/streaming/stateful_network_wordcount.py)

#### 1.4. HDFS word count

In this example, the Python code will count words in all **newly** created files in a local directory which you provide. Here, we use a `~/tmp` directory created in the cluster. You can go to your $HOME directory in your cluster and type `mkdir tmp` to create this new directory.

a. Interrupt the spark-client running in *tab #0* by `ctrl-c`.

b. Run the example with the following code from `$SPARK_HOME` (**you will have to adjust the file:///path/tmp part to reflect your home directory and tmp folder**)

```
unset PYSPARK_DRIVER_PYTHON
bin/spark-submit examples/src/main/python/streaming/hdfs_wordcount.py "file:///path/tmp/"
```

Our input looks like this:

```
st446@jialin-cluster-m:/usr/lib/spark$ bin/spark-submit examples/src/main/python/streaming/hdfs_wordcount.py "file:///home/st446/tmp/"

20/03/05 18:17:26 INFO org.spark_project.jetty.util.log: Logging initialized @2335ms
20/03/05 18:17:26 INFO org.spark_project.jetty.server.Server: jetty-9.3.z-SNAPSHOT, build timestamp: unknown, git hash: unknown
20/03/05 18:17:26 INFO org.spark_project.jetty.server.Server: Started @2421ms
20/03/05 18:17:26 INFO org.spark_project.jetty.server.AbstractConnector: Started ServerConnector@17b3787b{HTTP/1.1,[http/1.1]}{0.0.0.0:4040}
20/03/05 18:17:26 WARN org.apache.spark.scheduler.FairSchedulableBuilder: Fair Scheduler configuration file not found so jobs will be scheduled in FIFO order. To use fair scheduling, configure pools in fairscheduler.xml or set spark.scheduler.allocation.file to a file that contains the configuration.
20/03/05 18:17:27 INFO org.apache.hadoop.yarn.client.RMProxy: Connecting to ResourceManager at jialin-cluster-m/10.154.15.213:8032
20/03/05 18:17:27 INFO org.apache.hadoop.yarn.client.AHSProxy: Connecting to Application History server at jialin-cluster-m/10.154.15.213:10200
20/03/05 18:17:29 INFO org.apache.hadoop.yarn.client.api.impl.YarnClientImpl: Submitted application application_1583426487359_0006
20/03/05 18:17:34 WARN org.apache.spark.streaming.StreamingContext: Dynamic Allocation is enabled for this application. Enabling Dynamic allocation for Spark Streaming applications can cause data loss if Write Ahead Log is not enabled for non-replayable sources like Flume. See the programming guide for details on how to enable the Write Ahead Log.
```

c. Interrupt the Netcat server in *tab #1* and input some words into a newly created file in one screen. Here we use `echo` and `pipe`:

```
st446@jialin-cluster-m:~$ echo "hello hello world" > ~/tmp/b
```

We get the following output after having created the file:

```
[...]
-------------------------------------------
Time: 2020-03-05 18:19:45
-------------------------------------------

20/03/05 18:19:46 INFO org.apache.hadoop.mapreduce.lib.input.FileInputFormat: Total input files to process : 1
-------------------------------------------
Time: 2020-03-05 18:19:46
-------------------------------------------
('world', 1)
('hello', 2)

-------------------------------------------
Time: 2020-03-05 18:19:47
-------------------------------------------

[...]
```

Reference: [`hdfs_wordcount.py`](https://github.com/apache/spark/blob/v2.2.1/examples/src/main/python/streaming/hdfs_wordcount.py)

### 2. Kafka

Apache Kafka is a distributed streaming platform. It lets you:

* publish and subscribe to streams of records. In this respect it is similar to a message queue or enterprise messaging system.
* store streams of records in a fault-tolerant way.
* process streams of records as they occur.

It allows you to build real-time streaming data pipelines that reliably get data between systems or applications. It can also let you build real-time streaming applications that transform or react to the streams of data

Take a look of [Apache-Kafka](https://kafka.apache.org/) to know more about `Kafka`.

#### A simple kafka example

##### a. Run Kafka and Zookeeper

In *tab #1*, interrupt the previous running program by `ctrl-c` and start a Kafka server by navigating to `/usr/lib/kafka` and running the command with root user permission:

```
cd /usr/lib/kafka
sudo -s
bin/kafka-server-start.sh config/server.properties &
```
then leave this *tab #1* there. 

##### b. Create a topic

In *tab #0*, create a topic named "test" with a single partition and only one replica:

```
cd /usr/lib/kafka
bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
```

You can see the topic by running the `list topic` command:

```
bin/kafka-topics.sh --list --zookeeper localhost:2181
```

##### c. Run a producer to send some messages

In *tab #0*, run a producer (`kafka-console-producer.sh`). It takes input from the standard input and sends it out as messages to the Kafka cluster. Type a few messages into the console to send to the server. By default, each line will be sent as a separate message.

```
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
```
We have done the following:

```
st446@jialin-cluster-m:/usr/lib/kafka$ bin/kafka-topics.sh --list --zookeeper localhost:2181
test
st446@jialin-cluster-m:/usr/lib/kafka$ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
>hello hello world
>bye bye bye
```

If you have followed these instructions, you should be able to receive the messages using a consumer. Open a new tab (call it *tab #2*) and run the following command `kafka-console-consumer.sh`:

```
cd /usr/lib/kafka
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```

In our case, it looks like this:

```
st446@jialin-cluster-m:~$ cd /usr/lib/kafka
st446@jialin-cluster-m:/usr/lib/kafka$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning

hello hello world
bye bye bye
```

##### d. Run the Pyspark Kafka example to receive from `localhost:2181` with topic `test`

In another new tab (call it *tab #3*), go back to `$SPARK_HOME`. Then use nano (or any other editor) to edit this config file:

```
cd $SPARK_HOME
sudo nano $SPARK_HOME/conf/spark-defaults.conf
```
at the very end of the file, append the follwing:
```
spark.jars.packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.3.0
```
to tell Spark to use the Kafka streaming JAR.

*Apparently, it is important that you use this version of the JAR, otherwise Java will present errors.*


Now, you can run a word count job in Kafka (make sure you are at `$SPARK_HOME`):

```
unset PYSPARK_DRIVER_PYTHON
bin/spark-submit examples/src/main/python/streaming/kafka_wordcount.py localhost:2181 test
```

If you now go to *tab #0* (where the Kafka producer is running) and type something like

```
hello hello world world world
```
and press enter, then the Kafka word counter in *tab #3* should give you output like this:

```
-------------------------------------------
Time: 2020-03-05 18:33:44
-------------------------------------------

-------------------------------------------
Time: 2020-03-05 18:33:45
-------------------------------------------
('world', 3)
('hello', 2)

-------------------------------------------
Time: 2020-03-05 18:33:46
-------------------------------------------

-------------------------------------------
Time: 2020-03-05 18:33:47
-------------------------------------------
```

**Now you can interrupt the running programs in all tabs.**

### 6. Twitter example (this part will still be revised before the class - 01/03/2021)

#### Streaming tweets and tokenising them

Now, we look at another streaming example. We stream Twitter data (live) and read tweets that involve `Trump`.

#### Preparation (before class): get your Twitter Developer Account credentials

You might need to apply for a [Twitter developer account and create a Twitter app](https://developer.twitter.com/en/apps/create) to access the required tokens and keys needed to this activity.

You will need to add your own `consumer_key`, `consumer_secret`, `access_token` and `access_token_secret` generated by Twitter to the Python file (see below). They all *should* look like gibberish.

#### Running the example (class activity)

As the previous `KafKa` example, we need launch the server:

```
cd /usr/lib/kafka
sudo -s
bin/kafka-server-start.sh config/server.properties &
```

Instead of using the built-in `console-producer`, here we use a producer that creates the topic and fetches the tweets about Trump in real time and send the tweets to the topic.

Run the [`kafka_twitter_producer.py`](kafka_twitter_producer.py) in `~` to get tweets from the twitter API

   * First, make sure you have installed the Python modules `kafka-python` and `tweepy`. This should already be completed, as part of the initialisation actions for the cluster at the beginning of this notebook.
   * Upload `kafka_twitter_producer.py` to your master node (though a bucket or clicking in the gear symbol in your SSH window). Update it with your own Twitter information (you can use the `nano` editor). See [access-tokens](https://developer.twitter.com/en/docs/basics/authentication/guides/access-tokens) for more details.
   * You will need to add your own `consumer_key`, `consumer_secret`, `access_token` and `access_token_secret` generated by Twitter to the Python file. See the steps in the *Preparation (before class) section*.
   * Have a look at the rest of the Python script and make sure that you understand it.
   * Run the `kafka_twitter_producer.py` with the command: `python kafka_twitter_producer.py`
   * It should print a lot of numbers to `stdout`which represent the lengths of tweets. Keep it running, as this is what streams tweets as a Kafka producer.

```
python kafka_twitter_producer.py
```

A list of integers are returned:
```
5166
5917
2540
15782
5504
6580
3246
8348
5456
12137
5045
15142
4248
9515
5744
4170
```
these integers are the length of the tweets.

If this is running, go to another screen, and look at
[kafka_twitter_consumer.py](kafka_twitter_consumer.py) and [kafka_twitter_analyser.py](kafka_twitter_analyser.py). 
Run them using Python and see what happens.

Results from `kafka_twitter_consumer.py`:

```
ConsumerRecord(topic='twitter-stream', partition=0, offset=9400, timestamp=1584082037111, timestamp_type=0, key=None, value=b'{"created_at":"Fri Mar 13 06:47:11 +0000 2020","id":1238355913519456257,"id_str":"1238355913519456257","text":"RT @ASlavitt: All of this could have ramped up and solved in January &amp; February and right now we would be talking about containment. We cou\\u2026","source":"\\u003ca href=\\"http:\\/\\/twitter.com\\/download\\/iphone\\" rel=\\"nofollow\\"\\u003eTwitter for iPhone\\u003c\\/a\\u003e","truncated":false,"in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":16622854,"id_str":"16622854","name":"Steffes","screen_name":"Steffes","location":"iPhone: 33.342518,-111.963112","url":null,"description":"I\'m Steffs","translator_type":"none","protected":false,"verified":false,"followers_count":230,"friends_count":490,"listed_count":8,"favourites_count":232597,"statuses_count":51713,"created_at":"Tue Oct 07 00:10:56 +0000 2008","utc_offset":null,"time_zone":null,"geo_enabled":true,"lang":null,"contributors_enabled":false,"is_translator":false,"profile_background_color":"9AE4E8","profile_background_image_url":"http:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png","profile_background_image_url_https":"https:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png","profile_background_tile":false,"profile_link_color":"DD2E44","profile_sidebar_border_color":"BDDCAD","profile_sidebar_fill_color":"DDFFCC","profile_text_color":"333333","profile_use_background_image":true,"profile_image_url":"http:\\/\\/pbs.twimg.com\\/profile_images\\/890047123667902464\\/nOWAA4QS_normal.jpg","profile_image_url_https":"https:\\/\\/pbs.twimg.com\\/profile_images\\/890047123667902464\\/nOWAA4QS_normal.jpg","profile_banner_url":"https:\\/\\/pbs.twimg.com\\/profile_banners\\/16622854\\/1432870151","default_profile":false,"default_profile_image":false,"following":null,"follow_request_sent":null,"notifications":null},"geo":null,"coordinates":null,"place":null,"contributors":null,"retweeted_status":{"created_at":"Fri Mar 13 03:26:34 +0000 2020","id":1238305425050808320,"id_str":"1238305425050808320","text":"All of this could have ramped up and solved in January &amp; February and right now we would be talking about containme\\u2026 https:\\/\\/t.co\\/ctNQVgBZd0","source":"\\u003ca href=\\"http:\\/\\/twitter.com\\/#!\\/download\\/ipad\\" rel=\\"nofollow\\"\\u003eTwitter for iPad\\u003c\\/a\\u003e","truncated":true,"in_reply_to_status_id":1238304906219528192,"in_reply_to_status_id_str":"1238304906219528192","in_reply_to_user_id":1383272101,"in_reply_to_user_id_str":"1383272101","in_reply_to_screen_name":"ASlavitt","user":{"id":1383272101,"id_str":"1383272101","name":"Andy Slavitt","screen_name":"ASlavitt","location":"Edina, MN and Washington, DC","url":"http:\\/\\/www.unitedstatesofcare.org","description":"Former Medicare, Medicaid & ACA head for Obama. Founded @usofcare & @townhallvntrs to make health care work. Never broke a website, only fixed a big one.","translator_type":"none","protected":false,"verified":true,"followers_count":242454,"friends_count":823,"listed_count":3294,"favourites_count":28901,"statuses_count":27967,"created_at":"Sat Apr 27 01:21:12 +0000 2013","utc_offset":null,"time_zone":null,"geo_enabled":false,"lang":null,"contributors_enabled":false,"is_translator":false,"profile_background_color":"C0DEED","profile_background_image_url":"http:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png","profile_background_image_url_https":"https:\\/\\/abs.twimg.com\\/images\\/themes\\/theme1\\/bg.png","profile_background_tile":false,"profile_link_color":"1DA1F2","profile_sidebar_border_color":"C0DEED","profile_sidebar_fill_color":"DDEEF6","profile_text_color":"333333","profile_use_background_image":true,"profile_image_url":"http:\\/\\/pbs.twimg.com\\/profile_images\\/1170550103800721409\\/gF6azei__normal.jpg","profile_image_url_https":"https:\\/\\/pbs.twimg.com\\/profile_images\\/1170550103800721409\\/gF6azei__normal.jpg","profile_banner_url":"https:\\/\\/pbs.twimg.com\\/profile_banners\\/1383272101\\/1568516684","default_profile":true,"default_profile_image":false,"following":null,"follow_request_sent":null,"notifications":null},"geo":null,"coordinates":null,"place":null,"contributors":null,"is_quote_status":false,"extended_tweet":{"full_text":"All of this could have ramped up and solved in January &amp; February and right now we would be talking about containment. We could have also allowed labs to produce tests earlier or gotten WHO tests.\\n\\nWe did not. Why? In part Federal workers could not be seen contradicting Trump. 4\\/","display_text_range":[0,284],"entities":{"hashtags":[],"urls":[],"user_mentions":[],"symbols":[]}},"quote_count":48,"reply_count":39,"retweet_count":1718,"favorite_count":6344,"entities":{"hashtags":[],"urls":[{"url":"https:\\/\\/t.co\\/ctNQVgBZd0","expanded_url":"https:\\/\\/twitter.com\\/i\\/web\\/status\\/1238305425050808320","display_url":"twitter.com\\/i\\/web\\/status\\/1\\u2026","indices":[121,144]}],"user_mentions":[],"symbols":[]},"favorited":false,"retweeted":false,"filter_level":"low","lang":"en"},"is_quote_status":false,"quote_count":0,"reply_count":0,"retweet_count":0,"favorite_count":0,"entities":{"hashtags":[],"urls":[],"user_mentions":[{"screen_name":"ASlavitt","name":"Andy Slavitt","id":1383272101,"id_str":"1383272101","indices":[3,12]}],"symbols":[]},"favorited":false,"retweeted":false,"filter_level":"low","lang":"en","timestamp_ms":"1584082031980"}\r\n', headers=[], checksum=None, serialized_key_size=-1, serialized_value_size=5385, serialized_header_size=-1)
```

And the outputs from `kafka_twitter_analyser.py`:

```
jason_yijialin@jialin-cluster-m:~$ python kafka_twitter_analyser.py 
[nltk_data] Downloading package stopwords to
[nltk_data]     /home/jason_yijialin/nltk_data...
[nltk_data]   Unzipping corpora/stopwords.zip.
[nltk_data] Downloading package punkt to
[nltk_data]     /home/jason_yijialin/nltk_data...
[nltk_data]   Unzipping tokenizers/punkt.zip.
consumer started
['rt', 'rbreich', 'obama', 'left', 'trump', 'growing', 'economy', 'shrinking', 'deficit', 'global', 'agreement', 'fight', 'climate', 'change']
['rt', 'cmclymer', 'let', 'people', 'angry', 'angry', 'donald', 'trump', 'intentionally', 'blocked', 'testing', 'cover', 'spread', 'deadly']
['rt', 'impeachmenthour', 'everyone', 'usa', 'understand', 'trump', 'refused', 'test', 'kits', 'world', 'health', 'org']
['rt', 'nbcnewsnow', 'us', 'supreme', 'court', 'trump', 'admin', 'continue', 'practice', 'returning', 'asylum', 'seekers', 'mexico', 'along', 'entire']
['rt', 'joenbc', 'npr', 'trump', 'push', 'aggressive', 'testing', 'testing', 'might', 'led', 'cases', 'discovered']
['rt', 'jonahfurman', 'event', 'pandemictriggered', 'recession', 'want', 'donald', 'trump', 'lies', 'crisis', 'funnels', 'wall', 'st']
['rt', 'brithume', 'jsolomonreports', 'comey', 'gmen', 'substantially', 'debunked', 'theory', 'campaign', 'conspired', 'moscow']
['rt', 'drutangathome', 'hey', 'sportz', 'ball', 'games', 'canceled', 'stuff', 'read']
['rt', 'tedlieu', 'behavior', 'realdonaldtrump', 'true', 'outrageous', 'cause', 'deaths', 'necessary', 'also', 'exact']
['rt', 'lizmair', 'number', 'comes', 'rnc', 'polling', 'small', 'dollar', 'donors', 'list', 'used', 'number', 'really']
['rt', 'palmerreport', 'donald', 'trump', 'day', 'far', 'stock', 'market', 'drops', 'points', 'trump', 'tweeting', 'attempted', 'coup', 'guy']
['marcorubio', 'perhaps', 'could', 'someone', 'team', 'even', 'knowledgeable', 'anticipate', 'plan', 'things', 'https']
['rt', 'sethabramson', 'major', 'breaking', 'news', 'npr', 'source', 'says', 'trump', 'blocked', 'coronavirus', 'testing', 'january', 'aid', 'reelection', 'chances']
['rt', 'jakedockter', 'trump', 'fucked', 'coronavirus', 'shown', 'fatal', 'flaw', 'treating', 'white', 'folks', 'america']
['rt', 'aslavitt', 'original', 'sin', 'trump', 'months', 'long', 'denial', 'dismantling', 'public', 'health', 'response', 'infrastructure']
['rt', 'repkatieporter', 'math', 'full', 'battery', 'coronavirus', 'testing', 'costs', 'minimum', 'also', 'legal', 'research']
['rt', 'joshuagreen', 'dow', 'futures', 'tanking', 'impossible', 'gains', 'trump', 'presidency', 'could', 'wiped']
['another', 'years', 'trump', 'seems', 'absolutely', 'worst', 'outcome', 'biden', 'rlly', 'ass', 'https']
['rt', 'preetbharara', 'dear', 'president', 'trump', 'talk', 'less', 'stop', 'lying', 'get', 'tested', 'tweet', 'elevate', 'science', 'fire', 'stephen', 'miller', 'prepare']
['rt', 'baddcompani', 'american', 'citizens', 'time', 'us', 'come', 'together', 'save', 'nation', 'trump', 'failed', 'mankind', 'failed']
['rt', 'meechebucco', 'https']
```

### Importing the Kafka twitter stream into PySpark streaming (homework)

Instead of using a Python script to consume messages, we can also pass them to PySpark as before.

a. Have a look at [kafka_twitter_pyspark.py](kafka_twitter_pyspark.py) and upload it to your dataproc cluster.

b. Download the NLTK data using the Python shell:

```
jason_yijialin@jialin-cluster-m:~$ python
Python 3.7.3 (default, Mar 27 2019, 22:11:17) 
[GCC 7.3.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import nltk
>>> nltk.download("stopwords")
[nltk_data] Downloading package stopwords to
[nltk_data]     /home/jason_yijialin/nltk_data...
[nltk_data]   Package stopwords is already up-to-date!
True
```

c. Copy them to `/home` directory:

```
jason_yijialin@jialin-cluster-m:~$ sudo cp -r nltk_data/ /home/
```

d. Then, `cd` to `$SPARK_HOME` and run it like so:

```
$ unset PYSPARK_DRIVER_PYTHON
$ bin/spark-submit ~/kafka_twitter_pyspark.py

```

make sure that you have append the spark-streaming jar file in the configuration file.

e. If it is running, you will get a stream of outputs with contents like this:

```
Time: 2020-03-13 06:57:00
-------------------------------------------
('rt', 2866)
('trump', 2093)
('https', 779)
('coronavirus', 751)
('testing', 400)
('president', 275)
('news', 265)
('breaking', 247)
('us', 246)
('donald', 245)
...
-------------------------------------------
Time: 2020-03-13 06:57:01
-------------------------------------------
('rt', 71)
('trump', 56)
('coronavirus', 21)
('https', 13)
('testing', 11)
('president', 9)
('donald', 9)
('get', 8)
('news', 7)
('chances', 6)
...
-------------------------------------------
Time: 2020-03-13 06:57:02
-------------------------------------------
('rt', 35)
('trump', 20)
('testing', 10)
('coronavirus', 9)
('https', 8)
('president', 7)
('biden', 5)
('said', 4)
('donald', 4)
('amp', 4)
...
-------------------------------------------
Time: 2020-03-13 06:57:03
-------------------------------------------
('rt', 16)
('trump', 15)
('us', 4)
('coronavirus', 4)
('https', 3)
('end', 3)
('president', 3)
('obama', 3)
('tested', 2)
('ban', 2)
...

```
