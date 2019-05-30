#!/bin/ash
/usr/sbin/nginx &
cp /var/spool/cron/crontabs/root /var/spool/crontabs/root.org cp /var/spool/cron/crontabs/root /var/spool/crontabs/root
echo "29,59 * * * * /agqr.sh $1 $2 $3" >> /var/spool/cron/crontabs/root
crond -f -d 8 
