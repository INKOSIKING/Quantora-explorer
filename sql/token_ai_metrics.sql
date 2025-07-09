-- =============================================================================================
-- 🤖 Table: token_ai_metrics
-- Description: AI-enhanced analytics on token behavior, risk, volatility, and trustworthiness.
-- Integrates with on-chain behavior, off-chain metadata, and model outputs.
-- =============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_ai_metrics'
  ) THEN
    CREATE TABLE token_ai_metrics (
      token_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address       TEXT NOT NULL,
      symbol              TEXT,
      ai_risk_score       NUMERIC(5,2) CHECK (ai_risk_score BETWEEN 0 AND 100),
      volatility_score    NUMERIC(5,2),
      trust_score         NUMERIC(5,2),
      social_sentiment    TEXT, -- e.g., 'positive', 'neutral', 'negative'
      usage_anomaly       BOOLEAN DEFAULT FALSE,
      ai_notes            TEXT,
      evaluated_by_model  TEXT,
      model_version       TEXT,
      evaluated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      tags                TEXT[],
      extra_features      JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_token_address ON token_ai_metrics(token_address);
CREATE INDEX IF NOT EXISTS idx_ai_risk_score ON token_ai_metrics(ai_risk_score);
CREATE INDEX IF NOT EXISTS idx_evaluated_at ON token_ai_metrics(evaluated_at);

