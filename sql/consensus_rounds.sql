-- ========================================================
-- 🔄 Table: consensus_rounds
-- ========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_rounds'
  ) THEN
    CREATE TABLE consensus_rounds (
      round_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      chain_epoch        BIGINT NOT NULL,
      round_number       INT NOT NULL,
      proposer_address   TEXT NOT NULL,
      proposal_hash      TEXT,
      vote_count         INT DEFAULT 0,
      total_validators   INT,
      round_status       TEXT NOT NULL, -- e.g. 'proposed', 'precommit', 'finalized'
      started_at         TIMESTAMPTZ NOT NULL,
      completed_at       TIMESTAMPTZ,
      metadata           JSONB,
      inserted_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_consensus_round_epoch_round ON consensus_rounds(chain_epoch, round_number);
CREATE INDEX IF NOT EXISTS idx_consensus_round_status ON consensus_rounds(round_status);
