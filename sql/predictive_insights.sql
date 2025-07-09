-- ============================================================================================
-- 🧠 Table: predictive_insights
-- Description: Stores AI/ML-based predictive signals about token prices, flows, and risks.
-- Used for market insights, automated alerting, and strategic execution logic.
-- ============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'predictive_insights'
  ) THEN
    CREATE TABLE predictive_insights (
      insight_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_id             UUID REFERENCES ml_models(model_id),
      prediction_scope     TEXT NOT NULL,            -- e.g. 'token_price', 'gas_fee_trend'
      target_entity        TEXT NOT NULL,            -- e.g. token_address, contract_id
      target_entity_type   TEXT NOT NULL,            -- e.g. 'token', 'wallet', 'contract'
      predicted_value      NUMERIC(30, 10),
      prediction_confidence NUMERIC(5, 4),
      predicted_at         TIMESTAMPTZ NOT NULL,
      prediction_horizon   INTERVAL,                 -- how far into the future this applies
      metadata             JSONB,
      created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_predictive_target ON predictive_insights(target_entity);
CREATE INDEX IF NOT EXISTS idx_predictive_scope ON predictive_insights(prediction_scope);
CREATE INDEX IF NOT EXISTS idx_predictive_predicted_at ON predictive_insights(predicted_at);

