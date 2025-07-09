-- ===============================================================
-- 🧠 Table: ai_tx_validation_results
-- Description: Stores AI-inferred evaluations of transactions for
-- risk, compliance, fraud detection, tagging, or behavior prediction.
-- ===============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_tx_validation_results'
  ) THEN
    CREATE TABLE ai_tx_validation_results (
      result_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      tx_hash               TEXT NOT NULL,
      block_number          BIGINT,
      model_name            TEXT NOT NULL,
      model_version         TEXT NOT NULL,
      features_used         JSONB,
      classification_label  TEXT,
      probability_score     NUMERIC(5, 2),
      risk_level            TEXT CHECK (risk_level IN ('low', 'medium', 'high', 'critical')),
      explanation           TEXT,
      reviewed              BOOLEAN DEFAULT FALSE,
      flagged               BOOLEAN DEFAULT FALSE,
      inserted_at           TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_tx_validation_tx_hash ON ai_tx_validation_results(tx_hash);
CREATE INDEX IF NOT EXISTS idx_ai_tx_validation_model ON ai_tx_validation_results(model_name, model_version);
CREATE INDEX IF NOT EXISTS idx_ai_tx_validation_risk ON ai_tx_validation_results(risk_level);
