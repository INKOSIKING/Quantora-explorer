-- =====================================================
-- 🌐 Table: network_latency_metrics
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'network_latency_metrics'
  ) THEN
    CREATE TABLE network_latency_metrics (
      latency_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      source_node      TEXT NOT NULL,
      target_node      TEXT NOT NULL,
      latency_ms       INTEGER NOT NULL,
      packet_loss      NUMERIC(5,2),
      jitter_ms        INTEGER,
      measured_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      region           TEXT,
      protocol         TEXT,
      measurement_tool TEXT
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_latency_source_target ON network_latency_metrics(source_node, target_node);
CREATE INDEX IF NOT EXISTS idx_latency_measured_at ON network_latency_metrics(measured_at);
