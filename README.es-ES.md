# Docker-Mail

Stack de correo dockerizado:
 - Postfix (SMTP);
 - Dovecot (IMAP/POP3);
 - Postfixadmin (Gestión de cuentas de correo);
 - Roundcube (Cliente IMAP);
 - PostgreSQL (DB).

## Requisitos

Última versión de docker (1.13.0 o superior):
```
curl -s https://get.docker.com/ | sudo sh
 ```
Docker-compose (1.13.0 o superior):
```
sudo pip install docker-compose
```

## Antes de comenzar
Asegúrese de que el firewall de iptables no esté bloqueando ninguno de los puertos de correo estándar:
- 25
- 465
- 587
- 110
- 995
- 143
- 993
- 80/8080

Si desea recibir correos electrónicos, debe configurar el DNS. De esta manera:
```
example.com         MX      10      example.com
example.com         MX      10      1.2.3.4
mail.example.com    MX      10      1.2.3.4
```

## Variables

Revise el archivo `docker-compose.env` para cambiar o revisar las variables predeterminadas:
### Postfix
```
DOMAIN=example.com
MAILNAME=smtp.example.com
MY_NETWORKS=172.16.0.0/15 192.168.0.0/16
```
### Postgres
```
LANG=en_US.utf8
DB_NAME=mail
USER_NAME=mail
USER_PASSWD=eeheiThoh2mohjou
POSTGRES_PASSWORD=oejoojo9eimeeloocuCogichoove4oho
PG_PASSWD_FILE=postgres:5432:*:usrname:passwd
```
### Roundcube / Postfixadmin
```
APACHE_RUN_USER=www-data
APACHE_RUN_GROUP=www-data
APACHE_LOG_DIR=/var/log/apache2
APACHE_PID_FILE=/var/run/apache2.pid
APACHE_RUN_DIR=/var/run/apache2
APACHE_LOCK_DIR=/var/lock/apache2
APACHE_LOG_DIR=/var/log/apache2
```
### Configuración de Roundcube
```
DEFAULT_HOST=ssl://imap.example.com
DEFAULT_PORT=993
SMTP_SERVER=tls://smtp.example.com
SMTP_PORT=587
DES_KEY=angahth3ki7shaeTie7queibeSaeyugi
```
Reemplace example.com por su propio dominio:
```
sed -i 's/example.com/your-domain/g' docker-compose.env
```
Reemplace las contraseñas de ejemplo y la clave secreta por las suyas propias.

## Ejecutar
```
docker-compose up -d --build
```

## Verificar interfaz web de Postfixadmin
```
http://localhost:8080/postfixadmin
Contraseña de Admin de ejemplo
user: admin@example.com
passwd: example12345
```
Aquí puede crear algunas cuentas de correo. Luego, puede iniciar sesión con las credenciales de usuario/contraseña creadas en la página de la interfaz web de Roundcube. O pruebe el usuario de ejemplo:

## Roundcube
```
user: test@example.com
passwd: test12345
http://localhost/roundcube/
```
## Pendiente
- certbot
- clamav
- spamassasin
- sieve
- ¿alguna idea?
