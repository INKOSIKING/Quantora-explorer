-- Table: ai_model_execution_logs
-- Description: Records AI model inference events, inputs, decisions, and outputs for auditing and diagnostics.

CREATE TABLE IF NOT EXISTS ai_model_execution_logs (
    log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_name TEXT NOT NULL,
    model_version TEXT NOT NULL,
    invocation_id UUID NOT NULL,
    execution_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    input_signature JSONB NOT NULL,
    output_result JSONB NOT NULL,
    decision_summary TEXT,
    confidence_score NUMERIC(5,4),
    latency_ms INTEGER,
    triggered_action TEXT,
    source_module TEXT,
    is_anomaly BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_ai_model_name ON ai_model_execution_logs(model_name);
CREATE INDEX IF NOT EXISTS idx_ai_exec_time ON ai_model_execution_logs(execution_timestamp);
CREATE INDEX IF NOT EXISTS idx_ai_anomaly ON ai_model_execution_logs(is_anomaly);

COMMENT ON TABLE ai_model_execution_logs IS 'Logs AI decisions used in blockchain operations such as fraud detection, routing, or optimization.';
COMMENT ON COLUMN ai_model_execution_logs.input_signature IS 'Serialized representation of AI input.';
COMMENT ON COLUMN ai_model_execution_logs.output_result IS 'Full AI output payload.';
