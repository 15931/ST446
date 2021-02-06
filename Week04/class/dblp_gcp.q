CREATE DATABASE IF NOT EXISTS dblp;

USE dblp;

DROP TABLE IF EXISTS authorlarge;

CREATE EXTERNAL TABLE authorlarge (
  author STRING,
  journal STRING,
  title STRING,
  year INT
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION 'gs://jialin-bucket/data/';