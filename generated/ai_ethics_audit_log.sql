-- =============================================================================
-- ⚖️ Table: ai_ethics_audit_log
-- 🧩 Tracks ethical audits and manual overrides for AI systems
-- =============================================================================

CREATE TABLE IF NOT EXISTS ai_ethics_audit_log (
  audit_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id              TEXT NOT NULL,
  evaluated_signal_id   UUID REFERENCES ai_agent_signals(signal_id) ON DELETE CASCADE,
  audit_timestamp       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  risk_flagged          BOOLEAN DEFAULT FALSE,
  human_override        BOOLEAN DEFAULT FALSE,
  override_reason       TEXT,
  audit_notes           TEXT,
  bias_category         TEXT CHECK (
    bias_category IS NULL OR bias_category IN (
      'data_bias', 'algorithmic_bias', 'training_bias',
      'unintended_outcome', 'explainability_gap', 'lack_of_consent'
    )
  ),
  mitigation_action     TEXT,
  reviewed_by           TEXT,
  metadata              JSONB
);

-- 📊 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_ethics_agent ON ai_ethics_audit_log(agent_id);
CREATE INDEX IF NOT EXISTS idx_ai_ethics_signal ON ai_ethics_audit_log(evaluated_signal_id);
CREATE INDEX IF NOT EXISTS idx_ai_ethics_bias ON ai_ethics_audit_log(bias_category);
