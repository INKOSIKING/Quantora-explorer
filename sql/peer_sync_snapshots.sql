-- =====================================================
-- 🌐 Table: peer_sync_snapshots
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'peer_sync_snapshots'
  ) THEN
    CREATE TABLE peer_sync_snapshots (
      snapshot_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      peer_id          TEXT NOT NULL,
      ip_address       INET,
      sync_mode        TEXT NOT NULL, -- 'full', 'light', 'archive'
      current_block    BIGINT NOT NULL,
      highest_block    BIGINT,
      synced_ratio     NUMERIC(5,2),
      lag_blocks       BIGINT GENERATED ALWAYS AS (highest_block - current_block) STORED,
      latency_ms       INTEGER,
      status           TEXT NOT NULL, -- 'active', 'idle', 'stalled'
      geo_location     JSONB, -- { country: 'ZA', city: 'Cape Town' }
      agent_version    TEXT,
      recorded_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_peer_sync_peer_id ON peer_sync_snapshots(peer_id);
CREATE INDEX IF NOT EXISTS idx_peer_sync_status ON peer_sync_snapshots(status);
CREATE INDEX IF NOT EXISTS idx_peer_sync_recorded_at ON peer_sync_snapshots(recorded_at);
