#!/bin/bash
# Pipe incoming mail to ClamAV

SENDMAIL="/usr/sbin/sendmail -G -i" # Forward the mail
CLAMDSCAN="/usr/bin/clamdscan --stdout --no-summary --config-file=/etc/clamav/clamd.conf"

# Clean up when done or when aborting
trap "rm -f $TEMP_FILE" 0 1 2 3 15

# Start virus scan
$CLAMDSCAN - | tee /dev/stderr | grep -q "FOUND"
if [ "${PIPESTATUS[1]}" = "1" ]; then
    # Virus found, reject message
    exit 1
fi

# No virus, forward the mail
$SENDMAIL "$@" 