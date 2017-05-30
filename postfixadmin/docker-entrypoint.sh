#!/bin/bash

if [ ! -f ~/.pgpass ]; then
    echo "$PG_PASSWD_FILE" > ~/.pgpass
    sed -i "s/usrname/postgres/g" ~/.pgpass
    sed -i "s/passwd/$POSTGRES_PASSWORD/g" ~/.pgpass
    chmod 0600 ~/.pgpass
fi

until psql -lqt -h postgres -U postgres; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

if [ -f /var/backups/mail.sql.gz ]; then
    gunzip /var/backups/mail.sql.gz
    psql -v ON_ERROR_STOP=1 -h postgres -U postgres $DB_NAME < /var/backups/mail.sql
    rm /var/backups/mail.sql
    for tbl in `psql -qAt -h postgres -U postgres -c "select tablename from pg_tables where schemaname = 'public';" $DB_NAME`;
        do
            psql -h postgres -U postgres -c "alter table \"$tbl\" owner to $USER_NAME" $DB_NAME;
        done
fi

exec "$@"
