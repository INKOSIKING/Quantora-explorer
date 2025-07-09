-- ====================================================
-- 🧠 Table: model_execution_trace
-- Description: Records full trace of AI model executions
-- including inputs, context, metadata, and outcome status.
-- Enables full observability and debugging of AI in Quantora.
-- ====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'model_execution_trace'
  ) THEN
    CREATE TABLE model_execution_trace (
      trace_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      request_id           TEXT NOT NULL,
      user_id              TEXT,
      api_key_hash         TEXT,
      model_name           TEXT NOT NULL,
      model_version        TEXT,
      input_summary        TEXT,
      input_tokens         INT,
      output_tokens        INT,
      temperature          NUMERIC(4,2),
      top_p                NUMERIC(4,2),
      stop_sequences       TEXT[],
      system_prompt_hash   TEXT,
      completion_time_ms   INT,
      status               TEXT NOT NULL,
      error_message        TEXT,
      executed_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_model_exec_user ON model_execution_trace(user_id);
CREATE INDEX IF NOT EXISTS idx_model_exec_model ON model_execution_trace(model_name);
CREATE INDEX IF NOT EXISTS idx_model_exec_time ON model_execution_trace(executed_at);
