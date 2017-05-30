#!/bin/bash

# Update openssl cnf files
sed -i "s/example.com/$DOMAIN/g" /*.cnf

CA_CRT="ca/ca.crt"
CA_KEY="private/ca.key"

KEYS=("imap.$DOMAIN.key" "smtp.$DOMAIN.key")
CRTS=("imap.$DOMAIN.crt" "smtp.$DOMAIN.crt")
REQS=("imap.$DOMAIN.csr" "smtp.$DOMAIN.csr")
CNFS=("/dovecot-openssl.cnf" "/postfix-openssl.cnf")
DHPF="/etc/ssl/dhparams.pem"

# Prepare directories
cd /etc/ssl/
mkdir -p ca certs private reqs

# Create own CA certificate
if [ ! -f $CA_CRT ] || [ ! -f $CA_KEY ]; then
    openssl genrsa -out $CA_KEY 4096
    openssl req -new -x509 -sha256 -days 3650 -config /ca-openssl.cnf -key $CA_KEY -out $CA_CRT
    cp $CA_CRT certs/
fi

length="${#KEYS[@]}"
days="3650"

# Create imap/smtp certificates
if [ ! -f "certs/${CRTS[0]}" ] || [ ! -f "private/${KEYS[0]}" ] || [ ! -f "certs/${CRTS[1]}" ] || [ ! -f "private/${KEYS[1]}" ]; then
    for i in ${!KEYS[@]}; do
        openssl genrsa -out private/${KEYS[i]} 4096
        openssl req -new -key private/${KEYS[i]} -config ${CNFS[i]} -out reqs/${REQS[i]}
        openssl x509 -req -days $days -CA $CA_CRT -CAkey $CA_KEY -CAcreateserial -extfile ${CNFS[i]} -in reqs/${REQS[i]} -out certs/${CRTS[i]}
    done
fi

# Create DH-Group file
if [ ! -f "$DHPF" ]; then
    openssl dhparam -out $DHPF 2048
fi

update-ca-certificates
openssl x509 -subject -fingerprint -noout -in $CA_CRT
