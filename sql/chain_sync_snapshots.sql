-- ==========================================================
-- �� Table: chain_sync_snapshots
-- ==========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'chain_sync_snapshots'
  ) THEN
    CREATE TABLE chain_sync_snapshots (
      snapshot_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      node_id           TEXT NOT NULL,
      client_version    TEXT,
      current_block     BIGINT NOT NULL,
      highest_block     BIGINT,
      sync_progress     NUMERIC(5,2) CHECK (sync_progress >= 0 AND sync_progress <= 100),
      peer_count        INT,
      is_syncing        BOOLEAN NOT NULL DEFAULT TRUE,
      error_message     TEXT,
      collected_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_sync_node_id ON chain_sync_snapshots(node_id);
CREATE INDEX IF NOT EXISTS idx_sync_collected_at ON chain_sync_snapshots(collected_at);
CREATE INDEX IF NOT EXISTS idx_sync_progress ON chain_sync_snapshots(sync_progress);
