-- File: schemas/rejected_transactions.sql

CREATE TABLE IF NOT EXISTS rejected_transactions (
  reject_id         BIGSERIAL PRIMARY KEY,
  tx_hash           VARCHAR(66) NOT NULL,
  reason            TEXT NOT NULL,
  sender_address    VARCHAR(66),
  nonce             BIGINT,
  gas_price         NUMERIC(78, 0),
  gas_limit         BIGINT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes for analysis
CREATE INDEX IF NOT EXISTS idx_rejected_tx_hash ON rejected_transactions (tx_hash);
CREATE INDEX IF NOT EXISTS idx_rejected_sender ON rejected_transactions (sender_address);
CREATE INDEX IF NOT EXISTS idx_rejected_reason ON rejected_transactions (reason);

-- 🔒 Constraints
ALTER TABLE rejected_transactions
  ADD CONSTRAINT chk_tx_hash_format CHECK (tx_hash ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_sender_format CHECK (sender_address IS NULL OR sender_address ~ '^0x[a-fA-F0-9]{40}$');
