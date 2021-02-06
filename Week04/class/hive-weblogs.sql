


CREATE DATABASE IF NOT EXISTS weblogs;

USE weblogs;

DROP TABLE IF EXISTS apachelog;

CREATE TABLE apachelog (
  host STRING,
  identity STRING,
  user_id STRING,
  time STRING,
  request STRING,
  status STRING,
  size STRING
  
  )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  "input.regex" = '([^ ]*) ([^ ]*) ([^ ]*) \\[([^\\]]*)\\] \"([^\"]*)\" (-|[0-9]*) (-|[0-9]*) [^\n]*',
  "output.format.string" = "%1$s %2$s %3$s %4$s %5$s %6$s %7$s"
)
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH 'webserverlogs/access.log' 
OVERWRITE INTO TABLE apachelog;