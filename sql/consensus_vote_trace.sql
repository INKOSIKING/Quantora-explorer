-- ========================================================================
-- 🗳️ Table: consensus_vote_trace
-- ========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_vote_trace'
  ) THEN
    CREATE TABLE consensus_vote_trace (
      vote_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_number     BIGINT NOT NULL,
      round_number     INT NOT NULL,
      step             TEXT NOT NULL CHECK (step IN ('propose', 'prevote', 'precommit')),
      validator_id     TEXT NOT NULL,
      vote_hash        TEXT NOT NULL,
      decision         BOOLEAN NOT NULL,
      signature        TEXT,
      voting_power     NUMERIC(20, 5),
      latency_ms       INT,
      received_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      inserted_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_vote_trace_block_round ON consensus_vote_trace(block_number, round_number);
CREATE INDEX IF NOT EXISTS idx_vote_trace_validator ON consensus_vote_trace(validator_id);
