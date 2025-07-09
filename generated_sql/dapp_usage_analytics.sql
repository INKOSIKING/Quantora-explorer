-- Table: dapp_usage_analytics
-- Description: Aggregated performance and usage metrics for dApps on Quantora

CREATE TABLE IF NOT EXISTS dapp_usage_analytics (
    id BIGSERIAL PRIMARY KEY,
    dapp_id UUID NOT NULL,
    date DATE NOT NULL,
    daily_active_users INTEGER DEFAULT 0,
    new_users INTEGER DEFAULT 0,
    total_transactions INTEGER DEFAULT 0,
    average_latency_ms INTEGER DEFAULT 0,
    failed_transactions INTEGER DEFAULT 0,
    gas_consumed NUMERIC(38, 18) DEFAULT 0,
    uptime_percentage NUMERIC(5, 2) DEFAULT 100.00,
    crash_reports JSONB,
    recorded_at TIMESTAMPTZ DEFAULT now(),

    CONSTRAINT fk_dapp_usage_analytics_dapp
        FOREIGN KEY (dapp_id) REFERENCES dapps(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_dapp_usage_analytics_date_dapp ON dapp_usage_analytics(date, dapp_id);

COMMENT ON TABLE dapp_usage_analytics IS 'Daily analytics for dApp usage, stability, and performance on the Quantora blockchain.';
