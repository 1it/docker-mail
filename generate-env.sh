#!/bin/bash
set -e

# Function to generate random string
generate_password() {
    local length=$1
    openssl rand -base64 48 | tr -dc 'A-Za-z0-9_!@#$%^&*()-+=' | head -c ${length}
}

# Function to generate hex key
generate_hex_key() {
    local length=$1
    openssl rand -hex $((length/2))
}

# Check if docker-compose.env exists
if [ -f docker-compose.env ]; then
    echo "Warning: docker-compose.env already exists"
    read -p "Do you want to overwrite it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Get domain name
read -p "Enter your domain name (e.g., example.com): " DOMAIN
read -p "Enter admin email (e.g., postmaster@${DOMAIN}): " ADMIN_EMAIL
if [ -z "$ADMIN_EMAIL" ]; then
    ADMIN_EMAIL="postmaster@${DOMAIN}"
fi

# Get SSL information or use defaults
read -p "Enter your country code (default: US): " SSL_COUNTRY
SSL_COUNTRY=${SSL_COUNTRY:-US}

read -p "Enter your state/province (default: California): " SSL_STATE
SSL_STATE=${SSL_STATE:-California}

read -p "Enter your city (default: San Francisco): " SSL_LOCALITY
SSL_LOCALITY=${SSL_LOCALITY:-"San Francisco"}

read -p "Enter organization name (default: Mail Server): " SSL_ORGANIZATION
SSL_ORGANIZATION=${SSL_ORGANIZATION:-"Mail Server"}

read -p "Enter organizational unit (default: Mail Service): " SSL_ORGANIZATIONAL_UNIT
SSL_ORGANIZATIONAL_UNIT=${SSL_ORGANIZATIONAL_UNIT:-"Mail Service"}

# Generate passwords and keys
POSTFIXADMIN_SETUP_PASSWORD=$(generate_password 32)
MAIL_DB_PASSWORD=$(generate_password 32)

# Create docker-compose.env
cat > docker-compose.env << EOF
# Domain Configuration
DOMAIN=${DOMAIN}
MAILNAME=smtp.${DOMAIN}
MY_NETWORKS=172.16.0.0/15 192.168.0.0/16
ADMIN_EMAIL=${ADMIN_EMAIL}

# Mail Database Configuration (SQLite)
MAIL_DB=/var/mail/mail.db
MAIL_DB_PASSWORD=${MAIL_DB_PASSWORD}

# PostfixAdmin Configuration
SETUP_PASSWORD=${POSTFIXADMIN_SETUP_PASSWORD}

# SSL/TLS Configuration
SSL_COUNTRY=${SSL_COUNTRY}
SSL_STATE=${SSL_STATE}
SSL_LOCALITY=${SSL_LOCALITY}
SSL_ORGANIZATION=${SSL_ORGANIZATION}
SSL_ORGANIZATIONAL_UNIT=${SSL_ORGANIZATIONAL_UNIT}
SSL_COMMON_NAME=\${DOMAIN}
SSL_EMAIL=postmaster@\${DOMAIN}

# DKIM Configuration
DKIM_SELECTOR=mail
EOF

# Display passwords
echo "
==============================================
SAVE THESE PASSWORDS IN A SECURE LOCATION:
==============================================
PostfixAdmin Setup Password: ${POSTFIXADMIN_SETUP_PASSWORD}
Mail Database Password: ${MAIL_DB_PASSWORD}
==============================================
"

chmod 600 docker-compose.env

echo "Environment file generated: docker-compose.env" 