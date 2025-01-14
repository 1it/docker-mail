#!/bin/bash


STDOUT=${STDOUT:-/proc/1/fd/1}
STDERR=${STDERR:-/proc/1/fd/2}

DOMAINS=$(echo $DOMAINS | tr ',' '\n')
# Set up environment for certbot
echo "MAIN_DOMAIN=${MAIN_DOMAIN}" >> /etc/environment
echo "LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}" >> /etc/environment

# Initial certificate acquisition
if [ ! -d "/etc/letsencrypt/live/${MAIN_DOMAIN}" ]; then
    certbot certonly --standalone \
        --non-interactive \
        --agree-tos \
        --email ${LETSENCRYPT_EMAIL} \
        --domains ${DOMAINS_LIST:-${MAIN_DOMAIN}} \
        --expand \
        --keep-until-expiring

    # Copy certificates to shared volume
    if [ -d "/etc/letsencrypt/live/${MAIN_DOMAIN}" ]; then
        cp /etc/letsencrypt/live/${MAIN_DOMAIN}/* /etc/ssl/certs/
        chmod 644 /etc/ssl/certs/*
    fi
fi

# Default job - using crontab instead of cron.d
CRON_TEMP=$(mktemp)
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin" > "$CRON_TEMP"

declare -a JOBS
eval "JOBS=($JOBS_LIST)"

if [ ! -z "$JOBS" ]; then
    for i in "${JOBS[@]}"; do
        echo "$i > $STDOUT 2>$STDERR" >> "$CRON_TEMP"
    done
else
    # Default certbot renewal job if none specified
    echo "0 0 1 * * certbot renew --quiet > $STDOUT 2>$STDERR" >> "$CRON_TEMP"
fi

# Install crontab for root user
crontab "$CRON_TEMP"
rm "$CRON_TEMP"

# Show installed crontab
crontab -l

exec "$@"
