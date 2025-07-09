-- ============================================================================
-- 🧠 Table: ai_trader_profiles
-- 📘 AI-generated behavioral profiles and strategy tags for individual wallets
-- ============================================================================

CREATE TABLE IF NOT EXISTS ai_trader_profiles (
  wallet_address      TEXT PRIMARY KEY,
  risk_tolerance      TEXT NOT NULL CHECK (
    risk_tolerance IN ('low', 'moderate', 'high', 'extreme')
  ),
  trade_frequency     TEXT NOT NULL CHECK (
    trade_frequency IN ('infrequent', 'occasional', 'active', 'high_frequency')
  ),
  behavioral_cluster  TEXT NOT NULL,
  strategy_inference  TEXT,
  ai_confidence_score NUMERIC(5,4) NOT NULL CHECK (
    ai_confidence_score >= 0 AND ai_confidence_score <= 1
  ),
  last_profiled_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ai_model_tag        TEXT NOT NULL DEFAULT 'wallet_profiler_v2.1'
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_trader_risk ON ai_trader_profiles(risk_tolerance);
CREATE INDEX IF NOT EXISTS idx_ai_trader_cluster ON ai_trader_profiles(behavioral_cluster);
