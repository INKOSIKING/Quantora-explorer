-- =============================================================================
-- 🧠 Table: ai_model_version_history
-- 🔍 Tracks all versions, changes, and deployments of AI models in Quantora
-- =============================================================================

CREATE TABLE IF NOT EXISTS ai_model_version_history (
  version_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name              TEXT NOT NULL,
  model_type              TEXT NOT NULL CHECK (model_type IN ('nlp', 'vision', 'predictive', 'reinforcement', 'generative', 'hybrid')),
  version_number          TEXT NOT NULL,
  training_dataset_hash   TEXT,
  training_completed_at   TIMESTAMPTZ,
  deployed_at             TIMESTAMPTZ DEFAULT NOW(),
  deployed_by             TEXT,
  rollback_of_version     TEXT,
  changelog               TEXT,
  performance_metrics     JSONB,
  notes                   TEXT,
  is_active               BOOLEAN DEFAULT TRUE,
  metadata                JSONB,
  UNIQUE (model_name, version_number)
);

-- 📊 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_model_active ON ai_model_version_history(is_active);
CREATE INDEX IF NOT EXISTS idx_ai_model_name_version ON ai_model_version_history(model_name, version_number);
CREATE INDEX IF NOT EXISTS idx_ai_model_type ON ai_model_version_history(model_type);
