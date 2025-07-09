CREATE TABLE IF NOT EXISTS logs (
  log_id           BIGSERIAL PRIMARY KEY,
  tx_hash          VARCHAR(66) NOT NULL,
  log_index        INTEGER NOT NULL,
  block_number     BIGINT NOT NULL,
  block_hash       VARCHAR(66) NOT NULL,
  address          VARCHAR(66) NOT NULL,
  data             BYTEA,
  topics           TEXT[] NOT NULL,
  removed          BOOLEAN NOT NULL DEFAULT FALSE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_logs_tx_hash ON logs (tx_hash);
CREATE INDEX IF NOT EXISTS idx_logs_block_number ON logs (block_number);
CREATE INDEX IF NOT EXISTS idx_logs_address ON logs (address);
CREATE INDEX IF NOT EXISTS idx_logs_topics_gin ON logs USING GIN (topics);

-- 🔒 Constraints
ALTER TABLE logs
  ADD CONSTRAINT chk_log_address_format CHECK (address ~ '^0x[a-fA-F0-9]{40}$'),
  ADD CONSTRAINT chk_log_hash_format CHECK (tx_hash ~ '^0x[a-fA-F0-9]{64}$'),
  ADD CONSTRAINT chk_block_hash_format CHECK (block_hash ~ '^0x[a-fA-F0-9]{64}$');
