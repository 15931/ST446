# ST446 projects

## Project marking rubrics:

<img src="https://github.com/lse-st446/lectures2021/blob/main/images/ST446-final-coursework-rubric.png"></img>


## Project topics
 
Your project should demonstrate an understanding of concepts, methods and technologies in the area of distributed computing for big data and how to apply them. 
This should involve using knowledge acquired in the course and building on this knowledge through an independent study to go more deeply into a specific subject. 
Your project may cover different aspects of distributed computing for big data. For example, it may focus on _system aspects_ such as the use of 
application programming interfaces, data models, query languages, integration of different systems, computation models, and their distributed implementation 
at scale. It may focus on specific _machine learning algorithms_ , demonstrating an understanding of their distributed system implementation and performance evaluation.
 
Your **report would typically be in the form of a Jupyter notebook**, containing PySpark or other code, **along with a Markdown text** explaining different parts. 
You may want to provide a tutorial-like exposition for certain subjects covered in your project. For example, this may include instructions for how to install 
and run certain software or to explain the underlying key concepts (e.g. system or algorithmic concepts). You may also develop software code and scripts outside 
a Jupyter notebook. In this case, your report may be in the form of a Markdown file, which points to the code and services that you used in your project. 
**Your report and any other project related material should be submitted in the GitHub classroom repo** that will be assigned to your project.
 
It is expected from **your report to be** presented up to a high professional standard. This means that it has to be **structured well**, neat and polished. 
Your report should have a title, abstract, main content body, conclusion, and a list of references. 
In the abstract, please make sure to briefly describe what is the problem addressed by your project, why is the problem a problem, 
what is your solution and why you have chosen given solution. The abstract should be short, a paragraph of 5-10 sentences. 

You may use **visualizations** in your report, for example using Matplotlib and other Python libraries. 

Your **report may describe a working prototype application** (e.g. running a stream processing code that continuously processes an input stream). In this case, your report should contain a clear and full description of the steps that one needs to follow in order to run your application. 

Your **report should cite any references that you use**. You may also discuss and cite any previously proposed alternative solutions to your problem. The conclusion section should briefly summarise the results of your project, highlight your main findings, and briefly discuss any interesting avenues for future research.

The list of candidate projects is given below to give you some idea about potential project topics. **You may (but you are not expected) to take one of the project topics listed below**. 

## Candidate project topics

