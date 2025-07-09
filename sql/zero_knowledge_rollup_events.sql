-- ========================================================================
-- 🔐 Table: zero_knowledge_rollup_events
-- ========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'zero_knowledge_rollup_events'
  ) THEN
    CREATE TABLE zero_knowledge_rollup_events (
      event_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      rollup_batch_id   TEXT NOT NULL,
      rollup_type       TEXT CHECK (rollup_type IN ('zkRollup', 'optimisticRollup', 'validium')) NOT NULL,
      batch_root        TEXT NOT NULL,
      proof_hash        TEXT,
      prover_id         TEXT,
      verification_time_ms INT,
      state_delta       JSONB,
      data_commitment   TEXT,
      included_in_block BIGINT,
      submitted_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      verified          BOOLEAN DEFAULT FALSE,
      extra_metadata    JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_rollup_batch_id ON zero_knowledge_rollup_events(rollup_batch_id);
CREATE INDEX IF NOT EXISTS idx_verified_rollups ON zero_knowledge_rollup_events(verified);
