-- ===========================================
-- �� Table: network_latency_records
-- ===========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'network_latency_records'
  ) THEN
    CREATE TABLE network_latency_records (
      latency_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      peer_id          TEXT NOT NULL,
      region           TEXT,
      ip_address       INET,
      latency_ms       INT NOT NULL,
      packet_loss_pct  NUMERIC(5,2),
      recorded_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      connection_type  TEXT CHECK (connection_type IN ('gRPC', 'REST', 'WebSocket', 'Unknown')) DEFAULT 'Unknown'
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_latency_peer_id ON network_latency_records(peer_id);
CREATE INDEX IF NOT EXISTS idx_latency_recorded_at ON network_latency_records(recorded_at);
