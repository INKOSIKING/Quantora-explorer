-- =============================================================================
-- 🤖 Table: autonomous_portfolio_adjustments
-- 📊 Logs AI/bot-generated portfolio change decisions and executions
-- =============================================================================

CREATE TABLE IF NOT EXISTS autonomous_portfolio_adjustments (
  adjustment_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address         TEXT NOT NULL,
  execution_timestamp    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  trigger_type           TEXT NOT NULL CHECK (
    trigger_type IN ('volatility-spike', 'rebalance-timer', 'yield-optimization', 'user-delegated', 'anomaly-detection')
  ),
  adjustment_action      JSONB NOT NULL, -- includes token pairs, amount, DEX route, gas strategy
  estimated_impact_usd   NUMERIC(18,2),
  actual_impact_usd      NUMERIC(18,2),
  executed_by_agent      TEXT NOT NULL,
  execution_status       TEXT NOT NULL CHECK (
    execution_status IN ('pending', 'executed', 'failed', 'cancelled')
  ),
  notes                  TEXT,
  UNIQUE(wallet_address, execution_timestamp)
);

-- 🧠 Indexes
CREATE INDEX IF NOT EXISTS idx_autop_adj_wallet ON autonomous_portfolio_adjustments(wallet_address);
CREATE INDEX IF NOT EXISTS idx_autop_adj_status ON autonomous_portfolio_adjustments(execution_status);
