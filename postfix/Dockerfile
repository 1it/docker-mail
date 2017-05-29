FROM debian:stretch

EXPOSE 25/tcp 465/tcp 587/tcp

ENV MAILNAME mail.example.com
ENV MY_NETWORKS 172.16.0.0/15 192.168.0.0/16

RUN apt-get update
RUN debconf-set-selections selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix postfix-pgsql rsyslog ca-certificates

COPY etc/postfix /etc/postfix

RUN echo "postfix postfix/main_mailer_type string Internet site" > selections
RUN echo "postfix postfix/mailname string $MAILNMAME" >> selections
RUN echo "postfix postfix/mynetworks string $MY_NETWORKS" >> selections

RUN postconf -e myhostname=$MAILNAME
RUN postconf -e mynetworks="127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 $MY_NETWORKS"

COPY etc/rsyslog.conf /etc/
COPY docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
