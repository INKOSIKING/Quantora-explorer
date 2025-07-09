-- ===============================================================================================
-- 🤖 Table: blockchain_prediction_insights
-- Description: Stores AI/ML-based predictions about future blockchain states, such as
-- congestion, gas spikes, anomaly likelihoods, attack risk, etc.
-- ===============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'blockchain_prediction_insights'
  ) THEN
    CREATE TABLE blockchain_prediction_insights (
      prediction_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_version       TEXT NOT NULL,
      prediction_type     TEXT NOT NULL, -- e.g., 'gas_forecast', 'reorg_risk', 'latency_alert'
      target_block_number BIGINT NOT NULL,
      predicted_value     NUMERIC,
      confidence_score    NUMERIC(5,2) CHECK (confidence_score BETWEEN 0 AND 100),
      context_window      JSONB,
      prediction_time     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      tags                TEXT[],
      metadata            JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_prediction_type ON blockchain_prediction_insights(prediction_type);
CREATE INDEX IF NOT EXISTS idx_target_block_number ON blockchain_prediction_insights(target_block_number);
CREATE INDEX IF NOT EXISTS idx_prediction_time ON blockchain_prediction_insights(prediction_time);

