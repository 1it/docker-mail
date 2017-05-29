#!/bin/bash

# Clean stale pids
if [ -f /var/run/rsyslogd.pid ]; then
    rm -f /var/run/rsyslogd.pid
fi

if [ -f /var/spool/postfix/pid/master.pid ]; then
    rm -f /var/spool/postfix/pid/master.pid
fi

until ping -c 3 postgres 2>1 > /dev/null; do
  # echo "Postgres is unavailable - sleeping"
  sleep 1
done

if [ ! -d /var/spool/postfix/etc ]; then
    mkdir /var/spool/postfix/etc
    ln -s /etc/resolv.conf /var/spool/postfix/etc/
    ln -s /etc/services /var/spool/postfix/etc/
fi

# Check permissions
chown -R postfix:postfix /var/spool/postfix/

# Define dovecot/postgres ip (postfix config resolve host ip issue fix)
pg_ip=`ping -c 1 postgres | head -1 | grep -Eo "([0-9]+\.?){4}"`
sed -i "s/postgres/$pg_ip/g" /etc/postfix/*.cf

dc_ip=`ping -c 1 dovecot | head -1 | grep -Eo "([0-9]+\.?){4}"`
sed -i "s/inet:dovecot/inet:$dc_ip/g" /etc/postfix/*.cf

# Update db credentials
sed -i "s/ndb/$DB_NAME/g" /etc/postfix/virtual_*
sed -i "s/usrname/$USER_NAME/g" /etc/postfix/virtual_*
sed -i "s/passwd/$USER_PASSWD/g" /etc/postfix/virtual_*

# Run postfix
/usr/sbin/postfix start
# Run rsyslog, log to stdout
/usr/sbin/rsyslogd -n
