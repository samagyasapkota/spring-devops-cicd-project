#!/bin/bash

# Database Backup Script for PetClinic MySQL
# Runs daily at 10 PM via cron

BACKUP_DIR="/var/backups/petclinic"
DATE=$(date +%Y%m%d_%H%M%S)
MYSQL_CONTAINER="petclinic-mysql"
DB_NAME="petclinic"
DB_USER="root"
DB_PASS="petclinic"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
docker exec $MYSQL_CONTAINER mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/petclinic_$DATE.sql

# Compress backup
gzip $BACKUP_DIR/petclinic_$DATE.sql

# Keep only last 7 days of backups
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete

echo "Backup completed: petclinic_$DATE.sql.gz"
