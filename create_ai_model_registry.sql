-- ========================================================================================
-- 🤖 Table: ai_model_registry
-- Description: Registry of AI/ML models used in blockchain analytics, risk scoring, etc.
-- ========================================================================================

CREATE TABLE IF NOT EXISTS ai_model_registry (
    model_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_name            TEXT NOT NULL,
    model_version         TEXT NOT NULL,
    task_type             TEXT NOT NULL, -- e.g., fraud_detection, price_prediction, etc.
    input_schema          JSONB,
    output_schema         JSONB,
    deployed              BOOLEAN DEFAULT FALSE,
    endpoint_url          TEXT,
    checksum              TEXT,
    activated_by_user     TEXT,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ
);

-- 🔍 Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_model_name_version ON ai_model_registry(model_name, model_version);
CREATE INDEX IF NOT EXISTS idx_model_task_type ON ai_model_registry(task_type);
CREATE INDEX IF NOT EXISTS idx_model_deployed ON ai_model_registry(deployed);
