#!/bin/bash

until ping -c 3 postgres 2>1 > /dev/null; do
  # echo "Postgres is unavailable - sleeping"
  sleep 1
done

while [ ! -f /etc/ssl/certs/imap.$DOMAIN.crt ]
do
  sleep 1
done

# Update db credentials
sed -i "s/ndb/$DB_NAME/g" /etc/dovecot/dovecot-*sql.conf.ext
sed -i "s/usrname/$USER_NAME/g" /etc/dovecot/dovecot-*sql.conf.ext
sed -i "s/passwd/$USER_PASSWD/g" /etc/dovecot/dovecot-*sql.conf.ext
# Update domain
sed -i "s/example.com/$DOMAIN/g" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/example.com/$DOMAIN/g" /etc/dovecot/local.conf

# Run dovecot
exec "$@"
