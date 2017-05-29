FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get update; apt-get install -q -y openssl ca-certificates

COPY docker-entrypoint.sh /usr/bin/
COPY ca-openssl.cnf /ca-openssl.cnf
COPY dovecot-openssl.cnf /dovecot-openssl.cnf
COPY postfix-openssl.cnf /postfix-openssl.cnf

ENTRYPOINT ["docker-entrypoint.sh"]
