FROM alpine:latest
MAINTAINER hmxrobert

RUN apk --update --no-cache add ruby nginx rtmpdump ffmpeg curl tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    mkdir /var/www/html
    
ADD agqr.rb /
ADD makepodcast.rb /
ADD init.sh /
ADD agqr.sh /
ADD default.conf /etc/nginx/conf.d/

RUN chmod +x /init.sh && \
    chmod +x /agqr.sh && \
    mkdir -p /run/nginx && \
    cp /var/spool/cron/crontabs/root /var/spool/crontabs/root.org

EXPOSE 80

VOLUME /mnt/agqr

ENTRYPOINT ["/init.sh"]
CMD ["超A＆G＋", "http://localhost:80/"]
