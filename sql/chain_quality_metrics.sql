-- ==========================================================
-- 📊 Table: chain_quality_metrics
-- ==========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'chain_quality_metrics'
  ) THEN
    CREATE TABLE chain_quality_metrics (
      metric_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      interval_start        TIMESTAMPTZ NOT NULL,
      interval_end          TIMESTAMPTZ NOT NULL,
      avg_block_time_ms     NUMERIC(10, 3),
      uncle_rate            NUMERIC(5, 4),
      finality_delay_avg    NUMERIC(10, 3),
      orphan_block_count    INT,
      reorg_count           INT,
      tx_throughput_tps     NUMERIC(10, 2),
      validator_participation_pct NUMERIC(5,2),
      missed_slot_rate      NUMERIC(5, 4),
      chain_quality_score   NUMERIC(5, 2),
      created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_chain_quality_interval ON chain_quality_metrics(interval_start, interval_end);
