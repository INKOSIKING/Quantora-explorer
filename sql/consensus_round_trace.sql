-- ===============================================
-- 🔁 Table: consensus_round_trace
-- ===============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_round_trace'
  ) THEN
    CREATE TABLE consensus_round_trace (
      trace_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      round_number        BIGINT NOT NULL,
      phase               TEXT NOT NULL,  -- e.g., 'PREPARE', 'PRECOMMIT', 'COMMIT', 'FINALIZE'
      block_hash          TEXT,
      proposer_id         TEXT,
      started_at          TIMESTAMPTZ NOT NULL,
      ended_at            TIMESTAMPTZ,
      timeout_ms          INT,
      votes_received      INT,
      quorum_achieved     BOOLEAN DEFAULT FALSE,
      fault_tolerance_estimate NUMERIC(5,2),
      metadata            JSONB,
      created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_consensus_round ON consensus_round_trace(round_number);
CREATE INDEX IF NOT EXISTS idx_consensus_phase ON consensus_round_trace(phase);
CREATE INDEX IF NOT EXISTS idx_consensus_block_hash ON consensus_round_trace(block_hash);
