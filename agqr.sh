#!/bin/ash
sleep 55
/usr/bin/ruby /agqr.rb $2
/usr/bin/ruby /makepodcast.rb "超A＆G＋" "http://192.168.70.42:23355/" "/mnt/agqr/data/mp3/" > /usr/share/nginx/html/podcast.rss
