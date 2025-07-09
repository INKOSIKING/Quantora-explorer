-- Generating SQL for table: prediction_engine_stats
-- Table: prediction_engine_stats
-- Purpose: Stores historical performance and metadata of on-chain/off-chain predictive AI models

CREATE TABLE IF NOT EXISTS prediction_engine_stats (
    stat_id UUID PRIMARY KEY,
    engine_id TEXT NOT NULL,
    prediction_type TEXT NOT NULL, -- e.g., price_forecast, fraud_detection, tx_outcome
    model_version TEXT,
    execution_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    input_features JSONB,
    prediction_output JSONB,
    prediction_confidence NUMERIC(5,2),
    outcome_verified BOOLEAN DEFAULT FALSE,
    actual_outcome JSONB,
    accuracy_score NUMERIC(5,2),
    precision_score NUMERIC(5,2),
    recall_score NUMERIC(5,2),
    model_runtime_ms INTEGER,
    engine_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_prediction_engine_type ON prediction_engine_stats(prediction_type);
CREATE INDEX IF NOT EXISTS idx_prediction_engine_exec_time ON prediction_engine_stats(execution_time);
