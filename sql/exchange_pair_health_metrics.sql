-- ================================================================================
-- 📊 Table: exchange_pair_health_metrics
-- Description: Tracks operational health and reliability metrics per trading pair.
-- Supports analytics on market quality, latency, spread, slippage, and liquidity.
-- ================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'exchange_pair_health_metrics'
  ) THEN
    CREATE TABLE exchange_pair_health_metrics (
      metric_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      trading_pair          TEXT NOT NULL,
      timestamp             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      avg_spread_bps        NUMERIC(10,4),
      avg_slippage_bps      NUMERIC(10,4),
      avg_latency_ms        INTEGER,
      order_fill_rate       NUMERIC(5,2),
      canceled_order_ratio  NUMERIC(5,2),
      liquidity_score       NUMERIC(5,2),
      volatility_score      NUMERIC(5,2),
      market_depth_snapshot JSONB,
      notes                 TEXT,
      inserted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_exchange_health_pair_ts ON exchange_pair_health_metrics(trading_pair, timestamp DESC);
