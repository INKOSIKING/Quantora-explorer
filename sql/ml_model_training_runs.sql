-- ===========================================================================================
-- 🧠 Table: ml_model_training_runs
-- Description: Stores metadata for each ML/AI model training attempt (for fraud, trading, etc.)
-- Useful for debugging, governance audits, reproducibility, retraining, and metrics comparison.
-- ===========================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ml_model_training_runs'
  ) THEN
    CREATE TABLE ml_model_training_runs (
      run_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_name           TEXT NOT NULL,
      version              TEXT,
      training_dataset     TEXT NOT NULL,
      training_start_time  TIMESTAMPTZ,
      training_end_time    TIMESTAMPTZ,
      training_duration_ms BIGINT,
      training_accuracy    NUMERIC(5, 4),
      validation_accuracy  NUMERIC(5, 4),
      loss_function        TEXT,
      optimizer            TEXT,
      hyperparameters      JSONB,
      training_notes       TEXT,
      model_uri            TEXT,
      initiated_by         TEXT,
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ml_model_name_version ON ml_model_training_runs(model_name, version);
CREATE INDEX IF NOT EXISTS idx_ml_run_start_time ON ml_model_training_runs(training_start_time);

