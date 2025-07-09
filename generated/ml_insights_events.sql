-- ============================================================================
-- 🧠 Table: ml_insights_events
-- 📘 Stores AI/ML-generated insights, forecasts, or alerts on-chain
-- ============================================================================

CREATE TABLE IF NOT EXISTS ml_insights_events (
  insight_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  insight_type        TEXT NOT NULL CHECK (
    insight_type IN (
      'price_forecast', 'anomaly_detection', 'bot_activity',
      'fraud_alert', 'volume_spike', 'token_risk_alert',
      'dapp_popularity', 'whale_alert', 'volatility_warning'
    )
  ),
  related_entity      TEXT NOT NULL, -- Can be wallet, token, dapp, etc.
  confidence_score    NUMERIC(5,4) NOT NULL CHECK (confidence_score >= 0 AND confidence_score <= 1),
  triggered_at        TIMESTAMPTZ NOT NULL,
  expires_at          TIMESTAMPTZ,
  metadata            JSONB DEFAULT '{}'::jsonb,
  source_model        TEXT NOT NULL DEFAULT 'ml_v1_pipeline'
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ml_insights_type ON ml_insights_events(insight_type);
CREATE INDEX IF NOT EXISTS idx_ml_insights_entity ON ml_insights_events(related_entity);
CREATE INDEX IF NOT EXISTS idx_ml_insights_time ON ml_insights_events(triggered_at);
