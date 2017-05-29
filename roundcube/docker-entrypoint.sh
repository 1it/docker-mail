#!/bin/bash

if [ ! -f ~/.pgpass ]; then
    echo "$PG_PASSWD_FILE" > ~/.pgpass
    chmod 0600 ~/.pgpass
fi

if [ ! -f ~/.dbflag ]; then
    psql -v ON_ERROR_STOP=1 -h postgres -U $USER_NAME roundcube < /usr/share/roundcube/SQL/postgres.initial.sql
    touch ~/.dbflag
fi

exec "$@"
