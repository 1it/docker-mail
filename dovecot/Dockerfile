FROM debian:bookworm-slim AS builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dovecot-core \
    dovecot-imapd \
    dovecot-pop3d \
    dovecot-sieve \
    dovecot-sqlite \
    dovecot-managesieved \
    dovecot-lmtpd \
    ca-certificates

FROM debian:bookworm-slim

COPY --from=builder /usr/lib /usr/lib
COPY --from=builder /usr/bin /usr/bin
COPY --from=builder /usr/sbin /usr/sbin
COPY --from=builder /usr/share/dovecot /usr/share/dovecot
COPY --from=builder /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=builder /usr/local/lib /usr/local/lib

RUN groupadd -g 5000 vmail && \
    useradd -g vmail -u 5000 vmail -d /var/mail && \
    groupadd -r -g 143 dovecot && \
    useradd -r -u 143 -g dovecot -d /usr/lib/dovecot -s /sbin/nologin dovecot && \
    mkdir -p /var/mail /var/run/dovecot && \
    chown -R vmail:vmail /var/mail

COPY etc/dovecot /etc/dovecot
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh && \
    chown -R dovecot:dovecot /var/run/dovecot && \
    chmod -R 0750 /var/run/dovecot

EXPOSE 24/tcp 110/tcp 143/tcp 993/tcp 995/tcp 4190/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/dovecot", "-c", "/etc/dovecot/dovecot.conf", "-F"]