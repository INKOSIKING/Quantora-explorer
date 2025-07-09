-- ==========================================================================
-- 🤖 Table: ai_wallet_risk_profiles
-- Description: AI-analyzed risk profiles for wallets based on behavior,
-- clustering, heuristics, model predictions, and anomaly scores.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_wallet_risk_profiles'
  ) THEN
    CREATE TABLE ai_wallet_risk_profiles (
      profile_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      wallet_address      TEXT NOT NULL,
      profile_snapshot_at TIMESTAMPTZ NOT NULL,
      risk_level          TEXT CHECK (risk_level IN ('low', 'medium', 'high', 'critical')),
      ai_confidence       NUMERIC(5,2) CHECK (ai_confidence >= 0 AND ai_confidence <= 100),
      anomaly_score       NUMERIC(6,3),
      cluster_id          UUID,
      behavior_fingerprint JSONB,
      flagged_behaviors   TEXT[],
      origin_tags         TEXT[],
      inserted_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_wallet_risk_wallet ON ai_wallet_risk_profiles(wallet_address);
CREATE INDEX IF NOT EXISTS idx_ai_wallet_risk_cluster ON ai_wallet_risk_profiles(cluster_id);
CREATE INDEX IF NOT EXISTS idx_ai_wallet_risk_score ON ai_wallet_risk_profiles(anomaly_score);
