<?php
$CONF['database_type'] = 'sqlite';
$CONF['database_name'] = '/var/mail/mail.db';

$CONF['configured'] = true;
$CONF['setup_password'] = '{{SETUP_PASSWORD}}';
$CONF['default_language'] = 'en';
$CONF['encrypt'] = 'dovecot:SHA512-CRYPT';

// Mail server settings
$CONF['domain_path'] = 'YES';
$CONF['domain_in_mailbox'] = 'NO';
$CONF['fetchmail'] = 'NO';
$CONF['show_footer_text'] = 'NO';

// Dovecot config
$CONF['dovecot_pw_binary'] = '/usr/bin/doveadm pw'; 