#!/bin/bash

if [ -f /var/spool/postfix/pid/master.pid ]; then
    rm -f /var/spool/postfix/pid/master.pid
fi

# Set up filter scripts permissions
chmod 755 /etc/postfix/spamassassin-filter.sh
chmod 755 /etc/postfix/clamav-filter.sh

if [ ! -d /var/spool/postfix/etc ]; then
    mkdir /var/spool/postfix/etc
    ln -s /etc/resolv.conf /var/spool/postfix/etc/
    ln -s /etc/services /var/spool/postfix/etc/
fi

# Check permissions
chown -R postfix:postfix /var/spool/postfix/

dc_ip=`ping -c 1 dovecot | head -1 | grep -Eo "([0-9]+\.?){4}"`
sed -i "s/inet:dovecot/inet:$dc_ip/g" /etc/postfix/*.cf

# Update db credentials
sed -i "s/ndb/$DB_NAME/g" /etc/postfix/virtual_*
sed -i "s/usrname/$USER_NAME/g" /etc/postfix/virtual_*
sed -i "s/passwd/$USER_PASSWD/g" /etc/postfix/virtual_*

# Update domain
sed -i "s/example.com/$DOMAIN/g" /etc/postfix/main.cf

echo "Server $DOMAIN is running"

# Start postfix in foreground mode
exec /usr/sbin/postfix start-fg
