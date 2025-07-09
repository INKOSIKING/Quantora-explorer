-- =====================================================
-- 🌉 Table: bridge_anomalies
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'bridge_anomalies'
  ) THEN
    CREATE TABLE bridge_anomalies (
      anomaly_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      bridge_name         TEXT NOT NULL,
      source_chain        TEXT NOT NULL,
      destination_chain   TEXT NOT NULL,
      tx_hash             TEXT,
      detected_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      anomaly_type        TEXT NOT NULL,
      anomaly_details     JSONB,
      severity_level      TEXT CHECK (severity_level IN ('low', 'medium', 'high', 'critical')) NOT NULL,
      involved_tokens     TEXT[],
      resolved            BOOLEAN DEFAULT FALSE,
      resolution_notes    TEXT,
      last_updated        TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

