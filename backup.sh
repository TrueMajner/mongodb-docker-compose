TIMESTAMP=$(date +%F_%H-%M-%S)
docker exec mongodb mongodump --archive=/backup/mongodb_backup_$TIMESTAMP.archive
