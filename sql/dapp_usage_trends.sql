-- ==========================================================================
-- 📊 Table: dapp_usage_trends
-- Description: Aggregates historical usage metrics of DApps to enable
-- behavioral analysis, category adoption, and long-term trends.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'dapp_usage_trends'
  ) THEN
    CREATE TABLE dapp_usage_trends (
      trend_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      dapp_name           TEXT NOT NULL,
      dapp_address        TEXT NOT NULL,
      category            TEXT,
      execution_env       TEXT,
      usage_date          DATE NOT NULL,
      daily_active_users  INTEGER NOT NULL,
      daily_tx_count      INTEGER NOT NULL,
      daily_gas_used      BIGINT,
      retention_rate      NUMERIC(5,2),
      engagement_score    NUMERIC(6,3),
      inserted_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_usage_name ON dapp_usage_trends(dapp_name);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_date ON dapp_usage_trends(usage_date);
CREATE INDEX IF NOT EXISTS idx_dapp_usage_category ON dapp_usage_trends(category);
