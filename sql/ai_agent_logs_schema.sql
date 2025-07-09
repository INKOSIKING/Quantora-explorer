-- ==================================================
-- Table: ai_agent_logs
-- Purpose: Tracks logs and decisions made by AI agents
-- ==================================================

CREATE TABLE IF NOT EXISTS ai_agent_logs (
  log_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id           UUID NOT NULL,
  session_id         UUID,
  behavior_type      VARCHAR(64) NOT NULL,
  action_taken       TEXT NOT NULL,
  input_context      JSONB,
  output_context     JSONB,
  confidence_score   NUMERIC CHECK (confidence_score >= 0 AND confidence_score <= 1),
  processing_time_ms INTEGER,
  system_load        JSONB,
  decision_trace     TEXT,
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_ai_agent_logs_agent_id    ON ai_agent_logs(agent_id);
CREATE INDEX IF NOT EXISTS idx_ai_agent_logs_session_id  ON ai_agent_logs(session_id);
CREATE INDEX IF NOT EXISTS idx_ai_agent_logs_behavior    ON ai_agent_logs(behavior_type);
CREATE INDEX IF NOT EXISTS idx_ai_agent_logs_created_at  ON ai_agent_logs(created_at DESC);
