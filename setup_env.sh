#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p logs migrations sql tests schemas scripts

if [[ -f .env ]]; then
  echo "📦 Loading .env"
  set -a
  source .env
  set +a
else
  echo "⚠️  .env file missing. You can create one to override defaults."
fi

export DB_USER="${DB_USER:-quantora_user}"
export DB_PASSWORD="${DB_PASSWORD:-123456Qa@}"
export DB_NAME="${DB_NAME:-quantora}"
export DB_HOST="${DB_HOST:-localhost}"
export DB_PORT="${DB_PORT:-5432}"
export PGDATA="${PGDATA:-/var/lib/postgresql/data}"
export USE_DOCKER="${USE_DOCKER:-true}"
export POSTGRES_CONTAINER_NAME="${POSTGRES_CONTAINER_NAME:-quantora-db}"

declare -a REQUIRED_FILES=(
  ".env"
  "migrations/001_create_blocks.sql"
  "migrations/002_create_transactions.sql"
  "migrations/003_create_accounts.sql"
  "scripts/init_db.sh"
)

echo "🔍 Validating required project files..."
for file in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "❌ MISSING: $file"
  else
    echo "✅ FOUND: $file"
  fi
done

if [[ "$USE_DOCKER" == "true" ]]; then
  echo "🐳 Checking Docker..."
  if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Docker is not installed or not in PATH."
    exit 1
  fi

  if ! docker ps >/dev/null 2>&1; then
    echo "❌ Docker is not running."
    exit 1
  fi

  if ! docker inspect "$POSTGRES_CONTAINER_NAME" >/dev/null 2>&1; then
    echo "❌ PostgreSQL container '$POSTGRES_CONTAINER_NAME' not found."
  else
    echo "✅ Docker container '$POSTGRES_CONTAINER_NAME' is present."
  fi
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="logs/environment_check_$TIMESTAMP.log"
echo "📝 Logging output to $LOG_FILE"
{
  echo "Environment Check @ $TIMESTAMP"
  echo "DB_USER=$DB_USER"
  echo "DB_NAME=$DB_NAME"
  echo "DB_HOST=$DB_HOST"
  echo "DB_PORT=$DB_PORT"
  echo "Docker Mode = $USE_DOCKER"
} >> "$LOG_FILE"

echo "✅ Environment setup script completed. No migrations run."
