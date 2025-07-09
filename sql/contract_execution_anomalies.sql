-- ==========================================================================
-- ⚠️ Table: contract_execution_anomalies
-- Description: Tracks abnormal contract behaviors, potential exploits, or execution bugs.
-- Supports security analytics, alerting, and automated mitigation tooling.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'contract_execution_anomalies'
  ) THEN
    CREATE TABLE contract_execution_anomalies (
      anomaly_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address      TEXT NOT NULL,
      transaction_hash      TEXT NOT NULL,
      block_number          BIGINT NOT NULL,
      anomaly_type          TEXT NOT NULL,
      severity_level        TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')) NOT NULL,
      detected_by           TEXT,
      detection_engine      TEXT,
      anomaly_details       JSONB,
      mitigated             BOOLEAN DEFAULT FALSE,
      inserted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      updated_at            TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_anomalies_contract_address ON contract_execution_anomalies(contract_address);
CREATE INDEX IF NOT EXISTS idx_anomalies_transaction_hash ON contract_execution_anomalies(transaction_hash);
CREATE INDEX IF NOT EXISTS idx_anomalies_block_number ON contract_execution_anomalies(block_number);
CREATE INDEX IF NOT EXISTS idx_anomalies_type ON contract_execution_anomalies(anomaly_type);
