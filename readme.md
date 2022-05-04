This repository hosts an automation script that does the following:

1) set's up the apache2 http web server on the ubuntu machine for hosting websites
2) ensures the apache2 server is running and enabled
3) apache2 logs are archived and added to a /tmp directory and then uploaded to aws s3 bucket
4) creates a cron to archive the logs once every day

The script is rerunnable, and does the things needed only if it has not been setup.
