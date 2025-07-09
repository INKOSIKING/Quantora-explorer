-- ========================================================================
-- ❌ Table: block_verification_failures
-- ========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'block_verification_failures'
  ) THEN
    CREATE TABLE block_verification_failures (
      failure_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_number       BIGINT NOT NULL,
      block_hash         TEXT NOT NULL,
      parent_hash        TEXT,
      reason             TEXT NOT NULL,
      validator_id       TEXT,
      severity           TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) NOT NULL DEFAULT 'medium',
      recovery_attempted BOOLEAN DEFAULT FALSE,
      recovery_notes     TEXT,
      detected_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      resolved           BOOLEAN DEFAULT FALSE,
      resolution_details TEXT
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_block_verification_block_number ON block_verification_failures(block_number);
CREATE INDEX IF NOT EXISTS idx_block_verification_severity ON block_verification_failures(severity);
