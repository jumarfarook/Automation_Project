# this script installs apache2, archives the access & error logs and uploads to AWS S3 bucket
#!/bin/bash

echo "!!! Script execution starting !!!"

# declare some variables needed
myname="umarfarook"
s3_bucket="upgrad-umarfarook"
package="apache2"
apacheroot="/var/www/html"

# update the packages
echo "**************** updating the packages list **************** "
sudo apt update -y

echo "**************** checking if apache2 is INSTALLED ****************"
if ! dpkg -l $package >/dev/null 2>&1 ; then
    echo "${package} not found, installing the package"

    # install apache2
    sudo apt-get install ${package} -y
else
    echo "${package} is already installed"
fi

echo "**************** checking if apache2 is RUNNING ******************"
if [ $(systemctl is-active ${package}) = "inactive" ]; then
    echo "${package} is NOT running. Starting the service"

    # start apache2 service
    sudo systemctl start ${package}
else
    echo "${package} is running"
fi

echo "**************** checking if apache2 is ENABLED ******************"
if [ $(systemctl is-enabled ${package}) = "disabled" ]; then
    echo "${package} is NOT enabled"

    # enable apache2 service so it restarts automatically when the server starts
    sudo systemctl enable ${package}
else
    echo "${package} is already enabled"
fi

echo "**************** archiving the apache2 logs ****************"

timestamp=$(date '+%d%m%Y-%H%M%S')
logfilename="${myname}-${package}-logs-${timestamp}"

echo "creating the log archive file - ${logfilename}"
tar cvf /tmp/${logfilename}.tar /var/log/apache2/*.log
echo "successfully archived the logs - ${logfilename}"

echo "**************** installing AWS CLI ****************"
# set the package to awscli so we can check if it is installed
package="awscli"

if ! aws --version >/dev/null 2>&1 ; then
    echo "${package} not found, installing the package"

    echo "updating the packages list first"
    sudo apt update -y

    # install awscli
    sudo apt install ${package} -y
else
    echo "${package} is already installed"
fi

echo "**************** uploading the archive file into AWS S3 bucket ****************"
if test -f /tmp/${logfilename}.tar;
then
    aws s3 cp /tmp/${logfilename}.tar s3://${s3_bucket}/${logfilename}.tar
    echo "apache2 logs successfully uploaded to aws s3 bucket"
fi

echo "**************** creating the inventory bookkeeping file of the logs generated ****************"
if ! test -f ${apacheroot}/inventory.html;
then
    echo "inventory.html does not exist, creating a new one"
    echo -en 'Log Type\t\t Date Created\t\t Type\t\t Size<br>' > ${apacheroot}/inventory.html
fi

if test -f ${apacheroot}/inventory.html;
then
    echo "inventory.html exists, append the new log file created"
    filesize=$(du -h /tmp/${logfilename}.tar | awk '{print $1}')
    echo -en "apache2-logs\t\t ${timestamp}\t\t tar\t\t ${filesize}\t\t<br>" >> ${apacheroot}/inventory.html
fi

echo "**************** creating a cron to schedule the script to run once a day ****************"
cronfile=/etc/cron.d/automation
if ! test -f "$cronfile";
then
    echo "#create a cron to run the automation.sh at 12:05am every day" > "$cronfile"
    echo "5 0 * * * root /root/Automation_Project/automation.sh" >> "$cronfile"

    echo "cron for the automation successfully created"
else
    echo "cron for the automation already exists"
fi

echo "!!! Script execution completed !!!"