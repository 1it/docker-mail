FROM postgres:9.6

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

COPY init-user-db.sh /docker-entrypoint-initdb.d/

