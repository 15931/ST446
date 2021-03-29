**ST446 Distributed Computing for Big Data**

# Seminar 10: Distributed dataflow graph computation

In this seminar, we will learn how to do data-parallel computation in TensorFlow 2.x. TensorFlow 2.x provides an API to programmers based on the `Strategy` class that allows distributed training of neural networks on multiple devices without an expert knowledge of distributed computing inner workings.

Before the seminar class, we provided you with an introductory exercise on TensorFlow 2.x to help you get familiar with the methods like `compile()` and `fit()` and callback functions. Run the [mnist_keras.ipynb](mnist_keras.ipynb) in **Google Colab**. If the “open in Colab” button does not work for you, please download the notebook and upload it to Google Colab.

We will cover two subclasses of `Strategy` that are designed for two synchronous data-parallel training senarios, namely:
*   Single machine with multiple GPUs: `MirroredStrategy()` in [mnist-keras-2gpus.ipynb](mnist-keras-2gpus.ipynb)
*   Multiple machines: `MultiWorkerMirroredStrategy()` in [mnist-keras-2workers.md](mnist-keras-2workers.md)

Note: In this exercise, we focus exclusively on data-parallel computation, as this is what is currently supported by `tf.distribute` in TensorFlow 2.x. Model-parallel computation may be introduced later in TensorFlow 2.x. Currently, model-parallel computation is supported by Mesh-TensorFlow.  

## References

Data-parallel computation:

* [Introduction to TensorFlow 2.0: Easier for beginners, and more powerful for experts (TF World '19)](https://www.youtube.com/watch?v=5ECD8J3dvDQ)

* [Inside TensorFlow: tf.distribute.Strategy](https://www.youtube.com/watch?v=jKV53r9-H14&feature=youtu.be)

Model-parallel computation:

* [Mesh-TensorFlow](https://papers.nips.cc/paper/8242-mesh-tensorflow-deep-learning-for-supercomputers.pdf)
