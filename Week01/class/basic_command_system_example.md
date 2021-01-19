**ST446 Distributed Computing for Big Data**
# Basic System Administration Commands

In this exercise, we demonstrate how to check and update some system settings from a command line interface.

## 1. List the running processes and killing them

To list the processes running in your system, use:
```
ps
```
The first column shows you the PID. In Powershell, PID is the sixth column named Id.

You can also use `top` to display information about processes. Note the information in `top` is "live" and interactive whereas in `ps` is "screenshot" and non-interactive.  

Windows Powershell does not have obvious equivalent of `top`, instead one can run the `while` loop indefinitely:
```
While(1) {ps | sort -des cpu | select -f 15 | ft -a; sleep 1; cls}
```
To quit, type `Ctrl + C`.
Example:
```
LSE021353:~ vojnovic$ top

Processes: 384 total, 2 running, 1 stuck, 381 sleeping, 2133 threads                                                                        19:33:58
Load Avg: 2.22, 2.62, 3.02  CPU usage: 4.5% user, 6.92% sys, 89.2% idle     SharedLibs: 213M resident, 43M data, 81M linkedit.
MemRegions: 77938 total, 3716M resident, 116M private, 1779M shared. PhysMem: 14G used (2105M wired), 2305M unused.
VM: 2077G vsize, 627M framework vsize, 3114500(0) swapins, 3240622(0) swapouts. Networks: packets: 1737658/535M in, 2130360/1680M out.
Disks: 1841619/37G read, 465304/38G written.

PID    COMMAND      %CPU TIME     #TH   #WQ  #PORT MEM    PURG   CMPRS  PGRP  PPID STATE    BOOSTS           %CPU_ME %CPU_OTHRS UID  FAULTS   COW
16567  top          3.4  00:01.33 1/1   0    20    4024K  0B     0B     16567 4631 running  *0[1]            0.00000 0.00000    0    11385+   111
16566  mdworker     0.0  00:00.06 4     1    48    9476K  0B     0B     16566 1    sleeping *0[1]            0.00000 0.00000    501  4503     186
16565  Google Chrom 0.1  00:01.17 15    1    143   63M    0B     0B     1486  1486 sleeping *0[1]            0.00000 0.00000    501  31449    1560
16564  mdworker     0.0  00:00.07 3     1    53    3468K  0B     0B     16564 1    sleeping *0[1]            0.00000 0.00000    501  2155     228
16563  quicklookd   0.0  00:00.09 4     1    85    3776K  32K    0B     16563 1    sleeping  0[0]            0.00000 0.00000    501  2843     218
16526  com.apple.iC 0.0  00:00.15 3     2    57    2960K  0B     0B     16526 1    sleeping  0[0]            0.00000 0.00000    501  2276     205
(part of output removed for readability)
```

You can use it to kill a process. For example, for a process with PID 12345,
```
kill 12345
```
Note: make sure you don't kill a process that you need having alive.

## 2. Check and set an environment variable

To check the setting of an environment variable (e.g. PATH) use:
```
echo $PATH
```
Note you must have the '$' in front of the name of the environment variable.
For window users, it would be
```
echo $env:Path
```

If the output is blank, it means that the environment variable is not set (e.g. try `echo $a`)

To set an environment variable (e.g. a), use:
```
export a=123
```
In Windows Powershell, use
```
$env:a=123
```
To check, use: `echo $env:a`

Note there is *no* '$' in front of the environment variable, and there is *no* space in front of and after the "=". Try `echo $a` again and you can see `a` has been set.

Note that the change is valid only till the command line interface is open. If you want to update an environment variable permanently, you need to do it inside the `~/.bash_profile` file. Open the `~/.bash_profile` by
```
open -a TextEdit ~/.bash_profile
```
Note: for window users, please see here: https://msdn.microsoft.com/en-us/library/windows/desktop/ms682653(v=vs.85).aspx

PATH environment variable specifies directories in your local file system that your system will look up to find an executable file when you try to run it from the command line.
This way you don't need do type in the full directory path of an executable file each time you want to run it. For example, if you want to run python residing in `/Users/vojnovic/Library/Caches/AmlWorkbench/Python/bin/python`, you may just run it by executing the command `python` providing that `/Users/vojnovic/Library/Caches/AmlWorkbench/Python/bin/` is part of your PATH environment variable.

If you find out something is missing in PATH, you can append it by as demonstrated in the following example (adding a path for google cloud sdk):  

```
export PATH=~/Applications/google-cloud-sdk/bin:$PATH
```

### Notes on `PATH` and `~/.bash_profile`

* Note on `PATH` environment variable

    You may notice that even if we do not append anything in `~/.bash_profile` (or other similar files), the `PATH` variable is not blank. In fact the un-appended `PATH` variable has the value of:

    ```
    cat /etc/paths
    ```

    Example:
    ```
    LSE021353:~ vojnovic$ more /etc/paths
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    /Library/tex/texbin
    /Applications/scala-2.12.1/bin
    ```
    So when we set `PATH` in `~/.bash_profile`, we append directory paths to those in /etc/paths.

* Note on `~/.bash_profile`

    In our examples above, we show how you can set your environment variable in `~/.bash_profile`. In fact there are more places you can do so, depending on at *which* level and *when* you want to set the environment variable
    * The *system-wide* initialization file, executed for *login* shells: `/etc/profile`
    * The *user* initialization file, executed for *login* shells: `~/.bash_profile`
    * The *user* initialization file, executed when a login shell *exits*: `~/.bash_logout`

## 3. Check the version and location of an application

