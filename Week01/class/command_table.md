**ST446 Distributed Computing for Big Data**

# Basic command line interface commands

## Basic filesystem commands

| Command's purpose	            | Windows       | Mac / Linux | Mac example                           |
|:------------------------------|:--------------|:------------|:--------------------------------------|
| List files	                  | dir	          | ls    	    | ls -al                                |
| Display current directory     | chdir	        | pwd	        | pwd                                   |
| Change directory              | cd            | cd         	| cd /directory/directory               |
| Compare the content of files  | fc    	      | diff	      | diff file1 file2                      |
| View content of a file        | more      	  | more / less	| less thisfile.txt                     |
| Find a string in a file       | findstr	      | grep	      | grep word or phrase thisfile.txt      |
| Create an empty file          | New-Item -Name file.txt | touch | touch file.txt                 |
| Copy file(s)                  | copy	        | cp	        | cp thisfile.txt /home/thisdirectory   |
| Move file(s)	                | move	        | mv	        | mv thisfile.txt /home/thisdirectory   |
| Delete file(s                 | del   	      | rm	        | rm thisfile.txt                       |
| Rename file  	                | ren	          | mv     	    | mv thisfile.txt thatfile.txt          |
| Get the content of a file     | type          | cat         | cat file.txt                          |
| change permission             | icacls        | chmod       | chmod 666 file.txt                    |
| Edit a text file              | notepad       | open -a textedit| open -a textedit thisfile.txt     |
| Create a directory            | mkdir   	    | mkdir	      | mkdir directory                       |
| Display a command help        | command / ?   | man / info  | man command                           |
| "Echo" the output             | echo	        | echo	      | echo this message                     |
| Clear screen	                | cls	          | clear	      | clear                                 |
| Close shell prompt	          | exit	        | exit   	    | exit                                  |

Note replace [your_file.txt] with the file that you want to create/open

## Basic system commands

| Command's purpose	            | Windows       | Mac / Linux | Mac example                           |
|:------------------------------|:--------------|:------------|:--------------------------------------|
| List running processes        | tasklist	    | ps   	      | ps -ef                                |
| Kill running processes        | taskkill      | kill        | kill 12345                            |
| Set environment variables     | set           | export      | export a=123                          |
| Get the software location     | where         | which       | which python                          |


## Transfer / retrieve commands

| Command's purpose	                                            | Windows                    | Mac / Linux               | Example/ remark                                            |
|:--------------------------------------------------------------|:--------------------------|:--------------------------|:----------------------------------------------------------|
| Check if a device can communicate with another over a network | ping                      | ping                      | ping google.com                                           |
| Read from and write to network connections using TCP or UDP   | telnet &#60;hostname&#62; &#60;port&#62;  | nc -v &#60;hostname&#62; &#60;port&#62;   |                                                           |
| Transfer data from or to a server                             | curl                      | curl                      | Windows users may need to install curl before using it     |
| Retrieve content from web servers                             | wget                      | wget                      | Windows and Mac users may need to install wget before using it     |
| Transfer securely between hosts                               | scp                       | scp                       | Windows users may need to install cygwin before using it   |
