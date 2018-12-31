FROM alpine:latest
MAINTAINER hmxrobert

RUN apk --update --no-cache add ruby nginx rtmpdump ffmpeg tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata
ADD agqr.rb /
ADD makepodcast.rb /
ADD init.sh /
ADD agqr.sh /
ADD schedule.yaml /
ADD root /var/spool/cron/crontabs/root

RUN chmod +x /init.sh
RUN chmod +x /agqr.sh
RUN mkdir -p /run/nginx

EXPOSE 80

VOLUME /mnt/agqr

ENTRYPOINT ["/init.sh"]
CMD ["localhost:80"]
