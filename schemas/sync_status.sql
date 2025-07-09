-- File: schemas/sync_status.sql

CREATE TABLE IF NOT EXISTS sync_status (
  node_id              TEXT PRIMARY KEY,
  is_syncing           BOOLEAN NOT NULL,
  starting_block       BIGINT,
  current_block        BIGINT,
  highest_block        BIGINT,
  pulled_peers         INTEGER,
  known_peers          INTEGER,
  lag_blocks           BIGINT GENERATED ALWAYS AS (highest_block - current_block) STORED,
  checked_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔁 Auto-update updated_at
CREATE OR REPLACE FUNCTION update_sync_status_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_sync_status_updated_at
BEFORE UPDATE ON sync_status
FOR EACH ROW EXECUTE FUNCTION update_sync_status_updated_at();

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_sync_status_checked_at ON sync_status (checked_at);
CREATE INDEX IF NOT EXISTS idx_sync_status_current_block ON sync_status (current_block);
