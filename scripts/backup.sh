#!/bin/bash
set -e

# --- Configuration ---
BACKUP_NAME="eternal-backup-$(date +%Y%m%d_%H%M%S).tar.gz"
BACKUP_DIR="../apps" # Directory to backup (relative to script execution)
R2_REMOTE="eternal-r2" # Name of the rclone remote
R2_BUCKET="eternal-backups"
TEMP_DIR="/tmp"

# Get the directory where the script is stored
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🌌 Starting Eternal Backup: $BACKUP_NAME"
echo "📂 Project Root: $PROJECT_ROOT"

# 1. Stop Services (Optional but recommended for DB consistency)
# Uncomment the next line if you want to stop services during backup
# docker compose -f "$PROJECT_ROOT/core/docker-compose.yml" stop

# 2. Create Archive
echo "📦 Compressing apps directory..."
# Use -C to change to project root, then archive 'apps'
tar -czf "$TEMP_DIR/$BACKUP_NAME" -C "$PROJECT_ROOT" "apps"

# 3. Start Services (If stopped)
# docker compose -f ../core/docker-compose.yml start

# 4. Upload to R2
echo "☁️  Uploading to R2 ($R2_BUCKET)..."
if command -v rclone &> /dev/null; then
    rclone copy "$TEMP_DIR/$BACKUP_NAME" "$R2_REMOTE:$R2_BUCKET"
    echo "✅ Upload complete."
else
    echo "❌ Error: rclone not found. Please install and configure rclone."
    exit 1
fi

# 5. Cleanup
echo "🧹 Cleaning up local archive..."
rm "$TEMP_DIR/$BACKUP_NAME"

echo "🎉 Backup successful!"
