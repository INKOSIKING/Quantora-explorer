-- =============================================
-- 📡 Table: block_sync_telemetry
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'block_sync_telemetry'
  ) THEN
    CREATE TABLE block_sync_telemetry (
      sync_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      node_id             TEXT NOT NULL,
      block_number        BIGINT NOT NULL,
      block_hash          TEXT,
      peer_id             TEXT,
      received_at         TIMESTAMPTZ NOT NULL,
      processed_at        TIMESTAMPTZ,
      lag_ms              BIGINT,
      sync_status         TEXT CHECK (sync_status IN ('pending', 'success', 'failed', 'delayed')) NOT NULL,
      failure_reason      TEXT,
      connection_quality  TEXT CHECK (connection_quality IN ('good', 'moderate', 'poor')) DEFAULT 'good',
      notes               TEXT,
      created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_sync_block_number ON block_sync_telemetry(block_number);
CREATE INDEX IF NOT EXISTS idx_sync_node_status ON block_sync_telemetry(node_id, sync_status);
CREATE INDEX IF NOT EXISTS idx_sync_received_at ON block_sync_telemetry(received_at);
