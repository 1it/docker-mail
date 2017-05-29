FROM debian:stretch

EXPOSE 8080/tcp

VOLUME /var/www

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends apache2 postfixadmin ca-certificates php7.0-pgsql dovecot-core

COPY dbconfig.inc.php /etc/postfixadmin/dbconfig.inc.php
COPY config.inc.php /etc/postfixadmin/config.inc.php
RUN chown -R www-data: /usr/share/postfixadmin/templates_c/

# Copy sample database dump
COPY mail.sql.gz /var/backups/

# TransferLog /dev/stdout | ErrorLog /dev/stderr
RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log

CMD [ "/usr/sbin/apache2", "-DFOREGROUND" ]
