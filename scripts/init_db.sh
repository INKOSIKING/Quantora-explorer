#!/usr/bin/env bash
set -euo pipefail

# === [📦 Load .env] ===
if [[ -f .env ]]; then
  echo "�� Loading .env"
  set -a
  source .env
  set +a
else
  echo "⚠️  No .env file found. Using fallback env vars."
fi

# === [⚙️ Defaults] ===
export DB_USER="${DB_USER:-quantora_user}"
export DB_PASSWORD="${DB_PASSWORD:-123456Qa@}"
export DB_NAME="${DB_NAME:-quantora}"
export DB_HOST="${DB_HOST:-localhost}"
export DB_PORT="${DB_PORT:-5432}"

# === [🧰 Create Database and User If Not Exists] ===
echo "🛠️  Checking if database '$DB_NAME' and user '$DB_USER' exist..."

psql -h "$DB_HOST" -p "$DB_PORT" -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1 || \
  psql -h "$DB_HOST" -p "$DB_PORT" -U postgres -c "CREATE DATABASE \"$DB_NAME\";"

psql -h "$DB_HOST" -p "$DB_PORT" -U postgres -tc "SELECT 1 FROM pg_roles WHERE rolname = '$DB_USER'" | grep -q 1 || \
  psql -h "$DB_HOST" -p "$DB_PORT" -U postgres -c "CREATE USER \"$DB_USER\" WITH PASSWORD '$DB_PASSWORD';"

# === [🔒 Grant Privileges] ===
psql -h "$DB_HOST" -p "$DB_PORT" -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE \"$DB_NAME\" TO \"$DB_USER\";"

echo "✅ Database '$DB_NAME' and user '$DB_USER' are ready."
