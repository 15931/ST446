**ST446 Distributed Computing for Big Data**, LT 2021

This week, we will look at data from Stack Exchange. Please have a look at this [notebook](ExploreStackexchangeData.ipynb).

Please run the notebook in a cluster that was initialised as follows. The reason for this is that specific initialisation actions are required to use *Spark GraphFrames*.

For `Mac OS` and `Linux` users, please run the following commands in a terminal:

**(remember to define your cluster name and change to your project name, region and zone)**

```
gcloud beta dataproc clusters create kaifang-cluster \
--properties=^#^spark:spark.jars.packages=graphframes:graphframes:0.5.0-spark2.1-s_2.11,com.databricks:spark-xml_2.11:0.4.1 \
--subnet default --enable-component-gateway --region europe-west2 --zone europe-west2-c --master-machine-type n1-standard-4 --master-boot-disk-size 500 \
--num-workers 2 --worker-machine-type n1-standard-4 --worker-boot-disk-size 500 --image-version 1.3-debian10 --optional-components ANACONDA,JUPYTER \
--project st446-2021-lt --metadata 'PIP_PACKAGES=sklearn nltk pandas graphframes'
```

For `Windows` users, please go to the *cloud shell* provided on your GCP Console Webpage.

1. initialize your gcloud setting by `gcloud init`
2. set up your region by `gcloud config set dataproc/region europe-west2` (if you are in London; otherwise pick a location closest to you)
3. run the same commands used by `Mac OS` and `Linux` users.

## Homework

Have a look at the section "2. Graph of user co-contributions" in the [notebook](ExploreStackexchangeData.ipynb). Try to fill in the gaps.

## References

* [PySpark API](https://spark.apache.org/docs/latest/api/python/index.html)
* [GraphFrames Quick-Start Guide](https://graphframes.github.io/graphframes/docs/_site/quick-start.html)
* [Graph analysis tutorial with GraphFrames](https://docs.databricks.com/spark/latest/graph-analysis/graphframes/graph-analysis-tutorial.html).
* [Introducing GraphFrames](https://databricks.com/blog/2016/03/03/introducing-graphframes.html).
* [An introduction to Spark GraphFrame with examples analyzing the Wikipedia link graph](https://towardsdatascience.com/an-introduction-to-spark-graphframe-with-examples-analyzing-the-wikipedia-link-graph-67e58c20a107).
* [On-Time Flight Performance with GraphFrames for Apache Spark](https://databricks.com/blog/2016/03/16/on-time-flight-performance-with-graphframes-for-apache-spark.html).
* [How to display/visualize a graph created by GraphFrame?](https://stackoverflow.com/questions/54204062/how-to-display-visualize-a-graph-created-by-graphframe)
* [PyGraphviz documentation](https://pygraphviz.github.io/documentation/stable/index.html).


