-- File: schemas/internal_transactions.sql

CREATE TABLE IF NOT EXISTS internal_transactions (
  internal_tx_id     BIGSERIAL PRIMARY KEY,
  parent_tx_hash     VARCHAR(66) NOT NULL,
  trace_id           TEXT NOT NULL, -- Unique trace path ID
  from_address       VARCHAR(66) NOT NULL,
  to_address         VARCHAR(66),
  value              NUMERIC(78, 0) NOT NULL DEFAULT 0,
  gas_used           BIGINT,
  input              BYTEA,
  output             BYTEA,
  type               VARCHAR(32) NOT NULL, -- call, delegatecall, staticcall, create, etc.
  error              TEXT,
  block_number       BIGINT NOT NULL,
  block_hash         VARCHAR(66) NOT NULL,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes for fast lookups
CREATE INDEX IF NOT EXISTS idx_internal_tx_parent_hash ON internal_transactions (parent_tx_hash);
CREATE INDEX IF NOT EXISTS idx_internal_tx_block ON internal_transactions (block_number);
CREATE INDEX IF NOT EXISTS idx_internal_tx_from_to ON internal_transactions (from_address, to_address);

-- 🔒 Constraints
ALTER TABLE internal_transactions
  ADD CONSTRAINT chk_parent_tx_hash_format CHECK (parent_tx_hash ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_block_hash_format CHECK (block_hash ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_from_address_format CHECK (from_address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_to_address_format CHECK (to_address ~ '^0x[a-fA-F0-9]{40}$');
