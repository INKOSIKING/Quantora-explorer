-- ============================================================
-- ⚠️ Table: schema_drift_alerts
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'schema_drift_alerts'
  ) THEN
    CREATE TABLE schema_drift_alerts (
      alert_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      detected_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      detected_by      TEXT NOT NULL,
      schema_hash_prev TEXT NOT NULL,
      schema_hash_curr TEXT NOT NULL,
      drift_type       TEXT NOT NULL, -- missing_table, extra_column, type_mismatch, etc.
      details          JSONB NOT NULL,
      severity         TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
      acknowledged     BOOLEAN DEFAULT FALSE,
      resolved_at      TIMESTAMPTZ,
      resolution_notes TEXT
    );
  END IF;
END;
$$;

