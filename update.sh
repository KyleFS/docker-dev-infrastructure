#! /usr/bin/bash

# Define the files to back up
BACKUP_FILES=(".env" "extra-hosts.yml")
BACKUP_DIR="__backup"
APP_DIR="devtainer"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Backup existing files
for file in "${BACKUP_FILES[@]}"; do
    if [ -f "$APP_DIR/$file" ]; then
        echo "Backing up $file..."
        cp "$APP_DIR/$file" "$BACKUP_DIR/$file.bak"
    fi
done

rm -rf $APP_DIR

echo "Updating services..."
git clone https://github.com/KyleFS/docker-dev-infrastructure devtainer

# Restore backed-up files
for file in "${BACKUP_FILES[@]}"; do
    if [ -f "$BACKUP_DIR/$file.bak" ]; then
        rm -rf "$APP_DIR/$file"
        echo "Restoring $file..."
        mv "$BACKUP_DIR/$file.bak" "$APP_DIR/$file"
    fi
done

rm -rf update.sh
cp $APP_DIR/update.sh update.sh
chmod +x update.sh

# Delete backup folder
rm -rf $BACKUP_DIR

# Deploy the docker compose stack.
docker stack rm devtainer
docker stack deploy -c devtainer/docker-compose.yml devtainer

echo "Update process complete."
