-- ======================================================
-- Table: prediction_engine_metrics
-- Purpose: Logs performance and evaluation data of AI models
-- ======================================================

CREATE TABLE IF NOT EXISTS prediction_engine_metrics (
  metric_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name          VARCHAR(128) NOT NULL,
  version             VARCHAR(64) NOT NULL,
  prediction_type     VARCHAR(64) NOT NULL, -- e.g. market, fraud, tx_intent
  accuracy            NUMERIC CHECK (accuracy BETWEEN 0 AND 1),
  precision           NUMERIC CHECK (precision BETWEEN 0 AND 1),
  recall              NUMERIC CHECK (recall BETWEEN 0 AND 1),
  f1_score            NUMERIC CHECK (f1_score BETWEEN 0 AND 1),
  prediction_volume   BIGINT DEFAULT 0,
  success_rate        NUMERIC CHECK (success_rate BETWEEN 0 AND 1),
  average_latency_ms  INTEGER CHECK (average_latency_ms >= 0),
  evaluated_at        TIMESTAMPTZ DEFAULT NOW(),
  notes               TEXT
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_prediction_metrics_model     ON prediction_engine_metrics(model_name);
CREATE INDEX IF NOT EXISTS idx_prediction_metrics_version   ON prediction_engine_metrics(version);
CREATE INDEX IF NOT EXISTS idx_prediction_metrics_eval_time ON prediction_engine_metrics(evaluated_at DESC);
