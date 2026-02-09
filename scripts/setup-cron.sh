#!/bin/bash

# Setup cron job for database backup at 10 PM daily

SCRIPT_PATH="/opt/petclinic/scripts/backup.sh"
CRON_SCHEDULE="0 22 * * *"

# Add cron job
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $SCRIPT_PATH >> /var/log/petclinic-backup.log 2>&1") | crontab -

echo "Cron job added: Database backup will run daily at 10 PM"
crontab -l
