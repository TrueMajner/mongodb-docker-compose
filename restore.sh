#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <backup_file>"
    exit 1
fi

BACKUP_FILE="$1"
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file $BACKUP_FILE does not exist!"
    exit 1
fi

docker exec -it mongodb mongorestore --archive="$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Database restored successfully from $BACKUP_FILE"
else
    echo "Error: Restoration failed!" >&2
    exit 1
fi
