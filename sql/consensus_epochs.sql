-- =============================================
-- ⛓️ Table: consensus_epochs
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_epochs'
  ) THEN
    CREATE TABLE consensus_epochs (
      epoch_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      epoch_number       BIGINT NOT NULL,
      consensus_type     TEXT NOT NULL,
      started_at         TIMESTAMPTZ NOT NULL,
      ended_at           TIMESTAMPTZ,
      leader_validator   TEXT,
      total_participants INT,
      quorum_achieved    BOOLEAN DEFAULT FALSE,
      finalized_block    TEXT,
      justification      TEXT,
      epoch_metadata     JSONB,
      created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_consensus_epoch_number ON consensus_epochs(epoch_number);
CREATE INDEX IF NOT EXISTS idx_consensus_leader ON consensus_epochs(leader_validator);
