-- ==========================================================
-- 🌐 Table: network_partition_events
-- ==========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'network_partition_events'
  ) THEN
    CREATE TABLE network_partition_events (
      partition_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      detected_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      partition_type       TEXT NOT NULL CHECK (partition_type IN ('fork', 'split', 'latency_isolation', 'reorg')),
      node_count_affected  INT,
      region_affected      TEXT,
      cause_description    TEXT,
      resolution_status    TEXT DEFAULT 'unresolved',
      resolved_at          TIMESTAMPTZ,
      mitigation_steps     TEXT,
      severity_score       NUMERIC(4,2),
      created_by           TEXT
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_partition_detected_at ON network_partition_events(detected_at);
CREATE INDEX IF NOT EXISTS idx_partition_type ON network_partition_events(partition_type);
CREATE INDEX IF NOT EXISTS idx_partition_resolution_status ON network_partition_events(resolution_status);
