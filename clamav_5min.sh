#!/bin/bash
# Created @ plain.xyz

# You can add dir checks if needed e.g.:
# if [ ! -d /var/log/clamav ] ; then mkdir /var/log/clamav ; fi

LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d-%H-%M-%S').log";
INFECTED="/path/to/infected/files/dir"
EMAIL_MSG="Please check the log file attached.";
EMAIL_FROM="your_from_email @ domain.com";
EMAIL_TO="your_to_email @ domain.com";
DIRTOSCAN="/path/to/dir1 /path/to/dir2 /path/to/dir3 /path/to/dir_etc";

# Checking for mail installation (replace with your mail program)
type mail >/dev/null 2>&1 || { echo >&2 "Mail is not installed. Exiting..."; exit 1; };

for D in ${DIRTOSCAN}; do
 # Find files uploaded in the last 5 minutes and execute clamscan on all results and move infected to INFECTED directory
 # Change " \+ " to " \; " to start a new clamscan for each file individually (probably not a good idea :))
 # You can change "*" to "*.zip" if you only plan to scan .zip files
 # You can use -cmin for minutes or use -ctime if the scan is only done every few days
 find "$D" -name "*" -cmin -5 -type f -exec clamscan -i --move=$INFECTED {} \+ >> "$LOGFILE";

done

# Count sanity check if no results
if [ ! -s "$LOGFILE" ] ; then
        echo "Infected files: 0" >> "$LOGFILE";
fi

# Get the total value of "Infected files"
EMAILSCAN=$(grep Infected "$LOGFILE" |cut -d" " -f3 | awk '{ SUM += $1} END { print SUM }');

# If the value is not equal to zero, send an email
if [ "$EMAILSCAN" -ne "0" ] ; then

# Using heirloom mailx
# A: using a message that tells you to look in the attached log file
        #echo "$EMAIL_MSG" |mail -a "$LOGFILE" -s "$EMAILSCAN Infected files found on SOME-SERVER-HOSTNAME" -r "$EMAIL_FROM" "$EMAIL_TO";

# B: using a message that tells you the log file directly without attaching a file
        cat "$LOGFILE" | mail -s "$EMAILSCAN Infected files found on SOME-SERVER-HOSTNAME" -r "$EMAIL_FROM" "$EMAIL_TO";
fi

exit 0
