-- ==========================================================================
-- 📊 Table: token_distribution_metrics
-- Description: Tracks token holder distribution, concentration, and Gini
-- coefficients per snapshot. Useful for fairness, decentralization metrics.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_distribution_metrics'
  ) THEN
    CREATE TABLE token_distribution_metrics (
      metric_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address          TEXT NOT NULL,
      snapshot_block_number  BIGINT NOT NULL,
      total_holders          INTEGER NOT NULL,
      gini_coefficient       NUMERIC(5,4) CHECK (gini_coefficient >= 0 AND gini_coefficient <= 1),
      whale_holdings_percent NUMERIC(5,2),
      top_10_holders_percent NUMERIC(5,2),
      entropy_score          NUMERIC(6,4),
      distribution_curve     JSONB,     -- Histogram or bin range mapping
      sampled_at             TIMESTAMPTZ DEFAULT NOW(),
      inserted_at            TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_token_dist_token_block ON token_distribution_metrics(token_address, snapshot_block_number);
CREATE INDEX IF NOT EXISTS idx_token_dist_gini ON token_distribution_metrics(gini_coefficient);
