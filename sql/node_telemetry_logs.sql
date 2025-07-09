-- ============================================
-- 📊 Table: node_telemetry_logs
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'node_telemetry_logs'
  ) THEN
    CREATE TABLE node_telemetry_logs (
      telemetry_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      node_id           TEXT NOT NULL,
      hostname          TEXT,
      ip_address        TEXT,
      client_version    TEXT,
      network_id        TEXT,
      block_height      BIGINT,
      peers_connected   INT,
      cpu_usage_percent NUMERIC(5,2),
      mem_usage_bytes   BIGINT,
      disk_io_stats     JSONB,
      latency_ms        INT,
      status            TEXT,
      captured_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

