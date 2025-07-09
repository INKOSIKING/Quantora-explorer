-- ============================================
-- 🧠 Table: consensus_anomalies
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_anomalies'
  ) THEN
    CREATE TABLE consensus_anomalies (
      anomaly_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_number        BIGINT NOT NULL,
      block_hash          TEXT,
      anomaly_type        TEXT NOT NULL,
      description         TEXT,
      affected_validators TEXT[],
      vote_discrepancy    BOOLEAN DEFAULT FALSE,
      fork_detected       BOOLEAN DEFAULT FALSE,
      resolution_status   TEXT CHECK (resolution_status IN ('unresolved', 'investigating', 'resolved')) DEFAULT 'unresolved',
      detected_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_consensus_block_anomaly ON consensus_anomalies(block_number, anomaly_type);
