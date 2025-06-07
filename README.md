# MongoDB Docker Compose Setup

This project provides a simple and efficient way to deploy a MongoDB instance using Docker Compose, with automated setup scripts and scheduled backups.

## Features
- **Easy Deployment**: Spin up a MongoDB container with a single command using Docker Compose.
- **Automated Setup**: Installs Docker, Docker Compose, and cron for scheduling backups.
- **Backup Automation**: Creates daily backups (saved for one week) of the MongoDB database with timestamped archives.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/mongodb-docker-compose.git
   cd mongodb-docker-compose
   ```

2. Create a `.env` file to store sensitive environment variables:
   ```bash
   echo "MONGO_INITDB_ROOT_USERNAME=your_username" > .env
   echo "MONGO_INITDB_ROOT_PASSWORD=your_password" >> .env
   ```

3. Make the scripts executable:
   ```bash
   chmod +x start.sh backup.sh
   ```

4. Run the setup script:
   ```bash
   ./start.sh
   ```

   This will:
   - Install Docker, Docker Compose, and cron (if not already installed).
   - Start the MongoDB container in the background.
   - Schedule daily backups at 3 AM.

## Usage
- **Connect to MongoDB**:
  Connect to `localhost:27017` with the credentials specified in the `.env` file.

- **Manual Backup**:
  Run the backup script to create a backup archive:
  ```bash
  ./backup.sh
  ```
  Backups are stored in the `backup/` directory with a timestamp (e.g., `mongodb_backup_2025-06-07_03-00-00.archive`).

- **Stop the Container**:
  ```bash
  docker-compose down
  ```

## Configuration
You can customize the setup by modifying the `.env` file. Available environment variables:
- `MONGO_INITDB_ROOT_USERNAME`: MongoDB init root username
- `MONGO_INITDB_ROOT_PASSWORD`: MongoDB init root password
- `BACKUP_SCHEDULE`: Cron schedule for backups (default: `0 3 * * *` for 3 AM daily)

## Backup Restoration
To restore a backup, use the `mongorestore` command. Example:
```bash
docker exec -it mongodb mongorestore --archive=/backup/mongodb_backup_2025-06-07_03-00-00.archive
```
