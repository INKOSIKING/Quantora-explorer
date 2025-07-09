-- ========================================
-- Schema: Blockchain Explorer Engine
-- Purpose: Read-optimized insights engine
-- ========================================

-- === Address Summaries ===
CREATE TABLE IF NOT EXISTS address_summaries (
  address          VARCHAR(66) PRIMARY KEY,
  balance          NUMERIC DEFAULT 0,
  total_received   NUMERIC DEFAULT 0,
  total_sent       NUMERIC DEFAULT 0,
  txn_count        BIGINT DEFAULT 0,
  first_seen_at    TIMESTAMPTZ,
  last_seen_at     TIMESTAMPTZ,
  is_contract      BOOLEAN DEFAULT FALSE,
  label            TEXT
);

-- === Transaction Events (Logs) ===
CREATE TABLE IF NOT EXISTS transaction_logs (
  log_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tx_hash          VARCHAR(66) NOT NULL,
  log_index        INT NOT NULL,
  address          VARCHAR(66) NOT NULL,
  event_signature  VARCHAR(256),
  topic0           VARCHAR(66),
  topic1           VARCHAR(66),
  topic2           VARCHAR(66),
  topic3           VARCHAR(66),
  data             BYTEA,
  block_number     BIGINT,
  timestamp        TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_tx_logs_txhash ON transaction_logs(tx_hash);
CREATE INDEX IF NOT EXISTS idx_tx_logs_address ON transaction_logs(address);
CREATE INDEX IF NOT EXISTS idx_tx_logs_event ON transaction_logs(event_signature);

-- === Daily Stats ===
CREATE TABLE IF NOT EXISTS daily_chain_stats (
  stat_date        DATE PRIMARY KEY,
  tx_count         BIGINT,
  unique_senders   BIGINT,
  new_addresses    BIGINT,
  gas_used_total   BIGINT,
  gas_price_avg    NUMERIC,
  block_count      BIGINT,
  avg_block_time   NUMERIC
);

-- === Contract Verification Metadata ===
CREATE TABLE IF NOT EXISTS verified_contracts (
  contract_address VARCHAR(66) PRIMARY KEY,
  creator_address  VARCHAR(66),
  source_code      TEXT,
  abi_json         JSONB,
  compiler_version VARCHAR(64),
  optimization     BOOLEAN,
  verified_at      TIMESTAMPTZ DEFAULT NOW()
);
