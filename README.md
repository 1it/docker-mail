# Docker-Mail

Dockerized mail stack (Postfix/Dovecot/Postfixadmin/Roundcube/PostgreSQL)

## Requirements

Latest docker:
```
# curl -s https://get.docker.com/ | sh
 ```
Docker-compose:
```
sudo pip install docker-compose
```

## Before you start
Ensure that the iptables firewall is not blocking any of the standard mail ports:
- 25
- 465
- 587
- 110
- 995
- 143
- 993
- 80/8080

If you want to recieve email you have to configure DNS. Like this:
```
example.com         MX      10      example.com
example.com         MX      10      1.2.3.4
mail.example.com    MX      10      1.2.3.4
```

## Variables

Check `docker-compose.env` file to change or revise default variables:
### Postfix
```
DOMAIN example.com
MAILNAME smtp.$DOMAIN
POSTFIX_HOST $MAILNAME
MY_NETWORKS 172.16.0.0/15 192.168.0.0/16
```
### Dovecot
```
DOVECOT_HOST imap.$DOMAIN
```
### Postgres
```
LANG en_US.utf8
DB_NAME mail
USER_NAME mail
USER_PASSWD eeheiThoh2mohjou
POSTGRES_PASSWORD: oejoojo9eimeeloocuCogichoove4oho
PG_PASSWD_FILE "postgres:5432:*:$USER_NAME:$USER_PASSWD"
```
### Roundcube / Postfixadmin
```
APACHE_RUN_USER     www-data
APACHE_RUN_GROUP    www-data
APACHE_LOG_DIR      /var/log/apache2
APACHE_PID_FILE     /var/run/apache2.pid
APACHE_RUN_DIR      /var/run/apache2
APACHE_LOCK_DIR     /var/lock/apache2
APACHE_LOG_DIR      /var/log/apache2
```
### Roundcube config
```
DB_DSNW "'pgsql://$USER_NAME:$USER_PASSWD@postgres/roundcube';"
DEFAULT_HOST ssl://$DOVECOT_HOST
DEFAULT_PORT ""
SMTP_SERVER tls://$POSTFIX_HOST
SMTP_PORT 587
DES_KEY angahth3ki7shaeTie7queibeSaeyugi
```

## Run
```
docker-compose up -d --build
```

## Check Postfixadmin web interface
```
http://localhost:8080/postfixadmin
Sample Admin passwd
user: admin@example.com
passwd: example12345
```
Here you can create some mail accounts. Then, you can login with created user/passwd credentials to Roundcube web interface page.

## Roundcube
```
http://localhost/roundcube
```
## To Do
- certbot
- clamav
- spamassasin
- sieve
- any ideas?
