FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssl \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ca-openssl.cnf /etc/ssl/
COPY postfix-openssl.cnf /etc/ssl/
COPY dovecot-openssl.cnf /etc/ssl/
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

VOLUME ["/etc/ssl"]

ENTRYPOINT ["/docker-entrypoint.sh"]
