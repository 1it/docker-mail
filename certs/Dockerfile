FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get update; apt-get install -q -y openssl ca-certificates

COPY docker-entrypoint.sh /
COPY ca-openssl.cnf /ca-openssl.cnf
COPY dovecot-openssl.cnf /dovecot-openssl.cnf
COPY postfix-openssl.cnf /postfix-openssl.cnf

# Clean up
RUN apt-get clean; rm -r /var/lib/apt/lists/*

ENTRYPOINT ["/docker-entrypoint.sh"]
