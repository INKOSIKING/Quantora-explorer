-- ===============================================================
-- 📜 Table: ai_decision_audit_logs
-- Description: Captures all AI-based decisions with justification,
-- metadata, and human overrides for full transparency.
-- ===============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_decision_audit_logs'
  ) THEN
    CREATE TABLE ai_decision_audit_logs (
      log_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_id             UUID REFERENCES ai_model_registry(model_id) ON DELETE SET NULL,
      decision_context     TEXT NOT NULL,
      input_summary        TEXT,
      output_decision      TEXT NOT NULL,
      confidence_score     NUMERIC(5, 2),
      human_override       BOOLEAN DEFAULT FALSE,
      override_reason      TEXT,
      decision_hash        TEXT UNIQUE NOT NULL,
      decision_timestamp   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_decision_model_id ON ai_decision_audit_logs(model_id);
CREATE INDEX IF NOT EXISTS idx_ai_decision_context ON ai_decision_audit_logs(decision_context);
CREATE INDEX IF NOT EXISTS idx_ai_decision_timestamp ON ai_decision_audit_logs(decision_timestamp);
