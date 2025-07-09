-- =========================================
-- ⚙️ Table: blockchain_runtime_metrics
-- =========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'blockchain_runtime_metrics'
  ) THEN
    CREATE TABLE blockchain_runtime_metrics (
      metric_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      node_id           TEXT NOT NULL,
      process_id        INT,
      memory_usage_mb   INT,
      cpu_usage_percent NUMERIC(5,2),
      uptime_seconds    BIGINT,
      threads_active    INT,
      gc_cycles         INT,
      heap_size_mb      INT,
      last_restart_at   TIMESTAMPTZ,
      sampled_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      metadata          JSONB
    );
  END IF;
END;
$$;