1. Querying the [Yago](https://www.mpi-inf.mpg.de/departments/databases-and-information-systems/research/yago-naga/yago/#c10444) knowledge graph database, PostgreSQL [database](http://resources.mpi-inf.mpg.de/yago-naga/yago/download/yago/postgres.sql)
2. Querying [Yelp data](https://www.yelp.com/dataset) review dataset
3. Querying [MusicBrainz](https://musicbrainz.org/doc/MusicBrainz_Database) database (see also [this](https://github.com/arey/musicbrainz-database/blob/master/create-database.sh))
4. Distributed Deep Neural Network Training using Microsoft Cognitive Toolkit: [QSGD](https://gitlab.com/demjangrubic/QSGD), [GPU deep learning on Azure](http://www.nvidia.com/object/gpu-accelerated-microsoft-azure.html), [GPU VMs on Azure](https://blogs.msdn.microsoft.com/malte_lantin/2017/08/03/using-gpu-powered-virtual-machines-in-the-cloud-for-your-machine-learning-and-deep-learning-workloads/), [Azure docs GPUs](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-gpu)
5. Microsoft [CosmosDB](https://azure.microsoft.com/en-us/services/cosmos-db/?v=17.45a)
6. PySpark CosmosDB connector (see [here](https://github.com/Azure/azure-cosmosdb-spark/wiki))
7. Amazon graph database [Neptun](https://aws.amazon.com/neptune/) [Note: excluded because apparently at the moment the usage is subject to getting an approval from AWS.]
8. Graph database [Neo4J](https://neo4j.com/), [example project](https://neo4j.com/developer/example-project/)
9. HiveQL applied to an input dataset
10. Apache Cassandra database design and querying - DataStax [Python driver](https://github.com/datastax/python-driver)
11. Spark [streaming k-means](https://spark.apache.org/docs/2.2.0/mllib-clustering.html#streaming-k-means) - anomaly detection for an input stream data
12. Amazon Kinesis - stream data processing [NYC Taxi trip data](http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml); check [this](https://aws.amazon.com/blogs/big-data/real-time-clickstream-anomaly-detection-with-amazon-kinesis-analytics/), [examples](https://docs.aws.amazon.com/kinesisanalytics/latest/dev/example-apps.html); [Kinesis-Spark integration](https://spark.apache.org/docs/2.2.0/streaming-kinesis-integration.html)
13. Approximate query answering: see [here](https://databricks.com/blog/2016/05/19/approximate-algorithms-in-apache-spark-hyperloglog-and-quantiles.html) and [here](http://cdn2.hubspot.net/hubfs/438089/notebooks/spark2.0/Databricks%20Blog%20Approximate%20Quantile.html)
14. Apache Kafka / Confluent [examples](https://github.com/confluentinc/examples)
15. Tensorflow - classification of graphs
16. PySpark BigTable connector (via HBase API) see [here](https://github.com/hortonworks-spark/shc)
17. MusicBrainz / Yago database to BigQuery see [here](https://cloud.google.com/solutions/performing-etl-from-relational-database-into-bigquery)
18. Create activity charts for various big data technologies (Spark, Hive, HBase, Cassandra, ...) over time, using Stack Overflow data on BigQuery
19. Same as in the previous item but using github archive data [Note: this project topic is now merged with project topic 18)]
20. Financial Times dataset (from LSE library) - text analysis [Note: excluded, because of LSE library licence restrictions preventing data analysis on the cloud]
21. Network centrality measures - PageRank, HITS, betweeness, Bonacich centrality measures on a social network
22. Graph partitioning in Spark Graph X [here](https://issues.apache.org/jira/browse/SPARK-3523) [here](https://spark.apache.org/docs/1.6.1/api/java/org/apache/spark/graphx/PartitionStrategy.EdgePartition2D$.html) 
23. Custom partitioners in Spark 
24. Facebook flows [dataset](https://www.facebook.com/network-analytics), paper [Inside the Social Network's (Datacenter) Network](http://cseweb.ucsd.edu/~snoeren/papers/fb-sigcomm15.pdf)
25. Criteo [dataset](http://labs.criteo.com/2013/12/download-terabyte-click-logs/) - click prediction, Note: differentiation discussion currently underway
26. Topic modelling on Spark [here](https://databricks.com/blog/2015/03/25/topic-modeling-with-lda-mllib-meets-graphx.html) and [here](https://spark.apache.org/docs/2.2.0/mllib-clustering.html#latent-dirichlet-allocation-lda)
27. Amazon DynamoDB [example](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStarted.Python.html)
28. Apache Hadoop HBase
29. Stack Overflow data analysis - expertise modelling
30. node2vec in PySpark** - reference [Python implementation](https://github.com/aditya-grover/node2vec)
31. Skill rating using generalized linear regression [glm](https://spark.apache.org/docs/2.2.0/ml-classification-regression.html#generalized-linear-regression) - use Stack Overflow or some other dataset, [choix](https://pypi.python.org/pypi/choix), [BradleyTerry2](https://cran.r-project.org/web/packages/BradleyTerry2/index.html), [BradleyTerryScalable](https://github.com/EllaKaye/BradleyTerryScalable), [trueskill](http://trueskill.org/)
32. Analysis of [2016 United States Presidential Election Tweets](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/PDI7IN) 
33. Wikipedia data analysis [data dumps](https://dumps.wikimedia.org/), for example conducting a latent semantic analysis (see Chapter 6 Understanding Wikipedia with Latent Semantic Analysis in [Advanced Analytics with Spark](https://www.safaribooksonline.com/library/view/advanced-analytics-with/9781491972946/) and its [github repo](https://github.com/sryza/aas))
34. Azure VM traces [dataset](https://github.com/Azure/AzurePublicDataset), [paper](http://delivery.acm.org/10.1145/3140000/3132772/p153-cortez.pdf?ip=147.148.12.194&id=3132772&acc=OPENTOC&key=4D4702B0C3E38B35%2E4D4702B0C3E38B35%2E4D4702B0C3E38B35%2EC42B82B87617960C&__acm__=1517384959_541d80cd9f31063d407c47c0c843cd6a)
35. Detecting anomalies in network data: [StreamSpot](http://www3.cs.stonybrook.edu/~emanzoor/streamspot/)
36. Anomaly detection on streams: https://d1.awsstatic.com/whitepapers/kinesis-anomaly-detection-on-streaming-data.pdf, see also related AWS documentation https://docs.aws.amazon.com/kinesisanalytics/latest/sqlref/sqlrf-random-cut-forest.html. One may implement and test this in PySpark (streaming) using some streaming data.
37. Music recommendation Audiosrcobbler [dataset]( https://storage.googleapis.com/aas-data-sets/profiledata_06-May-2005.tar.gz), ALS vs SGD ? see [here](https://stanford.edu/~rezab/classes/cme323/S16/projects_reports/baalbaki.pdf)
38. [Collaborative filtering with graph information](http://www.cs.utexas.edu/~rofuyu/papers/grmf-nips.pdf) -- extending ALS with graph information providing information about relations between users and relations between items, [MV added March 15, 2020]
40. [Neural Word Embedding
as Implicit Matrix Factorization](https://papers.nips.cc/paper/5477-neural-word-embedding-as-implicit-matrix-factorization.pdf) -- finding word embeddings via SVD, [MV added March 15, 2020]
41. Accelerated MM algorithm for skill estimation in Spark, see Algorithm 1 on page 22 of this paper [Convergence Rates of Gradient Descent and MM Algorithms for Generalized Bradley-Terry Models](https://arxiv.org/pdf/1901.00150.pdf) [MV added March 15, 2020]
42. Quantized SGD in Spark, see Algorithm 1 in this paper [QSGD: Quantized Communication-Efficient SGD with Gradient Quantization and Encoding](https://arxiv.org/abs/1610.02132) [MV added March 15, 2020]
43. [Covid-19 Open Research Dataset](https://pages.semanticscholar.org/coronavirus-research) [MV added March 15, 2020]
44. Structured queries on large datasets using [Presto](https://prestodb.io/) [MV added March 18, 2020]
45. Data representations (subset selection), e.g. see [here](https://arxiv.org/pdf/1707.01212.pdf), Section II, Algorithm 2, and Section VI (Experiments) - implementation in Spark? [MV added March 19, 2020]
46. [Algorithms for non-negative matrix factorization](http://papers.nips.cc/paper/1861-algorithms-for-non-negative-matrix-factorization.pdf), [Distributed NMF for Web-Scale Dyadic Data Analysis on MapReduce](http://www.ambuehler.ethz.ch/CDstore/www2010/www/p681.pdf), [Matrix Factorizations at Scale](https://arxiv.org/pdf/1607.01335.pdf) [MV added March 28, 2020]
47. Distributed training of neural networks using Mesh-TensorFlow [paper](https://papers.nips.cc/paper/8242-mesh-tensorflow-deep-learning-for-supercomputers.pdf), [GitHub repo](https://github.com/tensorflow/mesh): [MV added March 30, 2020]
48. Data parallel training http://jmlr.org/papers/volume20/18-789/18-789.pdf [MV added April 16, 2020]
49. Integrative use of Neo4j graph database and Spark (see [here](https://neo4j.com/developer/spark/)) [MEB added February 19, 2021]
50. Comparative analysis of Apache Flink and Spark (see [here](https://data-flair.training/blogs/comparison-apache-flink-vs-apache-spark/) and [here](https://data-flair.training/blogs/apache-flink-tutorial/)) [MEB added February 19, 2021]
51. Distributed Reinforcement Learning [RLib](https://arxiv.org/pdf/1712.09381.pdf) [MV added March 10, 2021]
52. Distributed Reinforcement learning [ACME](https://deepmind.com/research/publications/Acme) [MV added March 10, 2021]
53. [PipeDream: Generalized Pipeline Parallelism for DNN Training](https://dl.acm.org/doi/10.1145/3341301.3359646) [MV added March 26, 2021]
