-- Table: dapp_usage_metrics
-- Description: Stores time-series usage metrics for DApps including traffic, transactions, and activity indicators

CREATE TABLE IF NOT EXISTS dapp_usage_metrics (
    id BIGSERIAL PRIMARY KEY,
    dapp_id TEXT NOT NULL,
    metrics_date DATE NOT NULL,
    total_sessions INTEGER NOT NULL DEFAULT 0,
    unique_wallets INTEGER NOT NULL DEFAULT 0,
    total_transactions INTEGER NOT NULL DEFAULT 0,
    average_session_duration INTERVAL,
    gas_consumed NUMERIC(32, 0) DEFAULT 0,
    failed_interactions INTEGER NOT NULL DEFAULT 0,
    api_calls INTEGER DEFAULT 0,
    active_contracts INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(dapp_id, metrics_date)
);

CREATE INDEX IF NOT EXISTS idx_dapp_usage_metrics_dapp_date ON dapp_usage_metrics(dapp_id, metrics_date);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_metrics_wallets ON dapp_usage_metrics(unique_wallets DESC);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_metrics_sessions ON dapp_usage_metrics(total_sessions DESC);

COMMENT ON TABLE dapp_usage_metrics IS 'Time-series usage metrics for DApps across sessions, wallets, and performance dimensions.';
