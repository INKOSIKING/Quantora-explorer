-- ─────────────────────────────────────────────────────────────────────────────
-- 🧠 AI-BASED THREAT CLASSIFIERS — GPT/LLM-based semantic scoring
-- ─────────────────────────────────────────────────────────────────────────────

-- 🧬 Table: ai_threat_classifications
CREATE TABLE IF NOT EXISTS ai_threat_classifications (
  classification_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_id              UUID NOT NULL REFERENCES threat_alerts(alert_id),
  llm_version           TEXT NOT NULL,
  ai_model_used         TEXT NOT NULL,
  classification_label  TEXT NOT NULL,
  threat_vector         TEXT NOT NULL,
  semantic_embedding    REAL[],
  neural_confidence     NUMERIC(5,4) CHECK (neural_confidence BETWEEN 0 AND 1),
  classification_json   JSONB NOT NULL,
  evaluated_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_class_alert ON ai_threat_classifications(alert_id);
CREATE INDEX IF NOT EXISTS idx_ai_class_vector ON ai_threat_classifications(threat_vector);
