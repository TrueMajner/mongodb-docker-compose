#!/bin/bash

BACKUP_DIR="./backup"
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating backup directory..."
    mkdir -p "$BACKUP_DIR"
fi

TIMESTAMP=$(date +%F_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/mongodb_backup_$TIMESTAMP.archive"
docker exec mongodb mongodump --archive="$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup created successfully: $BACKUP_FILE"
else
    echo "Error: Backup failed!" >&2
    exit 1
fi

find "$BACKUP_DIR" -name "*.archive" -mtime +7 -delete
