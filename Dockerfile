FROM alpine:latest
MAINTAINER hmxrobert

RUN apk --update --no-cache add ruby openrc nginx rtmpdump ffmpeg
RUN sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf && \
    echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
    sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf && \
    sed -i '/tty/d' /etc/inittab && \
    sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname && \
    sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh
RUN touch /run/openrc/softlevel
RUN rc-service nginx start

ADD agqr.rb /
ADD makepodcast.rb /
ADD agqr.sh /
ADD schedule.yaml /
RUN chmod +x /agqr.sh

EXPOSE 80

VOLUME /mnt/agqr

CMD ["agqr.sh"]
