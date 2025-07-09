-- ================================================================
-- 🌐 Table: validator_reputation_scores
-- ================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'validator_reputation_scores'
  ) THEN
    CREATE TABLE validator_reputation_scores (
      score_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_address   TEXT NOT NULL,
      uptime_percent      NUMERIC(5,2) CHECK (uptime_percent >= 0 AND uptime_percent <= 100),
      missed_blocks       INTEGER NOT NULL,
      slashing_count      INTEGER NOT NULL,
      participation_rate  NUMERIC(5,2),
      stake_weight        NUMERIC(30, 8),
      score               NUMERIC(6,3) NOT NULL,
      updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_validator_score_address ON validator_reputation_scores(validator_address);
