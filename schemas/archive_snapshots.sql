-- File: schemas/archive_snapshots.sql

-- 🧱 Archive Snapshots Table
CREATE TABLE IF NOT EXISTS archive_snapshots (
  snapshot_id      BIGSERIAL PRIMARY KEY,
  block_number     BIGINT NOT NULL,
  block_hash       VARCHAR(66) NOT NULL,
  state_root       VARCHAR(66) NOT NULL,
  snapshot_path    TEXT NOT NULL, -- Absolute or relative path to the full-state dump
  size_bytes       BIGINT CHECK (size_bytes >= 0),
  taken_by         VARCHAR(66), -- Node ID or operator identifier
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (block_number, block_hash)
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_snapshot_block_number ON archive_snapshots (block_number);
CREATE INDEX IF NOT EXISTS idx_snapshot_state_root ON archive_snapshots (state_root);

-- 🔒 Constraints
ALTER TABLE archive_snapshots
  ADD CONSTRAINT chk_block_hash_format CHECK (block_hash ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_state_root_format CHECK (state_root ~ '^0x[a-fA-F0-9]{64}$');
