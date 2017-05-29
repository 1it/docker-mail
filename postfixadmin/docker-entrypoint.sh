#!/bin/bash

if [ ! -f ~/.pgpass ]; then
    echo "$PG_PASSWD_FILE" > ~/.pgpass
    chmod 0600 ~/.pgpass
fi

if [ -f /var/backups/mail.sql.gz ]; then
    gunzip /var/backups/mail.sql.gz
    psql -v ON_ERROR_STOP=1 -h postgres -U $USER_NAME $DB_NAME < /var/backups/mail.sql
    rm /var/backups/mail.sql
fi

exec "$@"
