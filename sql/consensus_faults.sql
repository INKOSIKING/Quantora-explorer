-- ============================================
-- 🚨 Table: consensus_faults
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_faults'
  ) THEN
    CREATE TABLE consensus_faults (
      fault_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_id     TEXT NOT NULL,
      fault_type       TEXT NOT NULL, -- e.g., equivocation, double_vote, surround_vote
      block_number     BIGINT NOT NULL,
      block_hash       TEXT,
      details          TEXT,
      penalty_applied  BOOLEAN DEFAULT FALSE,
      fault_score      NUMERIC(5,2),
      occurred_at      TIMESTAMPTZ NOT NULL,
      recorded_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_faults_validator ON consensus_faults(validator_id);
CREATE INDEX IF NOT EXISTS idx_faults_block ON consensus_faults(block_number);
