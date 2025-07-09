-- ============================================================================
-- 🎯 Table: wallet_strategy_insights
-- 📘 AI-determined strategic roles of wallets on-chain
-- ============================================================================

CREATE TABLE IF NOT EXISTS wallet_strategy_insights (
  wallet_address        TEXT PRIMARY KEY,
  inferred_strategy     TEXT NOT NULL,
  strategy_explanation  TEXT,
  portfolio_bias        TEXT CHECK (
    portfolio_bias IN ('token-heavy', 'nft-heavy', 'stablecoin-heavy', 'balanced', 'unknown')
  ),
  volatility_index      NUMERIC(7,4) CHECK (volatility_index >= 0),
  rebalancing_pattern   TEXT CHECK (
    rebalancing_pattern IN ('static', 'periodic', 'dynamic', 'none')
  ),
  last_evaluated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ai_model_version      TEXT NOT NULL DEFAULT 'strategy_ai_v3.5'
);

-- 🧠 Indexes
CREATE INDEX IF NOT EXISTS idx_wallet_strategy_type ON wallet_strategy_insights(inferred_strategy);
CREATE INDEX IF NOT EXISTS idx_wallet_volatility ON wallet_strategy_insights(volatility_index);
