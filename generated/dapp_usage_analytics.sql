-- ===========================================================
-- 📊 Table: dapp_usage_analytics
-- 📈 Tracks granular usage and interaction metrics of DApps
-- ===========================================================

CREATE TABLE IF NOT EXISTS dapp_usage_analytics (
  usage_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dapp_id                UUID NOT NULL REFERENCES dapps(dapp_id) ON DELETE CASCADE,
  user_wallet_id         UUID NOT NULL REFERENCES wallets(wallet_id),
  session_id             TEXT NOT NULL,
  interaction_type       TEXT NOT NULL CHECK (interaction_type ~ '^[a-z_]+$'),
  interaction_data       JSONB,
  gas_used               NUMERIC(38, 0) NOT NULL CHECK (gas_used >= 0),
  block_number           BIGINT NOT NULL,
  tx_hash                TEXT NOT NULL,
  timestamp              TIMESTAMPTZ NOT NULL,
  client_metadata        JSONB,
  geo_ip_hash            TEXT,
  device_fingerprint     TEXT,
  success                BOOLEAN NOT NULL DEFAULT TRUE
);

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_usage_dapp_id ON dapp_usage_analytics(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_wallet_id ON dapp_usage_analytics(user_wallet_id);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_tx ON dapp_usage_analytics(tx_hash);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_block ON dapp_usage_analytics(block_number);
