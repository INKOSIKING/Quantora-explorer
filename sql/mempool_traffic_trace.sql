-- ============================================================
-- 🚦 Table: mempool_traffic_trace
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'mempool_traffic_trace'
  ) THEN
    CREATE TABLE mempool_traffic_trace (
      trace_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      observed_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      tx_count            INT NOT NULL,
      tx_types            JSONB, -- e.g., {'transfer': 100, 'contract_call': 50}
      avg_fee             NUMERIC(18,8),
      avg_gas_price       NUMERIC(18,8),
      max_gas_price       NUMERIC(18,8),
      min_gas_price       NUMERIC(18,8),
      avg_tx_size_bytes   BIGINT,
      network_condition   TEXT,
      source_node_id      TEXT,
      notes               TEXT
    );
  END IF;
END;
$$;

