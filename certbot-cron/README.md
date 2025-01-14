# Docker Certbot & Cron Service

This service handles scheduled tasks for the mail stack, primarily certificate renewal.

## Configuration

### Environment Variables

- `MAIN_DOMAIN`: The main domain for the certificate.
- `LETSENCRYPT_EMAIL`: The email address for Let's Encrypt.
- `DOMAINS_LIST`: An optional comma-separated list of additional domains for the certificate.
- `JOBS_LIST`: An optional comma-separated list of cron jobs.

### Example:
```yaml
environment:
  - MAIN_DOMAIN=example.com
  - LETSENCRYPT_EMAIL=admin@example.com
  - DOMAINS_LIST=example.com,www.example.com
  - JOBS_LIST="* 1 * * 6 certbot renew --quiet"
```


### Default Certificate Renewal

By default, if no JOBS_LIST is specified, it will set up monthly certificate renewal:
```
0 0 1 * * root certbot renew --quiet
```

## Volumes

The service requires access to:
- /etc/letsencrypt
- /var/lib/letsencrypt

## Dependencies

- Requires certbot service to complete initial certificate acquisition
- Shares volumes with other SSL-using services 