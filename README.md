# Docker-Mail

Modern dockerized mail stack with:
 - Postfix (SMTP)
 - Dovecot (IMAP/POP3)
 - Postfixadmin (Mail accounts management)
 - Roundcube (IMAP Client)
 - PostgreSQL (DB)

## Requirements

- Docker Engine 20.10.0 or newer
- Docker Compose V2 or newer

### Quick Install

Docker:
```bash
curl -fsSL https://get.docker.com | sh
```

Docker Compose:
```bash
# For Linux
sudo apt-get update && sudo apt-get install docker-compose-plugin
# Or using pip
pip install docker-compose
```

## Before you start

### Firewall Configuration
Ensure these ports are accessible:
- SMTP: 25, 465, 587
- IMAP: 143, 993
- POP3: 110, 995
- Web: 80, 8080

### DNS Configuration

### Essential DNS Records

1. Basic Mail Records:
```
# MX Record - Mail server priority
example.com.        IN  MX  10  mail.example.com.

# A Records - IP address mappings
example.com.        IN  A   203.0.113.1
mail.example.com.   IN  A   203.0.113.1
smtp.example.com.   IN  A   203.0.113.1
```

2. SPF Record (Sender Policy Framework):
```
# TXT record for SPF
example.com.        IN  TXT "v=spf1 mx ip4:203.0.113.1 -all"
```
This record:
- Allows sending from your MX servers
- Allows sending from IP 203.0.113.1
- Strictly fails other sources (-all)

3. DKIM Record (DomainKeys Identified Mail):
``
# After generating your DKIM key, add this TXT record
mail._domainkey.example.com.  IN  TXT "v=DKIM1; k=rsa; p=YOUR_PUBLIC_KEY"
```
Generate DKIM key:
```bash
# Inside postfix container
openssl genrsa -out /etc/ssl/private/dkim.key 2048
openssl rsa -in /etc/ssl/private/dkim.key -pubout -out /etc/ssl/private/dkim.pub
```

4. DMARC Record (Domain-based Message Authentication):
```
# TXT record for DMARC
_dmarc.example.com. IN  TXT "v=DMARC1; p=quarantine; rua=mailto:dmarc@example.com; ruf=mailto:dmarc@example.com; fo=1"
```
This policy:
- Quarantines failed messages (p=quarantine)
- Sends aggregate reports to dmarc@example.com
- Sends forensic reports for all failures (fo=1)

### Reverse DNS (PTR Record)

Ensure your hosting provider sets up reverse DNS:
```
203.0.113.1    IN    PTR    mail.example.com.
```

### DNS Record Verification

Test your DNS setup:
```bash
# Check MX record
dig MX example.com

# Check SPF
dig TXT example.com

# Check DKIM
dig TXT mail._domainkey.example.com

# Check DMARC
dig TXT _dmarc.example.com

# Check PTR (reverse DNS)
dig -x 203.0.113.1
```

### Email Authentication Explanation

1. **SPF (Sender Policy Framework)**
   - Prevents sender address forgery
   - Specifies authorized sending servers
   - Receiving servers check if sending IP is authorized

2. **DKIM (DomainKeys Identified Mail)**
   - Cryptographically signs emails
   - Verifies email hasn't been tampered with
   - Links email to sending domain

3. **DMARC (Domain-based Message Authentication)**
   - Builds on SPF and DKIM
   - Tells receivers what to do with failed messages
   - Provides reporting mechanism

### DMARC Policy Options

```
p=none       # Monitor mode - no action taken
p=quarantine # Send suspicious emails to spam
p=reject     # Reject suspicious emails completely
```

Recommended progression:
1. Start with `p=none` and monitor reports
2. Move to `p=quarantine` after confirming legitimate email flow
3. Finally switch to `p=reject` when confident

### Testing Your Setup

1. Mail server test tools:
```bash
# Test SMTP connection
telnet mail.example.com 25

# Test StartTLS
openssl s_client -starttls smtp -connect mail.example.com:587
```

2. Online verification tools:
- https://mxtoolbox.com/
- https://www.mail-tester.com/
- https://dmarc.org/resources/deployment-tools/

## Configuration

1. Copy the example env file:
```bash
cp docker-compose.env.example docker-compose.env
```

2. Edit docker-compose.env with your settings:
```bash
# Replace with your domain
sed -i 's/example.com/your-domain.com/g' docker-compose.env

