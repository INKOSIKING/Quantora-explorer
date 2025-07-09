-- =============================================================================
-- Table: ai_oracle_explanations
-- Purpose: Stores logs of reasoning and output from AI-integrated smart oracles
-- =============================================================================

CREATE TABLE IF NOT EXISTS ai_oracle_explanations (
  explanation_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  oracle_id            UUID NOT NULL,
  request_context      TEXT NOT NULL,
  model_name           VARCHAR(128) NOT NULL,
  input_hash           VARCHAR(66),
  ai_output_summary    TEXT,
  full_output_json     JSONB,
  confidence_score     NUMERIC CHECK (confidence_score >= 0 AND confidence_score <= 1),
  reasoning_trace      TEXT,
  related_decision_tx  VARCHAR(66),
  verified             BOOLEAN DEFAULT FALSE,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_ai_oracle_model_name ON ai_oracle_explanations(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_oracle_verified ON ai_oracle_explanations(verified);
CREATE INDEX IF NOT EXISTS idx_ai_oracle_tx ON ai_oracle_explanations(related_decision_tx);

-- === Constraints ===
ALTER TABLE ai_oracle_explanations
  ADD CONSTRAINT chk_input_hash_format
    CHECK (input_hash IS NULL OR input_hash ~ '^0x[a-fA-F0-9]{64}$');

ALTER TABLE ai_oracle_explanations
  ADD CONSTRAINT chk_tx_hash_format
    CHECK (related_decision_tx IS NULL OR related_decision_tx ~ '^0x[a-fA-F0-9]{64}$');
