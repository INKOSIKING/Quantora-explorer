-- ==========================================
-- 🧾 Table: zk_verifier_registry
-- ==========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'zk_verifier_registry'
  ) THEN
    CREATE TABLE zk_verifier_registry (
      verifier_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      verifier_name         TEXT NOT NULL,
      protocol              TEXT NOT NULL,        -- e.g., Groth16, Plonk, Marlin
      circuit_hash          TEXT NOT NULL,
      version               TEXT,
      deployed_at           TIMESTAMPTZ NOT NULL,
      expiration_at         TIMESTAMPTZ,
      on_chain              BOOLEAN DEFAULT FALSE,
      status                TEXT CHECK (status IN ('active', 'deprecated', 'revoked')) NOT NULL DEFAULT 'active',
      metadata              JSONB,
      created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_verifier_name ON zk_verifier_registry(verifier_name);
CREATE INDEX IF NOT EXISTS idx_verifier_protocol ON zk_verifier_registry(protocol);
CREATE INDEX IF NOT EXISTS idx_verifier_status ON zk_verifier_registry(status);
