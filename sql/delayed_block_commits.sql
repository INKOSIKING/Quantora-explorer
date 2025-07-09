-- ============================================
-- ⏳ Table: delayed_block_commits
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'delayed_block_commits'
  ) THEN
    CREATE TABLE delayed_block_commits (
      delay_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_number       BIGINT NOT NULL,
      block_hash         TEXT,
      expected_commit_at TIMESTAMPTZ NOT NULL,
      actual_commit_at   TIMESTAMPTZ,
      delay_ms           BIGINT,
      validator_id       TEXT,
      cause              TEXT,
      severity           TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) DEFAULT 'low',
      created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_commit_delay_block ON delayed_block_commits(block_number);
CREATE INDEX IF NOT EXISTS idx_commit_delay_validator ON delayed_block_commits(validator_id);
