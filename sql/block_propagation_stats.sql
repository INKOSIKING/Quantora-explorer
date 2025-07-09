-- =======================================================
-- 🚀 Table: block_propagation_stats
-- =======================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'block_propagation_stats'
  ) THEN
    CREATE TABLE block_propagation_stats (
      propagation_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      block_hash         TEXT NOT NULL,
      block_number       BIGINT NOT NULL,
      first_seen_at      TIMESTAMPTZ NOT NULL,
      fully_propagated_at TIMESTAMPTZ,
      propagation_time_ms INT,
      peers_received     INT,
      average_latency_ms INT,
      network_partition  BOOLEAN DEFAULT FALSE,
      notes              TEXT,
      created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_block_propagation_hash ON block_propagation_stats(block_hash);
CREATE INDEX IF NOT EXISTS idx_block_propagation_number ON block_propagation_stats(block_number);
