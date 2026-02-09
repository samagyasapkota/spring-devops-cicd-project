#!/bin/bash

# Database Migration Script

SOURCE_CONTAINER="petclinic-mysql-old"
TARGET_CONTAINER="petclinic-mysql"
DB_NAME="petclinic"
DB_USER="root"
DB_PASS="petclinic"
MIGRATION_FILE="/tmp/petclinic_migration.sql"

echo "Starting database migration..."

# Export from source
docker exec $SOURCE_CONTAINER mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $MIGRATION_FILE

# Import to target
docker exec -i $TARGET_CONTAINER mysql -u $DB_USER -p$DB_PASS $DB_NAME < $MIGRATION_FILE

echo "Migration completed successfully!"

# Cleanup
rm -f $MIGRATION_FILE
