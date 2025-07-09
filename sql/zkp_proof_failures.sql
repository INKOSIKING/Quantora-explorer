-- ============================================
-- ❌ Table: zkp_proof_failures
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'zkp_proof_failures'
  ) THEN
    CREATE TABLE zkp_proof_failures (
      failure_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      proof_id            UUID,
      proof_type          TEXT NOT NULL,
      failure_reason      TEXT NOT NULL,
      failure_stage       TEXT CHECK (failure_stage IN ('generation', 'verification', 'transmission')),
      error_code          TEXT,
      related_contract    TEXT,
      prover_identity     TEXT,
      verifier_identity   TEXT,
      occurred_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      metadata            JSONB,
      resolved            BOOLEAN DEFAULT FALSE,
      resolution_notes    TEXT,
      resolved_at         TIMESTAMPTZ
    );
  END IF;
END;
$$;

