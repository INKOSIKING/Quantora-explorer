-- 🤖 AI_ANOMALY_RESOLVER_TRACES — AI-based self-healing incident reports

CREATE TABLE IF NOT EXISTS ai_anomaly_resolver_traces (
  trace_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  anomaly_id          UUID NOT NULL,
  resolver_model      TEXT NOT NULL,
  suggested_action    TEXT NOT NULL,
  confidence_score    NUMERIC(5,4) CHECK (confidence_score BETWEEN 0 AND 1),
  action_taken        BOOLEAN DEFAULT FALSE,
  resolved_at         TIMESTAMPTZ,
  feedback_loop       BOOLEAN DEFAULT TRUE
);

CREATE INDEX IF NOT EXISTS idx_anomaly_trace_ai_model ON ai_anomaly_resolver_traces(resolver_model);
CREATE INDEX IF NOT EXISTS idx_anomaly_trace_confidence ON ai_anomaly_resolver_traces(confidence_score);
