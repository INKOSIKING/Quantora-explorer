-- ======================================================================================
-- Table: model_inference_logs
-- Purpose: Logs AI/ML model inference requests and outputs for transparency & auditing
-- ======================================================================================

CREATE TABLE IF NOT EXISTS model_inference_logs (
  inference_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name        TEXT NOT NULL,
  model_version     TEXT,
  input_payload     JSONB NOT NULL,                    -- Input features/data
  output_result     JSONB,                             -- Model result
  confidence_score  NUMERIC,                           -- Optional probability/confidence
  source_agent      UUID,                              -- Optional reference to autonomous agent
  triggered_by      TEXT,                              -- e.g., user_tx, oracle_event, scheduler
  status            TEXT CHECK (status IN ('success', 'failure', 'timeout')),
  error_message     TEXT,
  executed_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_model_inference_logs_model
  ON model_inference_logs(model_name);

CREATE INDEX IF NOT EXISTS idx_model_inference_logs_status
  ON model_inference_logs(status);

CREATE INDEX IF NOT EXISTS idx_model_inference_logs_agent
  ON model_inference_logs(source_agent);
