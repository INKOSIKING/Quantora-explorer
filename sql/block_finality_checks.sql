-- ===========================================
-- 🧬 Table: block_finality_checks
-- ===========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'block_finality_checks'
  ) THEN
    CREATE TABLE block_finality_checks (
      finality_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_hash          TEXT NOT NULL,
      block_number        BIGINT NOT NULL,
      parent_hash         TEXT,
      finalized           BOOLEAN DEFAULT FALSE,
      justification       TEXT,
      validator_set       JSONB,
      finality_score      NUMERIC(5,2),
      reorg_risk_score    NUMERIC(5,2),
      confirmed_at        TIMESTAMPTZ,
      inserted_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_finality_block_hash ON block_finality_checks(block_hash);
CREATE INDEX IF NOT EXISTS idx_finality_block_number ON block_finality_checks(block_number);
