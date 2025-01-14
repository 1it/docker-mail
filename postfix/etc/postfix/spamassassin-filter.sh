#!/bin/bash
# Pipe incoming mail to SpamAssassin

SENDMAIL="/usr/sbin/sendmail -G -i" # Forward the mail
SPAMC="/usr/bin/spamc -d spamassassin -p 783"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >&2
}

# Clean up when done or when aborting
trap "rm -f $TEMP_FILE" 0 1 2 3 15

# Create temporary file
TEMP_FILE=$(mktemp)

log_message "Processing message for $@"

# Save message to temp file
cat > $TEMP_FILE

# Check spam score
$SPAMC -c < $TEMP_FILE
SCORE=$?

if [ $SCORE -eq 0 ]; then
    log_message "Message passed spam check"
    # Not spam, forward the mail
    $SENDMAIL "$@" < $TEMP_FILE
elif [ $SCORE -eq 1 ]; then
    log_message "Message marked as spam"
    # Spam, add header and forward
    $SPAMC < $TEMP_FILE | $SENDMAIL "$@"
else
    log_message "Error processing message: $SCORE"
    # Error occurred
    exit $SCORE
fi 