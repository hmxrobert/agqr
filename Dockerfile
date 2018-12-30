FROM alpine:latest
MAINTAINER hmxrobert

RUN apk --update --no-cache add ruby nginx rtmpdump ffmpeg

ADD agqr.rb /
ADD makepodcast.rb /
ADD agqr.sh /
ADD schedule.yaml /
RUN chmod +x /agqr.sh

EXPOSE 80

VOLUME /mnt/agqr

CMD ["nginx" "-g" "daemon off;"] 
