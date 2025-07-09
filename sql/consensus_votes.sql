-- ===========================================
-- 🗳️ Table: consensus_votes
-- ===========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_votes'
  ) THEN
    CREATE TABLE consensus_votes (
      vote_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      validator_id      TEXT NOT NULL,
      epoch_number      BIGINT NOT NULL,
      slot_number       BIGINT,
      voted_block_hash  TEXT NOT NULL,
      target_root       TEXT,
      source_epoch      BIGINT,
      target_epoch      BIGINT,
      vote_weight       NUMERIC(30,0),
      signature         TEXT,
      was_included      BOOLEAN DEFAULT FALSE,
      inclusion_delay   INT,
      recorded_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_votes_validator_epoch ON consensus_votes(validator_id, epoch_number);
CREATE INDEX IF NOT EXISTS idx_votes_block_hash ON consensus_votes(voted_block_hash);
