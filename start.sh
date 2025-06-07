#!/bin/bash
sudo apt update && sudo apt upgrade -y

if ! command -v docker &> /dev/null; then
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker is already installed."
fi

if ! command -v docker-compose &> /dev/null; then
    sudo apt install -y docker-compose
else
    echo "Docker Compose is already installed."
fi

if ! dpkg -l | grep -qw cron; then
    sudo apt install -y cron
    sudo systemctl enable cron
    sudo systemctl start cron
else
    echo "Cron is already installed."
fi

docker-compose up -d

chmod +x backup.sh

(crontab -l 2>/dev/null; echo "0 3 * * * /bin/bash /mongodb-docker-compose/backup.sh") | crontab -
