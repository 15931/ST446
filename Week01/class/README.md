**ST446 Distributed Computing for Big Data - LT 2020-2021**

# Seminar class 1

This week, we look at how to use the Google Cloud Platform (GCP) to run code remotely.

Throughout the module, we will use GCP to learn how to use clusters and make use of distributed computing. We advise you to proceed as follows:

* If you have problems accessing GCP, try the [LSE Remote Desktop](https://desktop.lse.ac.uk/). There are some [guidelines here](https://info.lse.ac.uk/staff/divisions/academic-registrars-division/systems/Remote-access).

* You can also **install the required software (Anaconda, Jupyter and Spark) on your own computer**. To do that, check [this file](../../instructions/local_installation.md).

* Alternatively, you can use other environments such as [Microsoft Azure](../../instructions/azure-hdinsight.md), [Databricks Community Edition](../../instructions/databricks_spark.md) or [Amazon AWS](https://aws.amazon.com/free/).

General notes:
* The instructions provided here are written primarily for Mac OS / Linux systems. Many of commands that run on Mac OS / Linux systems have their (approximate) equivalents on Windows systems. You may find some of these equivalents here: [command_table.md](command_table.md). Some of the commands on Mac OS / Linux systems do not have equivalent commands on Windows systems (e.g. chmod).
* On a Windows system, you may either use a Command Prompt (installed by default) or [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1) (you may install it [here](https://github.com/PowerShell/PowerShell#get-powershell)) for a command line interface (terminal). Using Powershell allows you to run Linux-type of commands on a Windows system.
* Windows users may also find the following resource useful: [Windows Sysinternals](https://docs.microsoft.com/en-us/sysinternals/).

## Note on billing
When using GCP, please always delete your compute engines/clusters and buckets after you are done, otherwise unnecessary cost can be incurred.

## Note on starting and stopping clusters (added on 27/01/2021)

From [GCP documentation](https://cloud.google.com/dataproc/docs/guides/dataproc-start-stop#:~:text=After%20you%20create%20a%20cluster,with%20the%20same%20configuration%20later.): *After you create a cluster, you can stop it, then restart it when you need it. Stopping an idle cluster avoids incurring charges and avoids the need to delete an idle cluster, then create a cluster with the same configuration later.

Stopping a cluster stops all cluster Compute Engine VMs. You do not pay for these VMs while they are stopped. However, you continue to pay for any associated cluster resources, such as persistent disks.*

## 0.1 Preparation (before class)
Before the class, please try do the following:

Read the preparation part in [google_cloud_platform_class_activity.md](google_cloud_platform_class_activity.md) and install the Google Cloud SDK on your computer. You should also familiarise yourself with the Google Cloud Console. You do NOT need to give GCP your own bank account or start the free trial.

If you have any problems with installations, please get in touch with [the teaching staff or fellow students](mailto:m.e.barreto@lse.ac.uk) to get help.

## 0.2 Command line examples (before class)
We recommend that you also go through this section before class.

Follow the instructions in the following files to familiarise yourself with the command line interface.
Mac OS / Linux users can run those commands in a terminal. For Windows users, we suggest that you install Powershell.
Many of the software and applications in this course use Linux type of commands by default.

The following files are prepared for Mac OS / Linux systems.
With Windows Powershell, most commands are available, unless specified otherwise.
If you prefer to use the Windows command line rather than Powershell, you may find useful to consult the table of commands given [here](command_table.md).

We recommend that you focus on the first two documents.

* File manipulation: [basic_command_file_system_example.md](basic_command_file_system_example.md)
* System admin: [basic_command_system_example.md](basic_command_system_example.md)
* Downloads from internet: [basic_command_download_example.md](basic_command_download_example.md)
* Network admin: [basic_command_network.md](basic_command_network.md)

We will also cover [basic_command_file_system_example.md](basic_command_file_system_example.md) in class.

## 1. GCP: getting started (in class)
This is the in-class activity for this week.

Go to [google_cloud_platform_class_activity.md](google_cloud_platform_class_activity.md). Follow the instructions in Section 1 - 3 to upload files, create a cluster and submit jobs to google cloud.

Please make sure to **delete the cluster and bucket afterwards**.

## 2. Jupyter notebooks with GCP (in class, if you have time, or optional homework)
For next week, please have a look at Section 4 of the document [google_cloud_platform_class_activity.md](google_cloud_platform_class_activity.md).
Please try to follow the instructions and let us know, if you run into problems.

In addition, please look at the README file in the week02/class directory and try to follow the preparation steps for the next class.
Please make sure to **delete the cluster and bucket afterwards**.

## Please have a look at next week's [README.md](../../week02/class/README.md)