# Generate strong passwords and update them in docker-compose.env
```

## Deployment

Build and start the stack:
```bash
docker compose up -d --build
```

### Initial Access

Postfixadmin:
```
URL: http://localhost:8080/postfixadmin
Default admin: admin@example.com
Default password: example12345
```

Optional: Roundcube (Webmail):
```
URL: http://localhost/roundcube/
Test account: test@example.com
Password: test12345
```

## SSL Configuration

The stack uses Let's Encrypt for SSL certificates. Make sure:

1. Your domain is pointed to your server
2. Ports 80 and 443 are accessible
3. Set proper environment variables:
```bash
DOMAIN=your-domain.com
ADMIN_EMAIL=your-email@domain.com
```

Certificates will be automatically obtained and renewed.

### SSL Ports
- SMTP with STARTTLS: 587
- SMTP with SSL/TLS: 465
- IMAP with SSL/TLS: 993
- POP3 with SSL/TLS: 995
- Web interfaces: 443

## Security Notes

- Change all default passwords before going to production
- Consider implementing TLS with Let's Encrypt
- Regular security updates are important
- Monitor spam and virus detection logs

## Deployment Options

### Full Stack
Complete mail server with web interfaces, IMAP/POP3:
```bash
docker compose up -d --build
```

### SMTP Only
Minimal SMTP server for sending emails:
```bash
docker compose -f docker-compose.smtp.yml up -d --build
```

### Service Ports

#### SMTP Only Deployment
- SMTP: 25 (plain)
- SMTP with STARTTLS: 587
- SMTP with SSL/TLS: 465
- HTTP: 80 (Let's Encrypt only)

#### Full Stack Additional Ports
- IMAP: 143 (plain), 993 (SSL)
- POP3: 110 (plain), 995 (SSL)
- HTTP: 80 (Roundcube)
- HTTP: 8080 (Postfixadmin)

### Environment Configuration

#### SMTP Only Required Variables
```bash
DOMAIN=example.com
MAILNAME=smtp.example.com
MY_NETWORKS=172.16.0.0/15 192.168.0.0/16
ADMIN_EMAIL=admin@example.com
```

## Roadmap
- [ ] Let's Encrypt integration (for web interfaces)
- [ ] ClamAV integration
- [ ] SpamAssassin integration
- [ ] Sieve filters

## Anti-Spam and Anti-Virus

### SpamAssassin Configuration

The mail server uses SpamAssassin for spam detection with these default settings:
```
Required Score: 5.0 (messages scoring higher are marked as spam)
Auto-Learning: Enabled
Bayes Filtering: Enabled
RBL Checks: Enabled
```

#### Spam Handling
- Spam messages are tagged with '[SPAM]' in the subject
- Messages are scored but not rejected
- Headers are added for client-side filtering

#### Training SpamAssassin
```bash
# Mark message as spam
sa-learn --spam /path/to/spam/message

# Mark message as ham (not spam)
sa-learn --ham /path/to/ham/message

# View statistics
sa-learn --dump magic
```

### ClamAV Configuration

Virus scanning is performed using ClamAV with these features:
- Real-time scanning of all incoming mail
- Automatic database updates
- Maximum file size: 25MB

#### Virus Handling
- Infected messages are rejected at SMTP time
- Scan results are logged for monitoring

#### Update Virus Database
```bash
# Manual update
docker compose exec clamav freshclam

# Check last update
docker compose exec clamav freshclam --version
```

### Testing

Test spam detection:
```bash
# EICAR test file for virus detection
curl https://secure.eicar.org/eicar.com.txt | \
mail -s "Virus Test" test@yourdomain.com

# Spam test
curl https://spamassassin.apache.org/gtube/gtube.txt | \
mail -s "Spam Test" test@yourdomain.com
```

### Monitoring

View scanning logs:
```bash
# Spam detection logs
docker compose logs spamassassin

# Virus scanning logs
docker compose logs clamav
```
