-- =======================================================================
-- 🤖 Table: ai_inference_audit_logs
-- 📘 Tracks AI decisions, scoring, and audit metadata across the platform
-- =======================================================================

CREATE TABLE IF NOT EXISTS ai_inference_audit_logs (
  inference_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name          TEXT NOT NULL,
  model_version       TEXT NOT NULL,
  input_hash          TEXT NOT NULL,  -- hash of input payload
  raw_input           JSONB,
  output              JSONB NOT NULL,
  decision_type       TEXT,           -- e.g., fraud_risk, token_classification
  associated_entity   TEXT,           -- wallet, tx_hash, contract, etc
  confidence_score    NUMERIC(5, 2),
  inference_time_ms   INTEGER,
  triggered_action    TEXT,           -- e.g., alert, quarantine, allow
  status              TEXT NOT NULL DEFAULT 'completed', -- completed, errored, flagged
  error_log           TEXT,
  metadata            JSONB,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📊 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_model ON ai_inference_audit_logs(model_name, model_version);
CREATE INDEX IF NOT EXISTS idx_ai_entity ON ai_inference_audit_logs(associated_entity);
CREATE INDEX IF NOT EXISTS idx_ai_decision ON ai_inference_audit_logs(decision_type);
CREATE INDEX IF NOT EXISTS idx_ai_status ON ai_inference_audit_logs(status);
