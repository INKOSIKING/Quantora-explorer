-- =================================================
-- 🧱 Table: finality_checkpoint_history
-- =================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'finality_checkpoint_history'
  ) THEN
    CREATE TABLE finality_checkpoint_history (
      checkpoint_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      checkpoint_hash    TEXT NOT NULL,
      block_number       BIGINT NOT NULL,
      finalized          BOOLEAN NOT NULL DEFAULT FALSE,
      epoch              BIGINT,
      justification      TEXT,
      validator_count    INT,
      quorum_reached     BOOLEAN DEFAULT FALSE,
      notes              TEXT,
      checkpoint_time    TIMESTAMPTZ NOT NULL,
      recorded_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_checkpoint_hash ON finality_checkpoint_history(checkpoint_hash);
CREATE INDEX IF NOT EXISTS idx_checkpoint_block_number ON finality_checkpoint_history(block_number);
