FROM debian:stretch

EXPOSE 80

RUN echo "roundcube-core  roundcube/language      select  en_US" > selections
RUN echo "roundcube-core  roundcube/database-type select  pgsql" > selections
RUN echo "roundcube-core  roundcube/pgsql/admin-pass      $pgsql_pass" > selections
RUN echo "roundcube-core  roundcube/dbconfig-install      boolean true" > selections

RUN apt-get update
RUN debconf-set-selections selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 ca-certificates roundcube roundcube-pgsql php7.0-pgsql php-net-idna2 sendmail
RUN apt-get clean; rm -r /var/lib/apt/lists

RUN sed -i "s|#    Alias /roundcube /var/lib/roundcube|Alias /roundcube /var/lib/roundcube|g" /etc/apache2/conf-enabled/roundcube.conf

# TransferLog /dev/stdout
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

COPY config.inc.php /etc/roundcube/config.inc.php
COPY debian-db.php  /etc/roundcube/debian-db.php

RUN ln -s /etc/roundcube /usr/share/roundcube/config
RUN mkdir /usr/share/roundcube/logs /usr/share/roundcube/temp
RUN chown -R www-data: /usr/share/roundcube/

COPY docker-entrypoint.sh /usr/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD [ "/usr/sbin/apache2", "-DFOREGROUND" ]
