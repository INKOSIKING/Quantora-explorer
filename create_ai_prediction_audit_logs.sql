-- =======================================================================================
-- 🤖 Table: ai_prediction_audit_logs
-- Description: Logs every AI-driven prediction made on-chain for accountability and audit.
-- =======================================================================================

CREATE TABLE IF NOT EXISTS ai_prediction_audit_logs (
    audit_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_id             UUID NOT NULL,
    prediction_type      TEXT NOT NULL,
    input_features       JSONB NOT NULL,
    predicted_value      TEXT NOT NULL,
    confidence_score     NUMERIC(5,4),
    ground_truth_value   TEXT,
    prediction_outcome   TEXT CHECK (prediction_outcome IN ('correct', 'incorrect', 'pending')),
    latency_ms           INTEGER,
    prediction_time      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    evaluated_at         TIMESTAMPTZ,
    evaluator_notes      TEXT,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_ai_model FOREIGN KEY(model_id) REFERENCES onchain_model_registry(model_id) ON DELETE CASCADE
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_model_id ON ai_prediction_audit_logs(model_id);
CREATE INDEX IF NOT EXISTS idx_ai_predicted_value ON ai_prediction_audit_logs(predicted_value);
CREATE INDEX IF NOT EXISTS idx_ai_prediction_time ON ai_prediction_audit_logs(prediction_time);
