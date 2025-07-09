-- ==========================================================================
-- Table: ai_behavior_explanations
-- Purpose: Captures structured explanations from AI agents for actions taken
-- ==========================================================================

CREATE TABLE IF NOT EXISTS ai_behavior_explanations (
  explanation_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id           UUID NOT NULL,
  decision_context   TEXT NOT NULL,
  action_taken       TEXT NOT NULL,
  reasoning_trace    JSONB NOT NULL,
  ai_model_version   VARCHAR(128),
  confidence_level   NUMERIC CHECK (confidence_level >= 0 AND confidence_level <= 1),
  triggered_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  validated_by_human BOOLEAN DEFAULT FALSE,
  risk_score         NUMERIC DEFAULT 0 CHECK (risk_score >= 0),
  audit_tag          TEXT
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_ai_agent_triggered_at ON ai_behavior_explanations(agent_id, triggered_at);
CREATE INDEX IF NOT EXISTS idx_ai_confidence_risk     ON ai_behavior_explanations(confidence_level, risk_score);
CREATE INDEX IF NOT EXISTS idx_ai_model_version       ON ai_behavior_explanations(ai_model_version);
