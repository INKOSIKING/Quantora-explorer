-- =============================================
-- 🔄 Table: sync_events
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'sync_events'
  ) THEN
    CREATE TABLE sync_events (
      event_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      sync_type        TEXT NOT NULL, -- e.g., 'full', 'fast', 'light', 'catchup'
      started_at       TIMESTAMPTZ NOT NULL,
      completed_at     TIMESTAMPTZ,
      duration_seconds NUMERIC(10, 2),
      status           TEXT NOT NULL, -- 'in_progress', 'completed', 'failed'
      peer_count       INTEGER,
      block_height     BIGINT,
      client_version   TEXT,
      notes            TEXT,
      created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_sync_events_type ON sync_events(sync_type);
CREATE INDEX IF NOT EXISTS idx_sync_events_status ON sync_events(status);
CREATE INDEX IF NOT EXISTS idx_sync_events_started ON sync_events(started_at);
