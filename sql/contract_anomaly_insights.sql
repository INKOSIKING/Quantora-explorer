-- =============================================================================================
-- 🧠 Table: contract_anomaly_insights
-- Description: Stores AI/ML-generated anomaly scores or alerts about smart contract behavior.
-- Captures anything from malicious activity to usage pattern deviations.
-- =============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'contract_anomaly_insights'
  ) THEN
    CREATE TABLE contract_anomaly_insights (
      insight_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address    TEXT NOT NULL,
      anomaly_type        TEXT NOT NULL, -- e.g., 'gas_spike', 'access_violation', 'logic_divergence'
      severity_level      TEXT CHECK (severity_level IN ('low', 'moderate', 'high', 'critical')) NOT NULL,
      anomaly_score       NUMERIC(5,2) CHECK (anomaly_score BETWEEN 0 AND 100),
      detected_by_model   TEXT,
      model_version       TEXT,
      detected_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      description         TEXT,
      tags                TEXT[],
      metadata            JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_contract_anomaly_type ON contract_anomaly_insights(anomaly_type);
CREATE INDEX IF NOT EXISTS idx_contract_address ON contract_anomaly_insights(contract_address);
CREATE INDEX IF NOT EXISTS idx_anomaly_detected_at ON contract_anomaly_insights(detected_at);

