#! /usr/bin/bash


# Define the files to back up
BACKUP_FILES=(".env" "extra-hosts.yml")
BACKUP_DIR="../__backup"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Backup existing files
for file in "${BACKUP_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Backing up $file..."
        cp "$file" "$BACKUP_DIR/$file.bak"
    fi
done

rm -rf devtainer

echo "Updating services..."
git clone https://github.com/KyleFS/docker-dev-infrastructure devtainer

# Restore backed-up files
for file in "${BACKUP_FILES[@]}"; do
    if [ -f "$BACKUP_DIR/$file.bak" ]; then
        rm -rf "$file"
        echo "Restoring $file..."
        mv "$BACKUP_DIR/$file.bak" "$file"
    fi
done

cp devtainer/update.sh update.sh
chown +x update.sh

# Delete backup folder
rm -rf $BACKUP_DIR

# Deploy the docker compose stack.
docker stack rm devtainer
docker stack deploy -c devtainer/docker-compose.yml devtainer

echo "Update process complete."
