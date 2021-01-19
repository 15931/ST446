**ST446 Distributed Computing for Big Data**
# Basic file system commands

Please have a look at this section before the class. We will briefly cover it in class.
In this exercise, we demonstrate how to manipulate directories and files and get information about them from a command line interface.
All the commands can be run for both Mac OS / Linux and Windows Powershell users, unless specified otherwise.

## 0. The man page
On a Linux/Unix-like system, to learn more about a specific command or to look up how to use it, you should start by using the command
```
 man <command_name>
```
to open documentation/manual page.
You can exit the manual by typing `q`.

## 1. Create and manipulate folders

Let's start by checking the present working directory, using the command `pwd`.
```
pwd
```
Then, we can list all the folders and files in present working directory, by the command `ls`.
```
ls
```
Now let's change the current directory to `~/Documents` (assuming this directory exists in your system, and this can be verified by `ls` command). This can be done easily by the command `cd`, short for "change directory".

For example, on a Mac OS system, to change the current directory to `Document`, run:
```
cd ~/Document/
```
On a Windows Powershell, run:
```
cd ~\Documents\
```
**Remark:** On Mac / Linux systems, levels of directory are separated by `/`, while on Windows system (even if you use Powershell), they are separated by `\`. When you type in commands or directories, using 'Tab' can invoke auto-completion by searching for commands or directories that match.

By running `pwd` again, you will see now you are in `~/Documents/`.

Next, we create a new directory called `ST446_class_1`:
```
mkdir ST446_class_1
```
and make it our current directory by:
```
cd ST446_class_1
```

## 2. Create and manipulate files

We can create an empty `a.txt` file by:
```
touch a.txt
```
Windows Powershell user run:
```
New-Item -Name a.txt
```

As we do not specify the path, the `a.txt` file is stored in our current directory.

We can check what is inside our current directory by:
```
ls
```
You should see that `a.txt` is inside your current directory.

Now, copy the a.txt file to b.txt file by:
```
cp a.txt b.txt
```
Run `ls` again and check that you now have both a.txt and b.txt.

Note: if you want to copy a directory, you need to use `cp -r` instead of `cp`.

Change the name of b.txt to c.txt by:
```
mv b.txt c.txt
```
Run `ls` again and check that now you have a.txt and c.txt.

We delete the `c.txt` file by:
```
rm c.txt
```
Run `ls` again and check that you have a.txt only.

Note: to remove a directory you need to use `rm -r` instead of `rm`.

You can change properties of your file to read and write only by:

```
chmod 666 a.txt
```
The 3 numbers represent permissions for the user, group, and others respectively.
4 stands for "read", 2 stands for "write", 1 stands for "execute", and 0 stands for "no permission". You can add the numbers together, so the 666 in our example means that all users have the right to read and write (4+2), but not execute.

Note: alternatively, you may use `chmod u+rw` to add read and write access rights to the user (`chmod g+rw` and `chmod o_rw` for group and others, respectively). Removing rights can be done by using `-` instead of `+` in the latter commands.

Note for Windows users: the command `chmod` does not have an equivalent on Windows sytems.

## 3. Read and write a file
We open the `a.txt` file by:
```
open -a TextEdit a.txt
```

Go to [here](https://raw.githubusercontent.com/bbejeck/hadoop-algorithms/master/src/shakespeare.txt) to download the text and copy the text to `a.txt` (or you can use the commands [here](basic_command_download_example.md)). Save the file and close it.

Now go back to the command line interface and type:
```
cat a.txt
```
which shows you the whole content of the `a.txt` file.

`cat` is probably not a good way to see the content as the file is too large. You can stop the console from reading file, by `Ctrl + C`. Instead, you can use:
```
less a.txt
```

You can browse the file by using arrow up and arrow down on your keyboard. You can exit by typing `q`. Try also `tail a.txt` and `head a.txt`.

Note: you may also find useful using `more a.txt`.

Windows powershell has no obvious equivalents to commands `less`, `head`, `tail`. But the following `more` and `cat` are still available.

One may often like to check if a file contains some keyword. Try:
```
cat a.txt | grep "apple"
```
which shows you all lines that contain the word "apple". The `|` is a pipe that redirects the output from `cat a.txt` as input to `grep "apple"`.

Windows powershell does not have `grep` command, instead try:
```
cat a.txt | Select-String -Pattern "apple"
```

`grep` is a very useful tool and it can do much more than what we have shown here. To see how you can use `grep`, type:
```
man grep
```
and you will see a manual page on how to use `grep`. To exit the usage page, simply type `q`.

In windows, type: `help`.

Note: alternatively, you may run `grep "apple" a.txt`.


## 4. Delete folders
Now move out from the `ST446_class_1` folder by:
```
cd ..
```
`..` represents the parent folder of the current directory

Next, remove the `ST446_class_1` folder by:
```
rm -r ST446_class_1
```
Recall that the "-r" (or -d) argument is needed to ask the system to remove the folder (not just a single file).

Finally, you may exit the command window by:
```
exit
```
