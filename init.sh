#!/bin/ash
/usr/sbin/nginx &
/bin/crond -l 2 -f
