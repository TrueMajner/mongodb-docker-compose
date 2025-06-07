#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo."
   exit 1
fi

LOG_FILE="/var/log/mongodb-docker-setup.log"
echo "Starting setup at $(date)" >> "$LOG_FILE"

echo "Updating package list..." | tee -a "$LOG_FILE"
apt update && apt upgrade -y >> "$LOG_FILE" 2>&1

if ! command -v docker &> /dev/null; then
    echo "Installing Docker..." | tee -a "$LOG_FILE"
    apt install -y docker.io >> "$LOG_FILE" 2>&1
    systemctl enable docker >> "$LOG_FILE" 2>&1
    systemctl start docker >> "$LOG_FILE" 2>&1
else
    echo "Docker is already installed." | tee -a "$LOG_FILE"
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..." | tee -a "$LOG_FILE"
    apt install -y docker-compose >> "$LOG_FILE" 2>&1
else
    echo "Docker Compose is already installed." | tee -a "$LOG_FILE"
fi

if ! dpkg -l | grep -qw cron; then
    echo "Installing cron..." | tee -a "$LOG_FILE"
    apt install -y cron >> "$LOG_FILE" 2>&1
    systemctl enable cron >> "$LOG_FILE" 2>&1
    systemctl start cron >> "$LOG_FILE" 2>&1
else
    echo "Cron is already installed." | tee -a "$LOG_FILE"
fi

echo "Starting Docker Compose..." | tee -a "$LOG_FILE"
docker-compose up -d >> "$LOG_FILE" 2>&1

chmod +x backup.sh

PROJECT_DIR=$(pwd)
BACKUP_SCHEDULE=${BACKUP_SCHEDULE:-"0 3 * * *"}
(crontab -l 2>/dev/null; echo "$BACKUP_SCHEDULE /bin/bash $PROJECT_DIR/backup.sh") | crontab -

echo "Setup completed successfully. MongoDB is running, and backups are scheduled." | tee -a "$LOG_FILE"
