-- =====================================================================
-- Table: prediction_engine_stats
-- Purpose: Stores performance, accuracy, and resource usage of ML/AI
-- models powering dApps, trading, fraud detection, and forecasting
-- =====================================================================

CREATE TABLE IF NOT EXISTS prediction_engine_stats (
  stat_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  engine_name          TEXT NOT NULL,
  model_version        TEXT NOT NULL,
  prediction_type      VARCHAR(64) NOT NULL CHECK (prediction_type IN ('market_trend', 'fraud_alert', 'volume_forecast', 'price_target', 'gas_fee_estimate', 'anomaly_detection')),
  accuracy_score       NUMERIC CHECK (accuracy_score >= 0 AND accuracy_score <= 1),
  precision_score      NUMERIC,
  recall_score         NUMERIC,
  f1_score             NUMERIC,
  latency_ms           INTEGER,
  throughput_qps       NUMERIC,
  data_window_hours    INTEGER,
  last_trained_at      TIMESTAMPTZ,
  training_dataset_ref TEXT,
  status               VARCHAR(32) DEFAULT 'active' CHECK (status IN ('active', 'deprecated', 'testing', 'offline')),
  notes                TEXT,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  updated_at           TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_prediction_engine_type
  ON prediction_engine_stats(prediction_type);

CREATE INDEX IF NOT EXISTS idx_prediction_engine_status
  ON prediction_engine_stats(status);

-- === Trigger: updated_at auto-update ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_prediction_engine_stats_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_prediction_engine_stats_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_prediction_engine_stats_updated_at
    BEFORE UPDATE ON prediction_engine_stats
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_prediction_engine_stats_updated_at();
  END IF;
END
$$;
