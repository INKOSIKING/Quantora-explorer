-- ========================================================================
-- 🧠 Table: ai_model_activity_log
-- 🗃️ Logs all AI model executions, contexts, prompts, and results
-- ========================================================================

CREATE TABLE IF NOT EXISTS ai_model_activity_log (
  activity_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name          TEXT NOT NULL,
  model_version       TEXT NOT NULL,
  invoked_by          TEXT NOT NULL, -- address or internal system
  context_type        TEXT NOT NULL, -- transaction, token, governance, etc.
  context_id          TEXT NOT NULL, -- e.g., tx hash or proposal ID
  input_prompt        TEXT NOT NULL,
  output_summary      TEXT,
  confidence_score    NUMERIC(5,4), -- Optional scoring from AI
  execution_time_ms   INT,
  result_metadata     JSONB,
  failure_reason      TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- �� Indexes
CREATE INDEX IF NOT EXISTS idx_ai_model_name ON ai_model_activity_log(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_context ON ai_model_activity_log(context_type, context_id);
CREATE INDEX IF NOT EXISTS idx_ai_invoker ON ai_model_activity_log(invoked_by);
