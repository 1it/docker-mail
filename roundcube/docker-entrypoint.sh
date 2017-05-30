#!/bin/bash

if [ ! -f ~/.pgpass ]; then
    echo "$PG_PASSWD_FILE" > ~/.pgpass
    sed -i "s/usrname/$USER_NAME/g" ~/.pgpass
    sed -i "s/passwd/$USER_PASSWD/g" ~/.pgpass
    chmod 0600 ~/.pgpass
fi

until psql -lqt -h postgres -U $USER_NAME; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

if [ ! -f ~/.dbflag ]; then
    psql -v ON_ERROR_STOP=1 -h postgres -U $USER_NAME roundcube < /usr/share/roundcube/SQL/postgres.initial.sql
    touch ~/.dbflag
fi

# Set /etc/hosts entries
dc_ip=`ping -c 1 dovecot | head -1 | grep -Eo "([0-9]+\.?){4}"`
pf_ip=`ping -c 1 postfix | head -1 | grep -Eo "([0-9]+\.?){4}"`
echo -e "$dc_ip imap.$DOMAIN dovecot\n" >> /etc/hosts
echo -e "$pf_ip smtp.$DOMAIN postfix\n" >> /etc/hosts

sed -i "s/usrname/$USER_NAME/g" /etc/roundcube/config.inc.php
sed -i "s/passwd/$USER_PASSWD/g" /etc/roundcube/config.inc.php

exec "$@"
