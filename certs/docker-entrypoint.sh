#!/bin/bash
set -e

echo "Starting certificate generation for ${DOMAIN}..."

# Replace environment variables in OpenSSL config files
for conf in /etc/ssl/*.cnf; do
    sed -i \
        -e "s|DOMAIN|${DOMAIN}|g" \
        -e "s|SSL_COUNTRY|${SSL_COUNTRY}|g" \
        -e "s|SSL_STATE|${SSL_STATE}|g" \
        -e "s|SSL_LOCALITY|${SSL_LOCALITY}|g" \
        -e "s|SSL_ORGANIZATION|${SSL_ORGANIZATION}|g" \
        -e "s|SSL_ORGANIZATIONAL_UNIT|${SSL_ORGANIZATIONAL_UNIT}|g" \
        -e "s|SSL_COMMON_NAME|${SSL_COMMON_NAME}|g" \
        -e "s|SSL_EMAIL|${SSL_EMAIL}|g" \
        "$conf"
done

# Generate CA if it doesn't exist
if [ ! -f /etc/ssl/certs/ca.crt ]; then
    echo "Generating CA private key for ${DOMAIN}"
    openssl genrsa -out /etc/ssl/private/ca.key 4096

    echo "Generating CA certificate for ${DOMAIN}"
    openssl req -new -x509 -days 3650 -key /etc/ssl/private/ca.key \
        -out /etc/ssl/certs/ca.crt -config /etc/ssl/ca-openssl.cnf

    chmod 644 /etc/ssl/certs/ca.crt
    chmod 600 /etc/ssl/private/ca.key
fi

# Generate mail server certificate
if [ ! -f /etc/ssl/certs/mail.crt ]; then
    echo "Generating mail server private key for ${DOMAIN}"
    openssl genrsa -out /etc/ssl/private/mail.key 2048

    echo "Generating mail server CSR for ${DOMAIN}"
    openssl req -new -key /etc/ssl/private/mail.key \
        -out /etc/ssl/certs/mail.csr -config /etc/ssl/postfix-openssl.cnf

    echo "Signing mail server certificate with CA for ${DOMAIN}"
    openssl x509 -req -days 365 \
        -in /etc/ssl/certs/mail.csr \
        -CA /etc/ssl/certs/ca.crt \
        -CAkey /etc/ssl/private/ca.key \
        -CAcreateserial \
        -out /etc/ssl/certs/mail.crt \
        -extfile /etc/ssl/postfix-openssl.cnf \
        -extensions cert_type

    chmod 644 /etc/ssl/certs/mail.crt
    chmod 600 /etc/ssl/private/mail.key
fi

# Generate DH parameters if they don't exist
if [ ! -f /etc/ssl/dhparams.pem ]; then
    echo "Generating DH parameters (this may take a while)..."
    openssl dhparam -out /etc/ssl/dhparams.pem 2048
fi

echo "Certificate generation completed successfully!"
exit 0
