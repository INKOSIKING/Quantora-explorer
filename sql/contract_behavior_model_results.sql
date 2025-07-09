-- ===========================================================================================
-- 🧠 Table: contract_behavior_model_results
-- Description: Stores AI/ML inferences about smart contract behavior, risk, and anomalies.
-- Used for fraud detection, gas optimization suggestions, and abnormal usage alerts.
-- ===========================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'contract_behavior_model_results'
  ) THEN
    CREATE TABLE contract_behavior_model_results (
      result_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address       TEXT NOT NULL,
      model_name             TEXT NOT NULL,
      model_version          TEXT,
      prediction_type        TEXT NOT NULL, -- e.g., 'anomaly', 'risk_score', 'function_usage_classification'
      prediction_value       JSONB NOT NULL,
      confidence_score       NUMERIC(5,4),
      flagged_as_risky       BOOLEAN DEFAULT FALSE,
      explanation            TEXT,
      analyzed_block_number  BIGINT,
      analyzed_at            TIMESTAMPTZ DEFAULT NOW(),
      inserted_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_contract_model_prediction ON contract_behavior_model_results(contract_address, model_name);
CREATE INDEX IF NOT EXISTS idx_prediction_type_block ON contract_behavior_model_results(prediction_type, analyzed_block_number);
