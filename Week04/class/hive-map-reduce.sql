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