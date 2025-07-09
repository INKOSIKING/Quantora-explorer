-- ==================================================
-- 📡 Table: gossip_protocol_events
-- ==================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'gossip_protocol_events'
  ) THEN
    CREATE TABLE gossip_protocol_events (
      event_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      peer_id          TEXT NOT NULL,
      message_type     TEXT NOT NULL,
      message_hash     TEXT,
      topic            TEXT,
      payload_size     INT,
      received_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      is_duplicate     BOOLEAN DEFAULT FALSE,
      processing_time_ms INT,
      metadata         JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_gossip_peer ON gossip_protocol_events(peer_id);
CREATE INDEX IF NOT EXISTS idx_gossip_topic ON gossip_protocol_events(topic);
CREATE INDEX IF NOT EXISTS idx_gossip_message_hash ON gossip_protocol_events(message_hash);
