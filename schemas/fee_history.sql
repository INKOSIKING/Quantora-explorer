-- File: schemas/fee_history.sql

CREATE TABLE IF NOT EXISTS fee_history (
  id                  BIGSERIAL PRIMARY KEY,
  block_number        BIGINT NOT NULL,
  base_fee_per_gas    NUMERIC(78, 0) NOT NULL,
  gas_used_ratio      NUMERIC(10, 8) NOT NULL CHECK (gas_used_ratio >= 0 AND gas_used_ratio <= 1),
  reward              NUMERIC(78, 0)[],
  timestamp           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes for analytics and prediction
CREATE INDEX IF NOT EXISTS idx_fee_history_block_number ON fee_history (block_number);
