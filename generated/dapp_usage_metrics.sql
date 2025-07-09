-- =============================================================================
-- 📊 Table: dapp_usage_metrics
-- 📘 Tracks daily usage, throughput, gas, and error rates per deployed dApp
-- =============================================================================

CREATE TABLE IF NOT EXISTS dapp_usage_metrics (
  id                     BIGSERIAL PRIMARY KEY,
  dapp_id                TEXT NOT NULL,
  dapp_name              TEXT,
  contract_address       TEXT NOT NULL,
  date                   DATE NOT NULL,
  tx_count               INTEGER NOT NULL DEFAULT 0,
  unique_users           INTEGER NOT NULL DEFAULT 0,
  gas_used_total         NUMERIC(38, 0) NOT NULL DEFAULT 0,
  avg_gas_per_tx         NUMERIC(38, 2),
  failed_tx_count        INTEGER NOT NULL DEFAULT 0,
  success_rate           NUMERIC(5, 2) GENERATED ALWAYS AS (
                            CASE WHEN tx_count = 0 THEN 0 ELSE
                            ROUND(100.0 * (tx_count - failed_tx_count) / tx_count, 2)
                            END
                          ) STORED,
  avg_response_time_ms   INTEGER,
  data_bytes_transferred BIGINT DEFAULT 0,
  chain_id               TEXT NOT NULL,
  created_at             TIMESTAMPTZ DEFAULT now(),
  updated_at             TIMESTAMPTZ DEFAULT now()
);

-- ⚡ Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_dapp_usage_daily ON dapp_usage_metrics(dapp_id, date);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_contract ON dapp_usage_metrics(contract_address);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_chain_date ON dapp_usage_metrics(chain_id, date);
