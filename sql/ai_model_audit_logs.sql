-- ==========================================================================
-- 🧠 Table: ai_model_audit_logs
-- Description: Captures each invocation, output, and context of AI model usage.
-- Ensures traceability, integrity, and regulatory audit compliance.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_model_audit_logs'
  ) THEN
    CREATE TABLE ai_model_audit_logs (
      audit_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_name            TEXT NOT NULL,
      model_version         TEXT,
      invoked_by_address    TEXT,
      input_fingerprint     TEXT,
      output_summary        TEXT,
      confidence_score      NUMERIC(5,4),
      blockchain_context    JSONB,
      contract_address      TEXT,
      transaction_hash      TEXT,
      action_taken          TEXT,
      error_details         TEXT,
      run_time_ms           INTEGER,
      inserted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_model_name ON ai_model_audit_logs(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_invoker_address ON ai_model_audit_logs(invoked_by_address);
CREATE INDEX IF NOT EXISTS idx_ai_contract_address ON ai_model_audit_logs(contract_address);
CREATE INDEX IF NOT EXISTS idx_ai_transaction_hash ON ai_model_audit_logs(transaction_hash);
