-- ============================================
-- 📊 Table: network_health_history
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'network_health_history'
  ) THEN
    CREATE TABLE network_health_history (
      health_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      snapshot_time     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      peer_count        INT,
      avg_latency_ms    INT,
      packet_loss_pct   NUMERIC(5,2),
      uptime_score      NUMERIC(5,2),
      leader_sync_gap   BIGINT,
      notes             TEXT
    );
  END IF;
END;
$$;

CREATE INDEX IF NOT EXISTS idx_network_health_time ON network_health_history(snapshot_time);
