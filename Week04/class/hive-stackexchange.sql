CREATE DATABASE IF NOT EXISTS Stackexchange;

USE Stackexchange;

DROP TABLE IF EXISTS usersxml;
DROP TABLE IF EXISTS usersxml_prsd;

CREATE TABLE usersxml (
  text STRING
)
STORED AS TEXTFILE;


CREATE TABLE usersxml_prsd (
  text STRING
)
STORED AS TEXTFILE;

add FILE xml_mapper.py;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id STRING,
  reputation STRING,
  creationdate STRING,
  displayname STRING,
  lastaccessdate STRING,
  websiteurl STRING,
  location STRING,
  aboutme STRING,
  views STRING,
  upvotes STRING,
  downvotes STRING,
  age STRING,
  accountid STRING,
  profileimageurl STRING)
STORED AS PARQUET;

LOAD DATA LOCAL INPATH 'StackExchange/Users.xml' INTO TABLE usersxml;

INSERT OVERWRITE TABLE usersxml_prsd
SELECT
  TRANSFORM (text)
  USING 'python xml_mapper.py'
  AS (text)
FROM usersxml;

INSERT OVERWRITE TABLE users
SELECT xpath_string(text, '/row/@Id'),
   xpath_string(text, '/row/@Reputation'),
   xpath_string(text, '/row/@CreationDate'),
   xpath_string(text, '/row/@DisplayName'),
   xpath_string(text, '/row/@LastAccessDate'),
   xpath_string(text, '/row/@WebSiteUrl'),
   xpath_string(text, '/row/@Location'),
   xpath_string(text, '/row/@AboutMe'),
   xpath_string(text, '/row/@Views'),
   xpath_string(text, '/row/@UpVotes'),
   xpath_string(text, '/row/@DownVotes'),
   xpath_string(text, '/row/@Age'),
   xpath_string(text, '/rows/@AccountId'),
   xpath_string(text, '/rows/@ProfileImageUrl')
FROM usersxml_prsd;

DROP TABLE usersxml;
DROP TABLE usersxml_prsd;
