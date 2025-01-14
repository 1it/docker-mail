FROM debian:bookworm-slim AS builder

ENV POSTFIXADMIN_VERSION 3.3.15
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    unzip \
    ca-certificates && \
    wget -O postfixadmin.zip https://github.com/postfixadmin/postfixadmin/archive/postfixadmin-${POSTFIXADMIN_VERSION}.zip && \
    unzip postfixadmin.zip && \
    mv postfixadmin-postfixadmin-${POSTFIXADMIN_VERSION} /postfixadmin

FROM debian:bookworm-slim

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2 \
    libapache2-mod-php \
    php-cli \
    php-imap \
    php-sqlite3 \
    php-json \
    php-mbstring \
    php-intl && \
    rm -rf /var/lib/apt/lists/* && \
    a2enmod rewrite

COPY --from=builder /postfixadmin /var/www/postfixadmin
RUN mkdir -p /var/www/postfixadmin/templates_c && \
    mkdir -p /var/www/postfixadmin/database && \
    chown -R www-data:www-data /var/www/postfixadmin/database && \
    chown -R www-data:www-data /var/www/postfixadmin

COPY config.local.php /var/www/postfixadmin/config.local.php
COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY init-db.sh /
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh /init-db.sh && \
    apt-get update && \
    apt-get install -y sqlite3 && \
    rm -rf /var/lib/apt/lists/*

RUN { \
    echo '#!/bin/bash'; \
    echo 'set -e'; \
    echo 'source /etc/apache2/envvars'; \
    echo 'apache2 -DFOREGROUND "$@"'; \
} > /usr/local/bin/apache2-foreground && \
chmod +x /usr/local/bin/apache2-foreground

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["apache2-foreground"]
