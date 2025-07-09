-- ============================================================
-- 📊 Table: validator_performance_metrics
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'validator_performance_metrics'
  ) THEN
    CREATE TABLE validator_performance_metrics (
      metric_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_address     TEXT NOT NULL,
      epoch_number          BIGINT NOT NULL,
      total_proposed        INT DEFAULT 0,
      total_signed          INT DEFAULT 0,
      missed_signatures     INT DEFAULT 0,
      uptime_percent        NUMERIC(5,2),
      stake_weight          NUMERIC(30,8),
      slashing_events       INT DEFAULT 0,
      rewards_earned        NUMERIC(30,8),
      performance_grade     TEXT, -- e.g. A, B, C, etc.
      metadata              JSONB,
      computed_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_validator_perf_epoch ON validator_performance_metrics(validator_address, epoch_number);
CREATE INDEX IF NOT EXISTS idx_validator_perf_uptime ON validator_performance_metrics(uptime_percent);
