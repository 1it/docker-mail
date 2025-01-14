#!/bin/bash

while [ ! -f /etc/ssl/certs/mail.crt ]
do
  echo "Waiting for SSL certificate..."
  sleep 1
done

echo "Checking basedir permissions"
chown -R dovecot:dovecot /var/run/dovecot
chmod -R 0755 /var/run/dovecot

echo "Updating domain"
sed -i "s/example.com/$DOMAIN/g" /etc/dovecot/conf.d/*.conf
sed -i "s/example.com/$DOMAIN/g" /etc/dovecot/dovecot.conf

echo "Running dovecot"
exec "$@"