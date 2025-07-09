-- =============================================
-- 📜 Table: execution_traces
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'execution_traces'
  ) THEN
    CREATE TABLE execution_traces (
      trace_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      transaction_hash TEXT NOT NULL,
      block_number     BIGINT NOT NULL,
      trace_index      INT NOT NULL,
      parent_trace     UUID,
      call_type        TEXT,
      from_address     TEXT,
      to_address       TEXT,
      gas_used         BIGINT,
      gas_limit        BIGINT,
      input_data       TEXT,
      output_data      TEXT,
      value_transferred NUMERIC(78, 0),
      error_message    TEXT,
      depth            INT,
      vm_stack         JSONB,
      memory_snapshot  JSONB,
      storage_diff     JSONB,
      timestamp        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_exec_traces_tx ON execution_traces(transaction_hash);
CREATE INDEX IF NOT EXISTS idx_exec_traces_block ON execution_traces(block_number);
CREATE INDEX IF NOT EXISTS idx_exec_traces_trace_index ON execution_traces(trace_index);
