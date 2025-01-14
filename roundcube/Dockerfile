FROM debian:bookworm-slim AS builder

ENV ROUNDCUBE_VERSION 1.6.9
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    ca-certificates && \
    wget -O roundcube.tar.gz https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz && \
    tar xf roundcube.tar.gz && \
    mv roundcubemail-${ROUNDCUBE_VERSION} /roundcube && \
    rm roundcube.tar.gz

FROM debian:bookworm-slim

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apache2 \
    libapache2-mod-php \
    php-cli \
    php-curl \
    php-intl \
    php-json \
    php-mbstring \
    php-pgsql \
    php-xml \
    php-zip && \
    rm -rf /var/lib/apt/lists/* && \
    a2enmod rewrite

COPY --from=builder /roundcube /var/www/roundcube
RUN chown -R www-data:www-data /var/www/roundcube

COPY config.inc.php /var/www/roundcube/config/
COPY apache.conf /etc/apache2/sites-available/000-default.conf
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
