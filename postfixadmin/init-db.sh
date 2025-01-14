#!/bin/bash
set -e

SQLITE_DB="/var/mail/mail.db"

if [ ! -f "$SQLITE_DB" ]; then
    sqlite3 "$SQLITE_DB" << 'EOF'
-- Domain table
CREATE TABLE domain (
    domain varchar(255) NOT NULL,
    description varchar(255),
    aliases int(10) NOT NULL default '0',
    mailboxes int(10) NOT NULL default '0',
    maxquota bigint(20) NOT NULL default '0',
    quota bigint(20) NOT NULL default '0',
    transport varchar(255) default NULL,
    backupmx tinyint(1) NOT NULL default '0',
    created datetime NOT NULL default CURRENT_TIMESTAMP,
    modified datetime NOT NULL default CURRENT_TIMESTAMP,
    active tinyint(1) NOT NULL default '1',
    PRIMARY KEY (domain)
);

-- Mailbox table
CREATE TABLE mailbox (
    username varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    name varchar(255),
    maildir varchar(255) NOT NULL,
    quota bigint(20) NOT NULL default '0',
    local_part varchar(255) NOT NULL,
    domain varchar(255) NOT NULL,
    created datetime NOT NULL default CURRENT_TIMESTAMP,
    modified datetime NOT NULL default CURRENT_TIMESTAMP,
    active tinyint(1) NOT NULL default '1',
    PRIMARY KEY (username),
    FOREIGN KEY (domain) REFERENCES domain(domain) ON DELETE CASCADE
);

-- Alias table
CREATE TABLE alias (
    address varchar(255) NOT NULL,
    goto text NOT NULL,
    domain varchar(255) NOT NULL,
    created datetime NOT NULL default CURRENT_TIMESTAMP,
    modified datetime NOT NULL default CURRENT_TIMESTAMP,
    active tinyint(1) NOT NULL default '1',
    PRIMARY KEY (address),
    FOREIGN KEY (domain) REFERENCES domain(domain) ON DELETE CASCADE
);

-- Alias domain
CREATE TABLE alias_domain (
    alias_domain varchar(255) NOT NULL,
    target_domain varchar(255) NOT NULL,
    created datetime NOT NULL default CURRENT_TIMESTAMP,
    modified datetime NOT NULL default CURRENT_TIMESTAMP,
    active tinyint(1) NOT NULL default '1',
    PRIMARY KEY (alias_domain),
    FOREIGN KEY (target_domain) REFERENCES domain(domain) ON DELETE CASCADE
);

-- Create indexes
CREATE INDEX domain_active ON domain(active);
CREATE INDEX mailbox_active ON mailbox(active);
CREATE INDEX mailbox_username ON mailbox(username);
CREATE INDEX alias_active ON alias(active);
CREATE INDEX alias_address ON alias(address);
CREATE INDEX alias_domain_active ON alias_domain(active);

-- Create admin account if needed
INSERT INTO domain (domain, description) VALUES ('${DOMAIN}', 'Default Domain');
EOF

    chown www-data:www-data "$SQLITE_DB"
    chmod 660 "$SQLITE_DB"
fi 