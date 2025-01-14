#!/bin/bash
set -e

# Create required directories
mkdir -p /var/run/clamav
chown clamav:clamav /var/run/clamav

# Ensure CA certificates are up to date
update-ca-certificates

# Initialize virus database if needed
if [ ! -f /var/lib/clamav/main.cvd ]; then
    echo "Initializing ClamAV virus database..."
    freshclam
fi

# Start freshclam daemon
freshclam -d &

# Start ClamAV daemon
exec clamd 