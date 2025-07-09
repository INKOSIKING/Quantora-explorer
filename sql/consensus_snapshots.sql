-- ==================================================
-- 📸 Table: consensus_snapshots
-- ==================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_snapshots'
  ) THEN
    CREATE TABLE consensus_snapshots (
      snapshot_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      epoch_number      BIGINT NOT NULL,
      slot_number       BIGINT,
      validator_set     JSONB NOT NULL,
      proposer_id       TEXT,
      aggregate_votes   JSONB,
      state_root        TEXT NOT NULL,
      finalized         BOOLEAN DEFAULT FALSE,
      justification     TEXT,
      snapshot_hash     TEXT,
      snapshot_size     BIGINT,
      created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- �� Indexes
CREATE INDEX IF NOT EXISTS idx_consensus_epoch ON consensus_snapshots(epoch_number);
CREATE INDEX IF NOT EXISTS idx_consensus_root ON consensus_snapshots(state_root);
