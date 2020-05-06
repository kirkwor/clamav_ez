# clamav_ez
ClamAV bash script to quickly scan certain directories, move infected files to a folder and email output without the need of a full time CPU hogging clamdscan service

Pre-req:
```
mkdir /var/log/clamav/
chmod +x /path/to/this/script
```

Add an entry to crontab (5 min scanning intervals):

```*/5 * * * * /path/to/this/script```

This script creates a new log file for each cron run, make sure you have a log rotation for that folder to remove them e.g.:

```
/var/log/clamav/*.log {
        daily
        copytruncate
        missingok
        compress
        delaycompress
postrotate
        /usr/bin/find /var/log/clamav/ -name "*.log*" -type f -mtime +1 -exec rm {} \;
endscript
}
```
