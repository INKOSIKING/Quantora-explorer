-- ========================================================================
-- 📡 Table: ai_oracle_responses
-- 🧠 Stores AI-based oracle responses used for on-chain decision making
-- ========================================================================

CREATE TABLE IF NOT EXISTS ai_oracle_responses (
  response_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  oracle_request_id   UUID NOT NULL,
  ai_model_used       TEXT NOT NULL,
  model_version       TEXT NOT NULL,
  source_context      TEXT NOT NULL, -- e.g., token_valuation, weather_feed
  query_payload       TEXT NOT NULL,
  ai_response         TEXT NOT NULL,
  response_hash       TEXT NOT NULL,
  used_in_block       BIGINT,
  confidence_level    NUMERIC(5,4),
  signed_by_validator BOOLEAN DEFAULT FALSE,
  failure_reason      TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🧩 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_oracle_context ON ai_oracle_responses(source_context);
CREATE INDEX IF NOT EXISTS idx_ai_oracle_request ON ai_oracle_responses(oracle_request_id);
CREATE INDEX IF NOT EXISTS idx_ai_oracle_block ON ai_oracle_responses(used_in_block);
