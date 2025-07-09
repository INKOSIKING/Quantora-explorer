-- ==================================================
-- 🛠️ Table: state_verification_failures
-- ==================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'state_verification_failures'
  ) THEN
    CREATE TABLE state_verification_failures (
      failure_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_number       BIGINT NOT NULL,
      expected_state_hash TEXT NOT NULL,
      actual_state_hash   TEXT NOT NULL,
      mismatch_type       TEXT NOT NULL, -- e.g., "storage_root", "code_hash", "nonce"
      detected_by         TEXT NOT NULL, -- e.g., client name, verifier module
      severity_level      TEXT NOT NULL, -- e.g., "low", "medium", "high", "critical"
      remediation_status  TEXT DEFAULT 'unresolved', -- "resolved", "ignored"
      affected_contracts  JSONB,
      comments            TEXT,
      detected_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_state_verification_block_number ON state_verification_failures(block_number);
CREATE INDEX IF NOT EXISTS idx_state_verification_mismatch_type ON state_verification_failures(mismatch_type);
CREATE INDEX IF NOT EXISTS idx_state_verification_status ON state_verification_failures(remediation_status);
