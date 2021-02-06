# ST446 Distributed Computing for Big Data
## Seminar class 4: Hive installation

This document gives step-by-step instructions for how to install Hive which we tested on Mac OS systems.

Note for Windows users: you may follow installation instructions available online (e.g. see [here](https://www.zymr.com/hive-installation-windows-7/)). Alternatively, you may use a docker container (e.g. see [here](https://github.com/big-data-europe/docker-hive)) or run Hive on Google Cloud Platform (see [here](https://cloud.google.com/sdk/gcloud/reference/beta/dataproc/jobs/submit/hive)). We encourage you to liaise with your peers who also work with a Windows system to try find a working solution. Please share with us what you found out to work best for you.

## 1. Install Hive

### a. Install Hive with Homebrew (mac OS)
```
brew install hive
```

Example:
```
LSE021353:~ vojnovic$ brew install hive
==> Downloading https://www.apache.org/dyn/closer.cgi?path=hive/hive-2.3.1/apache-
==> Best Mirror http://ftp.carnet.hr/misc/apache/hive/hive-2.3.1/apache-hive-2.3.1

curl: (22) The requested URL returned error: 404 Not Found
Trying a mirror...
==> Downloading https://archive.apache.org/dist/hive/hive-2.3.1/apache-hive-2.3.1-
######################################################################## 100.0%
==> Caveats
Hadoop must be in your path for hive executable to work.

If you want to use HCatalog with Pig, set $HCAT_HOME in your profile:
  export HCAT_HOME=/usr/local/opt/hive/libexec/hcatalog
==> Summary
🍺  /usr/local/Cellar/hive/2.3.1: 1,071 files, 182.5MB, built in 1 minute 47 seconds
```

### b. Set the environment variables for Hive

Add the following to `~/.bash_profile`:

```
export HIVE_HOME=/usr/local/Cellar/hive/2.3.1/libexec
export PATH=$HIVE_HOME/bin:$PATH
```
You may need to change the $HIVE_HOME directory path if it is different in your system (e.g. because you use a different Hive installation version).

### c. Create HDFS directories

Turn your hadoop on. Run the following lines to create directories in HDFS and give write permission to the group:
```
$ hdfs dfs -mkdir -p /user/hive/warehouse
$ hdfs dfs -mkdir /tmp
$ hdfs dfs -chmod g+w /tmp
$ hdfs dfs -chmod g+w /user/hive/warehouse
```

### d. Create a log file in Hive and update configuration

1. Create the folders and the log file using the following commands:
```
$ source ~/.bash_profile
$ mkdir -p $HIVE_HOME/hcatalog/var/log
$ touch $HIVE_HOME/hcatalog/var/log/hcat.out
```

2. Download the [ hive-site.xml](hive-site.xml) and put it in $HIVE_HOME/conf/

## 2. Install mysql and connect Hive to it

### a. Download the mysql driver

Download `mysql-connector-java` from https://dev.mysql.com/downloads/connector/j/, uncompress it and move the `.jar` file under `$HIVE_HOME/lib/`

Example:
```
LSE021353:mysql-connector-java-5.1.45 vojnovic$ sudo cp mysql-connector-java-5.1.45-bin.jar $HIVE_HOME/lib/
```

### b. Install mysql with Homebrew

Example:
```
LSE021353:mysql-connector-java-5.1.45 vojnovic$ brew install mysql
Updating Homebrew...
==> Auto-updated Homebrew!
Updated 2 taps (caskroom/cask, homebrew/core).
==> Updated Formulae
coreutils

==> Downloading https://homebrew.bintray.com/bottles/mysql-5.7.20.sierra.bottle.
==> Downloading from https://akamai.bintray.com/00/00db29d31d78c659c573b5d4746a1
######################################################################## 100.0%
==> Pouring mysql-5.7.20.sierra.bottle.tar.gz
==> /usr/local/Cellar/mysql/5.7.20/bin/mysqld --initialize-insecure --user=vojno
==> Caveats
We've installed your MySQL database without a root password. To secure it run:
    mysql_secure_installation

MySQL is configured to only allow connections from localhost by default

To connect run:
    mysql -u root

To have launched start mysql now and restart at login:
  brew services start mysql
Or, if you don't want/need a background service you can just run:
  mysql.server start
==> Summary
🍺  /usr/local/Cellar/mysql/5.7.20: 324 files, 233.7MB
```

#### c. Run mysql and check if it runs properly

start mysql:
```
LSE021353:mysql-connector-java-5.1.45 vojnovic$ brew services start mysql
==> Successfully started `mysql` (label: homebrew.mxcl.mysql)
```

check if running successfully:
```
LSE021353:queries vojnovic$ brew services list
Name       Status  User     Plist
mongodb    stopped          
mysql      started vojnovic /Users/vojnovic/Library/LaunchAgents/homebrew.mxcl.mysql.plist
postgresql started vojnovic /Users/vojnovic/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```

check the mysql version:
```
LSE021353:queries vojnovic$ mysql -V
mysql  Ver 14.14 Distrib 5.7.20, for osx10.12 (x86_64) using  EditLine wrapper
```
### d. Configure mysql

#### Set the root password:
```
LSE021353:queries vojnovic$ mysqladmin -u root password 'December2017'
mysqladmin: [Warning] Using a password on the command line interface can be insecure.
Warning: Since password will be sent to server in plain text, use ssl connection to ensure password safety.
```

#### Run mysql:
```
LSE021353:conf vojnovic$ mysql -u root -h 127.0.0.1 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 12
Server version: 5.7.20 Homebrew

Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
exit the prompt by `exit;`. Note the `;` is needed as mysql commands end with semicolon.

#### Create the metastore database and user
```
$ mysql -u root -p
mysql> CREATE DATABASE metastore;
mysql> USE metastore;
mysql> CREATE USER 'hiveuser'@'localhost' IDENTIFIED BY 'password';
mysql> GRANT SELECT,INSERT,UPDATE,DELETE,ALTER,CREATE, REFERENCES, INDEX ON metastore.* TO 'hiveuser'@'localhost';
```
if error occurs in `CREATE USER 'hiveuser'@'localhost' IDENTIFIED BY 'password';`, type `flush privileges;` before that line

Useful link: [mysql commands](https://dev.mysql.com/doc/refman/5.7/en/mysql-commands.html)

#### Initialize database schema:

```
$ schematool -initSchema -dbType mysql
```

Example:
```
LSE021353:bin vojnovic$ ./schematool -initSchema -dbType mysql
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/local/Cellar/hive/2.3.1/libexec/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/local/Cellar/hadoop/2.8.2/libexec/share/hadoop/common/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]
Metastore connection URL:	 jdbc:mysql://localhost/metastore
Metastore Connection Driver :	 com.mysql.jdbc.Driver
Metastore connection User:	 hiveuser
Thu Dec 28 12:23:39 CET 2017 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Starting metastore schema initialization to 2.3.0
Initialization script hive-schema-2.3.0.mysql.sql
Thu Dec 28 12:23:40 CET 2017 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
Initialization script completed
Thu Dec 28 12:23:41 CET 2017 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.
schemaTool completed

```

## 3. Run Hive and test it

### a. Run Hive

```
LSE021353:bin vojnovic$ hive
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/usr/local/Cellar/hive/2.3.1/libexec/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/usr/local/Cellar/hadoop/2.8.2/libexec/share/hadoop/common/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]

Logging initialized using configuration in jar:file:/usr/local/Cellar/hive/2.3.1/libexec/lib/hive-common-2.3.1.jar!/hive-log4j2.properties Async: true
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.
```

### b. Test

```
hive> show tables;
Thu Dec 28 12:23:59 CET 2017 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.

... [deletia]

OK
Time taken: 4.169 seconds
```

```
hive> CREATE TABLE pokes (foo INT, bar STRING);
OK
Time taken: 0.739 seconds
```

```
hive> describe pokes;
OK
foo                 	int                 	                    
bar                 	string              	                    
Time taken: 0.115 seconds, Fetched: 2 row(s)
```

### Running Hive in the debug mode

```
hive --hiveconf hive.root.logger=DEBUG,console
```

## References

* [Install Hive on Mac with Homebrew](https://gist.github.com/giwa/ed13ac177c1e1a97fba0)
