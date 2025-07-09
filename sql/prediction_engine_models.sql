-- ====================================================================================
-- Table: prediction_engine_models
-- Purpose: Stores metadata, configurations, and metrics for AI/ML predictive models
-- ====================================================================================

CREATE TABLE IF NOT EXISTS prediction_engine_models (
  model_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name       TEXT NOT NULL,
  model_type       TEXT NOT NULL CHECK (model_type IN ('regression', 'classification', 'transformer', 'lstm', 'custom')),
  input_features   TEXT[],                      -- e.g., ['gas_price', 'block_time']
  target_variable  TEXT NOT NULL,               -- e.g., 'price', 'volume', 'tx_count'
  training_data_ref TEXT,                       -- URI or dataset pointer
  accuracy_score   NUMERIC,                     -- Optional scoring metric
  status           TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'deprecated', 'testing')),
  deployed_at      TIMESTAMPTZ,
  last_updated     TIMESTAMPTZ DEFAULT NOW(),
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_model_type_status
  ON prediction_engine_models(model_type, status);

-- === Unique Constraint ===
CREATE UNIQUE INDEX IF NOT EXISTS uq_model_name
  ON prediction_engine_models(model_name);
