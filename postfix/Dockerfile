FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postfix \
    postfix-sqlite \
    iputils-ping \
    ca-certificates \
    opendkim \
    opendkim-tools \
    clamav-daemon \
    spamassassin \
    spamc

FROM debian:bookworm-slim

COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/sbin /usr/sbin
COPY --from=builder /usr/share/postfix /usr/share/postfix
COPY --from=builder /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=builder /etc/postfix /etc/postfix

ENV MAILNAME mail.example.com
ENV MY_NETWORKS 172.16.0.0/15 192.168.0.0/16

RUN echo "postfix postfix/main_mailer_type string Internet site" > selections && \
    echo "postfix postfix/mailname string $MAILNAME" >> selections && \
    echo "postfix postfix/mynetworks string $MY_NETWORKS" >> selections && \
    groupadd -g 89 postfix && \
    useradd -g postfix -u 89 -d /var/spool/postfix postfix && \
    mkdir -p /var/spool/postfix /var/log/postfix

COPY etc/postfix /etc/postfix/
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh && \
    postconf -e myhostname=$MAILNAME && \
    postconf -e mynetworks="127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 $MY_NETWORKS"

EXPOSE 25/tcp 465/tcp 587/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]
