**ST446 Distributed Computing for Big Data**

Please have a look at these commands at home.

# Getting data from the Internet

In the previous exercise about file system commands (see [here](basic_command_file_system_example.md)), we downloaded the `shakespeare.txt` file by copying-and-pasting the content.

There is a much easier way to do it. You can either run:

```
wget https://raw.githubusercontent.com/bbejeck/hadoop-algorithms/master/src/shakespeare.txt
```
or
```
curl https://raw.githubusercontent.com/bbejeck/hadoop-algorithms/master/src/shakespeare.txt > shakespeare.txt
```

curl passes the output to the standard output, which is the command window. The `>` redirects the output to a file.

You can generally us `command > file.txt` to redirect the output of `command` to a file.
