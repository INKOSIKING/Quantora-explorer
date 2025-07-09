-- File: schemas/network_metrics.sql

CREATE TABLE IF NOT EXISTS network_metrics (
  id                BIGSERIAL PRIMARY KEY,
  peer_count        INTEGER NOT NULL,
  avg_block_time    INTERVAL,
  propagation_delay INTERVAL,
  orphan_rate       NUMERIC(5, 2), -- % of orphaned blocks
  sync_height       BIGINT,
  peer_height       BIGINT,
  recorded_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes for metrics queries
CREATE INDEX IF NOT EXISTS idx_network_metrics_recorded_at ON network_metrics (recorded_at DESC);
