To run it automatically as a cronjob every 10 minutes, go to `crontab -e` and add this line:
`*/10  * * * * cd <path-to-your-folder> && ./ip_change_notification.sh`
