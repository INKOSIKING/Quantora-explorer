-- ==========================================================================
-- 📊 Table: dapp_usage_stats
-- Description: Aggregated metrics of dApp usage across the blockchain
-- ==========================================================================

CREATE TABLE IF NOT EXISTS dapp_usage_stats (
    stat_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dapp_address      TEXT NOT NULL,
    dapp_name         TEXT,
    unique_users      BIGINT DEFAULT 0,
    total_transactions BIGINT DEFAULT 0,
    daily_active_users BIGINT DEFAULT 0,
    weekly_active_users BIGINT DEFAULT 0,
    monthly_active_users BIGINT DEFAULT 0,
    total_volume_eth  NUMERIC(38, 18) DEFAULT 0,
    total_volume_usd  NUMERIC(38, 2) DEFAULT 0,
    gas_spent         NUMERIC(38, 2) DEFAULT 0,
    recorded_date     DATE NOT NULL,
    inserted_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_stats_address ON dapp_usage_stats(dapp_address);
CREATE INDEX IF NOT EXISTS idx_dapp_stats_date ON dapp_usage_stats(recorded_date);
