-- =========================================================
-- 🔍 Table: transaction_execution_traces
-- =========================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'transaction_execution_traces'
  ) THEN
    CREATE TABLE transaction_execution_traces (
      trace_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      tx_hash            TEXT NOT NULL,
      trace_index        INT NOT NULL,
      parent_trace_id    UUID,
      from_address       TEXT NOT NULL,
      to_address         TEXT,
      call_type          TEXT,
      input_data         TEXT,
      output_data        TEXT,
      value_transferred  NUMERIC(78, 0),
      gas_used           BIGINT,
      gas_remaining      BIGINT,
      opcode             TEXT,
      depth              INT,
      error              TEXT,
      timestamp          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_trace_tx_hash ON transaction_execution_traces(tx_hash);
CREATE INDEX IF NOT EXISTS idx_trace_parent_id ON transaction_execution_traces(parent_trace_id);
CREATE INDEX IF NOT EXISTS idx_trace_depth ON transaction_execution_traces(depth);
