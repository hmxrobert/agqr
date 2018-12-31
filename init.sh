#!/bin/ash
/usr/sbin/nginx &
echo 29,59  * * * * /agqr.sh $1 $2 > /var/spool/cron/crontabs/root
/bin/crond -l 2 -f
