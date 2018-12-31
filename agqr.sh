#!/bin/ash
sleep 55
/usr/bin/ruby /agqr.rb $3
/usr/bin/ruby /makepodcast.rb $1 $2 "/mnt/agqr/data/mp3/" > /var/www/html/podcast.rss
