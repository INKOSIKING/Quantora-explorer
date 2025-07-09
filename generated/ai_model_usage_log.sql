-- =====================================================================
-- 🤖 Table: ai_model_usage_log
-- 📡 Records AI model invocations, responses, gas, and result metadata
-- =====================================================================

CREATE TABLE IF NOT EXISTS ai_model_usage_log (
  usage_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name           TEXT NOT NULL,
  model_version        TEXT,
  request_payload      JSONB NOT NULL,
  response_payload     JSONB,
  caller_wallet        TEXT NOT NULL,
  contract_address     TEXT,
  function_invoked     TEXT,
  tx_hash              TEXT,
  block_number         BIGINT,
  gas_used             NUMERIC(30,10),
  inference_time_ms    INTEGER,
  status               TEXT NOT NULL DEFAULT 'pending', -- success, error, timeout, pending
  error_message        TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_usage_model ON ai_model_usage_log(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_usage_status ON ai_model_usage_log(status);
CREATE INDEX IF NOT EXISTS idx_ai_usage_wallet ON ai_model_usage_log(caller_wallet);
CREATE INDEX IF NOT EXISTS idx_ai_usage_tx ON ai_model_usage_log(tx_hash);
