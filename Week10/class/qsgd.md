**ST446 Distributed Computing for Big Data**, LT 2021
# Seminar 9: Scaling up machine learning

## Exercise 1: Scaling up machine learning by compressing gradient updates

In the lecture, we discussed how distributed training of machine learning models can be scaled up by compressing gradient updates sent by worker nodes to parameter server in the data parallel computation model. For large machine learning models, this can significantly reduce the time required to communicate gradient vector updates in each iteration of the stochastic gradient algorithm, and result in an overall computation speed up. This is of particular interest when learning high-dimensional models, like deep neural networks with hundreds of millions of parameters. 

In this exercise, our goal is to evaluate the effect of compressing gradient vector updates on the training loss for a simple logistic regression model in Spark. To this end, we would like to extend the code developed in one of our previous exercises, namely,

https://github.com/lse-st446/lectures2021/blob/master/Week08/class/logistic_regression_batch_gradient_descent.ipynb 

with using quantized gradient updates. 

Specifically, we have the following tasks:

1. Simple quantized gradient method:
   * Implement the simple quantized gradient method described on **slide 34** of the [lecture notes](https://github.com/lse-st446/lectures2021/blob/master/Week10/lse-st446-lecture9.pdf). Use a naive solution in which each worker node communicates the quantized gradient vector (gradient vector of the loss function component corresponding to the data partition of this worker node) to the parameter server, with each element of this quantized gradient vector equal to either zero or the sign of the coordinate times the norm of the gradient vector;
   * Run the training without and with gradient vector compression;
   * Show the training loss function value versus the number of iterations for training without and with gradient vector quantization;
   * Show the cumulative number of non-zero elements of gradient vectors sent by worker nodes to parameter server versus the number of iterations;
   * Discuss what you observe.
  
2. Controllable quantization:
   * Do the same as in item 1 but using controllable quantization method described on **slide 41** of the [lecture notes](https://github.com/lse-st446/lectures2021/blob/master/Week10/lse-st446-lecture9.pdf) with parameter s >= 1;
   * Show the training loss function value versus number of iterations for different values of parameter s;
   * Show the cumulative number of non-zero elements of gradient vectors sent by worker nodes to parameter server versus the number of iterations, for different values of parameter s;
   * Discuss what you observe; specifically, how is the training loss affected by increasing the value of parameter s.
3. Simple compression by using sparse representations:
   * In items 1 and 2 we used a naive solution that uses one float for each element of a quantized gradient vector - a smarter solution is to use a sparse vector representation in order to reduce the number of information bits used for communication between worker nodes and parameter server;
   * Extend the implementation of controllable quantization by using a sparse vector representation of quantized gradient vectors.

Solutions are in [QSGD.ipynb](./QSGD.ipynb)
