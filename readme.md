Task 2: Writing A Bash Script 

Once the virtual machine (VM) is set up, the next steps encompasses writing a script to configure the Virtual Machine for hosting a web server 
and later automating some maintainance tasks. Let's take a look at each of these sub tasks one at a time. 

 
Hosting Web Server: The first step is to set up a web server on the EC2 instance for hosting a website. 
It is also important to ensure that the apache2 server is running and it restarts automatically in case the EC2 instance reboots.

 
Archiving Logs: Daily requests to web servers generate lots of access logs. These log files  serve as an  important tool for troubleshooting. 
However, these logs can also result in the servers running out of disk space and can make them stop working. 
To avoid this, one of the best practices is to create a backup of these logs by compressing the logs directory and archiving it to the s3 bucket (Storage). 

 
All this becomes a weekly/daily activity. These tasks can take a long time if done manually again and again. 
You have been assigned to write an automation bash script named ‘automation. sh’ to automate all these workflows.
