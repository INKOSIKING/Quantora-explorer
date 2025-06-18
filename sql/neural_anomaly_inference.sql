-- ─────────────────────────────────────────────────────────────────────────────
-- 🧠 NEURAL_ANOMALY_INFERENCE — LSTM/Transformer-driven outlier detection
-- ─────────────────────────────────────────────────────────────────────────────

-- �� Table: neural_anomaly_predictions
CREATE TABLE IF NOT EXISTS neural_anomaly_predictions (
  inference_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  node_id            TEXT NOT NULL,
  model_version      TEXT NOT NULL,
  predicted_behavior JSONB NOT NULL,
  observed_behavior  JSONB NOT NULL,
  anomaly_score      NUMERIC(5,4) CHECK (anomaly_score BETWEEN 0 AND 1),
  severity_level     TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')),
  inference_time     TIMESTAMPTZ DEFAULT NOW()
);

-- 🧠 Table: anomaly_alerts
CREATE TABLE IF NOT EXISTS anomaly_alerts (
  alert_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  node_id            TEXT NOT NULL,
  triggered_by       UUID NOT NULL REFERENCES neural_anomaly_predictions(inference_id),
  alert_type         TEXT,
  message            TEXT,
  resolved           BOOLEAN DEFAULT FALSE,
  created_at         TIMESTAMPTZ DEFAULT NOW(),
  resolved_at        TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_anomaly_node ON neural_anomaly_predictions(node_id);
CREATE INDEX IF NOT EXISTS idx_alert_trigger ON anomaly_alerts(triggered_by);
