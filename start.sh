sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose
sudo apt install cron
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start cron
sudo systemctl enable cron
docker-compose up -d
chmod +x backup.sh
crontab -e
0 3 * * * /bin/bash /mongodb-docker-compose/backup.sh #change path
