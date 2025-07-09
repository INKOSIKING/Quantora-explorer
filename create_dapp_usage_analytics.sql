-- ============================================================================================
-- 📈 Table: dapp_usage_analytics
-- Description: Tracks user sessions, transaction volume, feature usage, and latency across dApps.
-- ============================================================================================

CREATE TABLE IF NOT EXISTS dapp_usage_analytics (
    analytics_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dapp_id                TEXT NOT NULL,
    user_wallet            TEXT NOT NULL,
    session_id             TEXT,
    interaction_count      INTEGER NOT NULL DEFAULT 0,
    total_gas_spent        NUMERIC(30, 10),
    tx_volume              NUMERIC(30, 10),
    session_duration_ms    BIGINT,
    feature_used           TEXT[],
    avg_latency_ms         INTEGER,
    device_type            TEXT,
    region                 TEXT,
    accessed_at            TIMESTAMPTZ NOT NULL,
    inserted_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_usage_user_wallet ON dapp_usage_analytics(user_wallet);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_dapp_id ON dapp_usage_analytics(dapp_id);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_accessed_at ON dapp_usage_analytics(accessed_at);
