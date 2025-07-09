-- =============================================================================
-- 🧠 Table: ai_agent_signals
-- 📡 Records AI-generated market/trading/portfolio signals
-- =============================================================================

CREATE TABLE IF NOT EXISTS ai_agent_signals (
  signal_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id               TEXT NOT NULL,
  signal_type            TEXT NOT NULL CHECK (
    signal_type IN (
      'price_prediction', 'arbitrage_opportunity', 'risk_alert',
      'rebalancing_recommendation', 'volatility_alert', 'liquidity_shift',
      'yield_opportunity', 'gas_spike_warning', 'chain_congestion_forecast'
    )
  ),
  signal_payload         JSONB NOT NULL, -- full AI reasoning/output
  confidence_score       NUMERIC(5,4) CHECK (confidence_score >= 0 AND confidence_score <= 1),
  signal_timestamp       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  related_entities       TEXT[], -- wallets, contracts, tokens, chains
  execution_reference_id UUID, -- ties to autonomous_portfolio_adjustments.adjustment_id, etc.
  signal_status          TEXT NOT NULL CHECK (
    signal_status IN ('new', 'in_review', 'executed', 'dismissed', 'expired')
  ),
  metadata               JSONB,
  UNIQUE(agent_id, signal_timestamp, signal_type)
);

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_signal_type ON ai_agent_signals(signal_type);
CREATE INDEX IF NOT EXISTS idx_ai_signal_status ON ai_agent_signals(signal_status);
CREATE INDEX IF NOT EXISTS idx_ai_signal_entities ON ai_agent_signals USING GIN(related_entities);
