-- ==========================================================
-- 🔐 Table: zero_knowledge_verification_audit
-- ==========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'zero_knowledge_verification_audit'
  ) THEN
    CREATE TABLE zero_knowledge_verification_audit (
      audit_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      proof_hash         TEXT NOT NULL,
      proof_type         TEXT NOT NULL,
      prover_id          TEXT NOT NULL,
      verifier_id        TEXT,
      circuit_id         TEXT,
      input_commitments  JSONB,
      output_commitments JSONB,
      verified           BOOLEAN NOT NULL DEFAULT FALSE,
      gas_used           BIGINT,
      latency_ms         INTEGER,
      errors             TEXT,
      verified_at        TIMESTAMPTZ,
      created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_zkp_audit_proof_hash ON zero_knowledge_verification_audit(proof_hash);
CREATE INDEX IF NOT EXISTS idx_zkp_audit_prover_id ON zero_knowledge_verification_audit(prover_id);
CREATE INDEX IF NOT EXISTS idx_zkp_audit_verified ON zero_knowledge_verification_audit(verified);
