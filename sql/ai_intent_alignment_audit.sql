-- 🧠 AI_INTENT_ALIGNMENT_AUDIT — Tracks AI agent behavioral intents & override events

CREATE TABLE IF NOT EXISTS ai_intent_alignment_audit (
  intent_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id             TEXT NOT NULL,
  action_type          TEXT NOT NULL,
  target_contract      VARCHAR(66),
  predicted_outcome    TEXT,
  override_triggered   BOOLEAN DEFAULT FALSE,
  override_reason      TEXT,
  alignment_score      NUMERIC(3,2) CHECK (alignment_score BETWEEN 0.00 AND 1.00),
  audited_at           TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_agent_action ON ai_intent_alignment_audit(agent_id, action_type);
