-- ==========================================================================================
-- 📊 Table: dapp_engagement_metrics
-- Description: Tracks daily user interaction stats and behavioral analytics for dApps
-- ==========================================================================================

CREATE TABLE IF NOT EXISTS dapp_engagement_metrics (
    engagement_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dapp_id               UUID NOT NULL,
    date                  DATE NOT NULL,
    daily_active_users    INTEGER DEFAULT 0,
    new_users             INTEGER DEFAULT 0,
    returning_users       INTEGER DEFAULT 0,
    avg_session_duration  INTERVAL,
    median_gas_spent      BIGINT,
    interaction_count     BIGINT,
    unique_methods_called INTEGER,
    region_distribution   JSONB,
    inserted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (dapp_id) REFERENCES dapp_registry(dapp_id) ON DELETE CASCADE,
    UNIQUE (dapp_id, date)
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_dapp_engagement_date ON dapp_engagement_metrics(date);
CREATE INDEX IF NOT EXISTS idx_dapp_engagement_dapp ON dapp_engagement_metrics(dapp_id);
