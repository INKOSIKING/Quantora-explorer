-- File: schemas/state_deltas.sql

CREATE TABLE IF NOT EXISTS state_deltas (
  delta_id           BIGSERIAL PRIMARY KEY,
  block_number       BIGINT NOT NULL,
  address            VARCHAR(66) NOT NULL,
  key                VARCHAR NOT NULL,
  old_value          TEXT,
  new_value          TEXT,
  change_type        VARCHAR(16) NOT NULL CHECK (change_type IN ('write', 'delete', 'update')),
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_state_deltas_block_address ON state_deltas (block_number, address);
CREATE INDEX IF NOT EXISTS idx_state_deltas_key ON state_deltas (key);

-- 🔒 Constraints
ALTER TABLE state_deltas
  ADD CONSTRAINT chk_address_format CHECK (address ~ '^0x[a-fA-F0-9]{40}$');
