-- File: schemas/gas_metrics.sql

CREATE TABLE IF NOT EXISTS gas_metrics (
  id                BIGSERIAL PRIMARY KEY,
  block_number      BIGINT NOT NULL,
  tx_type           VARCHAR(64) NOT NULL, -- e.g. 'standard', 'contract_call', etc.
  avg_gas_used      NUMERIC(78, 0) NOT NULL,
  max_gas_used      NUMERIC(78, 0) NOT NULL,
  min_gas_used      NUMERIC(78, 0) NOT NULL,
  tx_count          INTEGER NOT NULL,
  total_gas_used    NUMERIC(78, 0) NOT NULL,
  timestamp         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_gas_metrics_block ON gas_metrics (block_number);
CREATE INDEX IF NOT EXISTS idx_gas_metrics_tx_type ON gas_metrics (tx_type);
