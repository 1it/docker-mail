#!/bin/bash
set -e

# Initialize database if needed
/init-db.sh

# Replace setup password
sed -i "s/{{SETUP_PASSWORD}}/${SETUP_PASSWORD}/g" /var/www/postfixadmin/config.local.php

exec "$@"
