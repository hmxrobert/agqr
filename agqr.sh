#!/bin/ash
/usr/bin/ruby /agqr.rb $2
/usr/bin/ruby /makepodcast.rb "超A＆G＋" $1 "/mnt/agqr/data/mp3/" > /usr/share/nginx/html/podcast.rss
