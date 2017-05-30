FROM debian:stretch

EXPOSE 80

RUN echo "roundcube-core  roundcube/language      select  en_US" > selections
RUN echo "roundcube-core  roundcube/database-type select  pgsql" > selections
RUN echo "roundcube-core  roundcube/pgsql/admin-pass      $pgsql_pass" > selections
RUN echo "roundcube-core  roundcube/dbconfig-install      boolean true" > selections

RUN apt-get update
RUN debconf-set-selections selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 ca-certificates roundcube roundcube-pgsql php7.0-pgsql php-net-idna2 sendmail postgresql-client locales
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN sed -i "s|#    Alias /roundcube /var/lib/roundcube|Alias /roundcube /var/lib/roundcube|g" /etc/apache2/conf-enabled/roundcube.conf

# TransferLog /dev/stdout
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

COPY config.inc.php /etc/roundcube/config.inc.php
COPY debian-db.php  /etc/roundcube/debian-db.php

RUN ln -s /etc/roundcube /usr/share/roundcube/config
RUN mkdir /usr/share/roundcube/logs /usr/share/roundcube/temp
RUN chown -R www-data: /usr/share/roundcube/

RUN ln -sf /dev/stderr /var/lib/roundcube/logs/errors

# Clean up
RUN apt-get clean; rm -r /var/lib/apt/lists/*

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "/usr/sbin/apache2", "-DFOREGROUND" ]
