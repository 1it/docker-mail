#!/bin/bash

# Update db credentials
sed -i "s/ndb/$DB_NAME/g" /etc/dovecot/dovecot-*sql.conf.ext
sed -i "s/usrname/$USER_NAME/g" /etc/dovecot/dovecot-*sql.conf.ext
sed -i "s/passwd/$USER_PASSWD/g" /etc/dovecot/dovecot-*sql.conf.ext

# Run dovecot
exec "$@"
