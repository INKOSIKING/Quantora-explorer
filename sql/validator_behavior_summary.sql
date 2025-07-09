-- =====================================================
-- 🧾 Table: validator_behavior_summary
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'validator_behavior_summary'
  ) THEN
    CREATE TABLE validator_behavior_summary (
      summary_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_address     TEXT NOT NULL,
      epoch_number          BIGINT NOT NULL,
      total_blocks_proposed INT NOT NULL,
      missed_blocks         INT NOT NULL,
      double_signs_detected INT DEFAULT 0,
      uptime_percent        NUMERIC(5,2) NOT NULL CHECK (uptime_percent BETWEEN 0 AND 100),
      slashed               BOOLEAN DEFAULT FALSE,
      behavior_score        NUMERIC(5,2),
      notes                 TEXT,
      recorded_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

