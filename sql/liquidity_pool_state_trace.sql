-- ================================================================================
-- 💧 Table: liquidity_pool_state_trace
-- Description: Captures state snapshots of AMM/DEX liquidity pools over time.
-- Supports audits, simulations, arbitrage analysis, and LP performance tracking.
-- ================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'liquidity_pool_state_trace'
  ) THEN
    CREATE TABLE liquidity_pool_state_trace (
      trace_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      pool_address         TEXT NOT NULL,
      timestamp            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      token0_address       TEXT NOT NULL,
      token1_address       TEXT NOT NULL,
      token0_reserve       NUMERIC(78, 0) NOT NULL,
      token1_reserve       NUMERIC(78, 0) NOT NULL,
      total_liquidity      NUMERIC(78, 0),
      fee_rate_bps         INTEGER,
      block_number         BIGINT,
      tx_hash              TEXT,
      snapshot_source      TEXT DEFAULT 'onchain',
      health_score         NUMERIC(5,2),
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_pool_trace_timestamp ON liquidity_pool_state_trace(pool_address, timestamp DESC);
