FROM alpine:latest
MAINTAINER hmxrobert

RUN apk --update --no-cache add ruby nginx rtmpdump ffmpeg

ADD agqr.rb /
ADD makepodcast.rb /
ADD agqr.sh /
ADD schedule.yaml /
RUN chmod +x /agqr.sh
RUN mkdir -p /run/nginx

EXPOSE 80

VOLUME /mnt/agqr

CMD /usr/sbin/nginx -g "daemon off;"
