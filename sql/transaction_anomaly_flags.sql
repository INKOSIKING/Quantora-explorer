-- ==========================================================
-- 🚨 Table: transaction_anomaly_flags
-- ==========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'transaction_anomaly_flags'
  ) THEN
    CREATE TABLE transaction_anomaly_flags (
      anomaly_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      tx_hash               TEXT NOT NULL,
      block_number          BIGINT,
      sender_address        TEXT,
      receiver_address      TEXT,
      anomaly_type          TEXT NOT NULL,
      severity_level        TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')) NOT NULL,
      description           TEXT,
      detected_by           TEXT,
      flagged_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      resolved              BOOLEAN DEFAULT FALSE,
      resolution_notes      TEXT,
      resolved_at           TIMESTAMPTZ
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_anomaly_tx_hash ON transaction_anomaly_flags(tx_hash);
CREATE INDEX IF NOT EXISTS idx_anomaly_flagged_at ON transaction_anomaly_flags(flagged_at);
CREATE INDEX IF NOT EXISTS idx_anomaly_severity ON transaction_anomaly_flags(severity_level);
