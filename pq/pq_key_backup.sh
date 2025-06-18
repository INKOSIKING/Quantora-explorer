#!/bin/bash
KEYS_DIR="pq_keys"
BACKUP_DIR="pq_backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_FILE="$BACKUP_DIR/pq_keys_backup_$TIMESTAMP.tar.gz"
mkdir -p "$BACKUP_DIR"
if [[ -d "$KEYS_DIR" ]]; then
  echo; echo "🧳 Backing up $KEYS_DIR → $ARCHIVE_FILE"
  tar -czf "$ARCHIVE_FILE" "$KEYS_DIR"
  echo "✅ Backup done."
else
  echo "❌ $KEYS_DIR not found."
fi
echo; read -rp "⏸️ Press Enter to finish..."
