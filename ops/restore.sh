#!/bin/bash
set -e
DATA_DIR="/var/lib/quantora"
BACKUP_FILE="$1"
if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: restore.sh <backup-file>"
  exit 1
fi
systemctl stop quantorad
tar -xzf $BACKUP_FILE -C /
systemctl start quantorad
echo "Restore complete."