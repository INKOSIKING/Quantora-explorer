-- ============================================================================
-- 🧠 Table: ai_inference_logs
-- 📘 Logs each AI inference run, usage metadata, and linked model IDs
-- ============================================================================

CREATE TABLE IF NOT EXISTS ai_inference_logs (
  inference_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_id           UUID NOT NULL REFERENCES ai_model_registry(model_id) ON DELETE CASCADE,
  user_address       TEXT NOT NULL,
  request_payload    JSONB NOT NULL,
  response_payload   JSONB,
  inference_hash     TEXT NOT NULL UNIQUE, -- For replay prevention
  latency_ms         INTEGER,
  success            BOOLEAN NOT NULL DEFAULT true,
  error_message      TEXT,
  executed_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  gas_used           BIGINT,
  fee_paid           NUMERIC(20,8),
  signature          TEXT, -- Optional off-chain signature or attestation
  compute_node_id    TEXT -- Optional source of execution
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_inference_model ON ai_inference_logs(model_id);
CREATE INDEX IF NOT EXISTS idx_ai_inference_user ON ai_inference_logs(user_address);
CREATE INDEX IF NOT EXISTS idx_ai_inference_time ON ai_inference_logs(executed_at);
