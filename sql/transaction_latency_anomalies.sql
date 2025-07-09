-- ==========================================================
-- 🐢 Table: transaction_latency_anomalies
-- ==========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'transaction_latency_anomalies'
  ) THEN
    CREATE TABLE transaction_latency_anomalies (
      anomaly_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      tx_hash            TEXT NOT NULL,
      observed_latency_ms INT NOT NULL,
      expected_latency_ms INT,
      anomaly_reason     TEXT,
      severity           TEXT CHECK (severity IN ('low', 'moderate', 'high', 'critical')),
      block_number       BIGINT,
      occurred_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      metadata           JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_latency_tx_hash ON transaction_latency_anomalies(tx_hash);
CREATE INDEX IF NOT EXISTS idx_latency_block_number ON transaction_latency_anomalies(block_number);
CREATE INDEX IF NOT EXISTS idx_latency_severity ON transaction_latency_anomalies(severity);
