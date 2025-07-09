-- =====================================================================================
-- Table: prediction_engine_stats
-- Purpose: Logs AI/ML model predictions and their accuracy/performance metrics
-- =====================================================================================

CREATE TABLE IF NOT EXISTS prediction_engine_stats (
  stat_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_name          TEXT NOT NULL,
  prediction_target   TEXT NOT NULL,
  predicted_value     TEXT,
  actual_value        TEXT,
  confidence_score    NUMERIC CHECK (confidence_score >= 0 AND confidence_score <= 1),
  was_accurate        BOOLEAN,
  prediction_error    NUMERIC,
  prediction_type     TEXT CHECK (prediction_type IN ('price', 'volume', 'trend', 'risk', 'anomaly', 'other')),
  context_window      TEXT,
  input_features      JSONB,
  output_vector       JSONB,
  created_by_agent    TEXT,
  created_at          TIMESTAMPTZ DEFAULT NOW(),
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_prediction_engine_model ON prediction_engine_stats(model_name);
CREATE INDEX IF NOT EXISTS idx_prediction_target ON prediction_engine_stats(prediction_target);
CREATE INDEX IF NOT EXISTS idx_prediction_accuracy ON prediction_engine_stats(was_accurate);

-- === Trigger for updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_prediction_engine_stats_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_prediction_engine_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_prediction_engine_stats_updated_at
    BEFORE UPDATE ON prediction_engine_stats
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_prediction_engine_updated_at();
  END IF;
END
$$;
