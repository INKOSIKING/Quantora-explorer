-- ===========================================
-- 📦 Table: l2_rollup_metrics
-- ===========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'l2_rollup_metrics'
  ) THEN
    CREATE TABLE l2_rollup_metrics (
      rollup_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      rollup_name          TEXT NOT NULL,
      l1_chain_id          TEXT NOT NULL,
      l2_chain_id          TEXT NOT NULL,
      tx_count             BIGINT NOT NULL DEFAULT 0,
      data_commitment_hash TEXT,
      proof_status         TEXT CHECK (proof_status IN ('submitted', 'verified', 'failed')),
      gas_savings_percent  NUMERIC(5,2),
      average_latency_ms   INTEGER,
      metadata             JSONB,
      collected_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

