#!/bin/bash
set -e

# Create required directories
mkdir -p /var/run/spamd
mkdir -p /var/lib/spamassassin/.spamassassin
chmod 700 /var/lib/spamassassin/.spamassassin
chown -R debian-spamd:debian-spamd /var/lib/spamassassin

# Initialize SpamAssassin database if needed
if [ ! -f /var/lib/spamassassin/3.004002/updates_spamassassin_org.cf ]; then
    echo "Initializing SpamAssassin database..."
    runuser -u debian-spamd -- sa-update --verbose --gpghomedir /var/lib/spamassassin/.spamassassin | grep -q "Update finished, no fresh updates were available" || {
        echo "No SpamAssassin rules updates available. Continuing with defaults..."
    }
fi

# Configure SpamAssassin
cat > /etc/spamassassin/local.cf << EOF
# Basic configuration
required_score 5.0
report_safe 0
rewrite_header Subject [SPAM]
add_header spam Flag _YESNO_

# Network configuration
dns_available yes
trusted_networks ${MY_NETWORKS}

# Learning configuration
bayes_auto_learn 1
bayes_auto_learn_threshold_spam 12.0
bayes_auto_learn_threshold_nonspam 0.1

# Use Bayes filtering
use_bayes 1
bayes_auto_expire 1

# RBL checks
score URIBL_BLACK 7.5
score URIBL_DBL_SPAM 7.5
score SURBL_MULTI 7.5
EOF

# Set proper permissions
chown -R debian-spamd:debian-spamd /etc/spamassassin
chmod -R 755 /etc/spamassassin

# Start SpamAssassin daemon
exec /usr/sbin/spamd \
    --create-prefs \
    --max-children 5 \
    --helper-home-dir \
    --username debian-spamd \
    -i 0.0.0.0:783 \
    --allow-tell \
    -s stderr 