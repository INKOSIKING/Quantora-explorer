-- ================================================================
-- 🧠 Table: ai_model_registry
-- Description: Tracks registered AI models used within the system
-- including source, versioning, usage policy, and trustworthiness.
-- ================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_model_registry'
  ) THEN
    CREATE TABLE ai_model_registry (
      model_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_name           TEXT NOT NULL,
      model_version        TEXT NOT NULL,
      provider             TEXT,
      model_hash           TEXT NOT NULL,
      usage_scope          TEXT, -- indexing, ranking, fraud, etc
      is_open_source       BOOLEAN DEFAULT FALSE,
      license              TEXT,
      integrity_score      NUMERIC(4, 2),
      trust_level          TEXT CHECK (trust_level IN ('trusted', 'experimental', 'sandbox', 'unverified')),
      deployed_on_block    BIGINT,
      deployed_by          TEXT,
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_model_name ON ai_model_registry(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_model_hash ON ai_model_registry(model_hash);
CREATE INDEX IF NOT EXISTS idx_ai_model_trust ON ai_model_registry(trust_level);
