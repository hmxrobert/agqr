FROM alpine:latest
MAINTAINER hmxrobert

RUN apk --update --no-cache add ruby nginx rtmpdump ffmpeg tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata
    
ADD agqr.rb /
ADD makepodcast.rb /
ADD init.sh /
ADD agqr.sh /

RUN chmod +x /init.sh && \
    chmod +x /agqr.sh && \
    mkdir -p /run/nginx

EXPOSE 80

VOLUME /mnt/agqr

ENTRYPOINT ["/init.sh"]
CMD ["超A＆G＋", "http://localhost:80/"]
