-- ========================================================
-- 🌐 Table: network_participation_events
-- ========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'network_participation_events'
  ) THEN
    CREATE TABLE network_participation_events (
      event_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      node_id             TEXT NOT NULL,
      role                TEXT NOT NULL, -- validator | full_node | relayer
      event_type          TEXT NOT NULL, -- joined | left | heartbeat | timeout
      block_height        BIGINT,
      epoch_number        BIGINT,
      latency_ms          INT,
      peer_count          INT,
      geo_location        TEXT,
      status              TEXT,
      metadata            JSONB,
      emitted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_network_participation_node ON network_participation_events(node_id);
CREATE INDEX IF NOT EXISTS idx_network_participation_epoch ON network_participation_events(epoch_number);
