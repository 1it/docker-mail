FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get update; apt-get install -q -y dovecot-pgsql dovecot-imapd dovecot-pop3d dovecot-lmtpd ca-certificates

COPY etc/dovecot /etc/dovecot

COPY docker-entrypoint.sh /

# Clean up
RUN apt-get clean; rm -r /var/lib/apt/lists/*

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/dovecot", "-c", "/etc/dovecot/dovecot.conf", "-F"]