Checking the version and location of an application is useful to make sure we are running the right application version. This is even more important if we have several installations of the same application. Below we use java as an example.

To check which java you are using, use:
```
which java
```
Windows users run:
```
Get-Command java
```
If the output is blank, it means that either you have not installed `java`, or the environment variable `$PATH` does not include where `java` is. Otherwise, you may get something like this:
```
LSE021353:~ vojnovic$ which java
/Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home/bin/java
```

It is possible the path output by `which java` is just a symlink. To check this, `cd` into the *parent* folder where the java is, and run:
```
ls -l | grep java
```
Note: the `-l` argument asks for file details.

If the java is a symlink, you will see something like:
```
lrwxrwxrwx 1    root    root    26 Mar 31 11:27     /usr/bin/java -> /usr/java/default/bin/java
```
You may want to trace where the application is located to make sure you are using the right one.

We can check the version of an application by:
```
java -version
```
The output may look something like this:
```
LSE021353:bin vojnovic$ java -version
java version "1.8.0_121"
Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)

```

## 4. Get information about the system kernel (for Linux and Mac)

Here we illustrate how to use `sysctl` and `hostinfo` to get information about the hardware of your own computer. `sysctl` is a tool which reads and modifies the attributes of the system kernel such as its version number, maximum limits, and security settings.

### Check the number of cpu
```
sysctl -n hw.ncpu
```
The `-n` argument disables printing of the key name when printing values. `hw` stands for hardware

For window users, the command is `echo %NUMBER_OF_PROCESSORS%`

Example:
```
LSE021353:week01 vojnovic$ sysctl -n hw.ncpu
4
```

### Get all the information about the hardware
```
sysctl -a | grep "^hw"
```
Use the `-a` argument to display all values currently available

Example:
```
LSE021353:~ vojnovic$ sysctl -a | grep "^hw"
hw.ncpu: 4
hw.byteorder: 1234
hw.memsize: 17179869184
hw.activecpu: 4
(part of output removed for readability)
hw.cpufrequency_max: 3300000000
hw.cpufrequency_min: 3300000000
hw.cpufrequency: 3300000000
hw.busfrequency_max: 100000000
hw.busfrequency_min: 100000000
hw.busfrequency: 100000000
hw.pagesize32: 4096
hw.pagesize: 4096
hw.cachesize: 17179869184 32768 262144 4194304 0 0 0 0 0 0
hw.cacheconfig: 4 2 2 4 0 0 0 0 0 0
hw.cpufamily: 939270559
hw.cpu64bit_capable: 1
hw.cpusubtype: 8
hw.cputype: 7
hw.logicalcpu_max: 4
hw.logicalcpu: 4
hw.physicalcpu_max: 2
hw.physicalcpu: 2
hw.targettype: Mac
hw.cputhreadtype: 1
```

Let's take a look of some interesting ones in the above output:
```
hw.ncpu: 4
hw.memsize: 17179869184
hw.cpufrequency: 3300000000
hw.busfrequency: 100000000
hw.logicalcpu: 4
hw.physicalcpu: 2
```

### hostinfo
The hostinfo command displays information about the host system on which the command is executing. The output includes a kernel version description, processor configuration data, available physical memory, and various scheduling statistics.

Example:
```
LSE021353:~ vojnovic$ hostinfo
Mach kernel version:
                Darwin Kernel Version 16.7.0: Mon Nov 13 21:56:25 PST 2017; root:xnu-3789.72.11~1/RELEASE_X86_64
Kernel configured for up to 4 processors.
2 processors are physically available.
4 processors are logically available.
Processor type: x86_64h (Intel x86-64h Haswell)
Processors active: 0 1 2 3
Primary memory available: 16.00 gigabytes
Default processor set: 378 tasks, 2185 threads, 4 processors
Load average: 1.83, Mach factor: 2.17
```

Note for Windows users: `sysctl` would not work on a Windows system. To look up properties of your system, you may use instead: `systeminfo` command (see [here](https://technet.microsoft.com/en-gb/library/bb491007.aspx) for description).

## 5. Disk usage

### display free disk space

You can use the following command to see the amount of free disk space in your filesystems:
```
df -h
```
The `-h` argument means displying "Human-readable" output and size is shown in terms of large Byte units.

Example:
```
LSE021353:paths.d vojnovic$ df -h
Filesystem                          Size   Used  Avail Capacity iused      ifree %iused  Mounted on
/dev/disk1                         931Gi  679Gi  251Gi    74% 1913714 4293053565    0%   /
devfs                              192Ki  192Ki    0Bi   100%     665          0  100%   /dev
map -hosts                           0Bi    0Bi    0Bi   100%       0          0  100%   /net
map auto_home                        0Bi    0Bi    0Bi   100%       0          0  100%   /home
localhost:/comaX0xLCfNigKJXqM42LT  931Gi  931Gi    0Bi   100%       0          0  100%   /Volumes/MobileBackups
```
The Windows Powershell equivalent is `gdr`.
## disk usage

```
du -sh *
```
The `-h` again means displying "Human-readable" output. `-s` means to display an entry for each specified file. `*` means all

Example:
```
LSE021353:data vojnovic$ du -sh *
2.3G       20171026_demo_capstone
281M     20171026_demo_capstone.zip
1.3M      Basketball reference
 15G       Criteo
1.1M      Data-GitHub-Stackoverflow
170M     FBFlow
224K       FinData
 80M      Google Play Apps
 41G       Google cloud
 15M      LSE Exam Timetable
3.2G       London cycling data
6.4G       Microsoft-optics
(part of output removed for readability)
```
