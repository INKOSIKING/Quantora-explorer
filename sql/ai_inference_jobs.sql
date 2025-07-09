-- ===============================================================
-- 🧠 Table: ai_inference_jobs
-- Description: Tracks all AI model inference jobs including inputs,
-- outputs, performance, and on-chain task integration.
-- ===============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_inference_jobs'
  ) THEN
    CREATE TABLE ai_inference_jobs (
      job_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_name            TEXT NOT NULL,
      model_version         TEXT NOT NULL,
      input_type            TEXT NOT NULL,
      input_reference       TEXT, -- could be tx hash, contract addr, etc.
      input_data_hash       TEXT,
      inference_result      JSONB NOT NULL,
      result_confidence     NUMERIC(5, 2),
      result_category       TEXT,
      status                TEXT CHECK (status IN ('queued', 'running', 'completed', 'failed')) DEFAULT 'queued',
      triggered_by          TEXT, -- user addr or system
      execution_time_ms     INTEGER,
      completed_at          TIMESTAMPTZ,
      inserted_at           TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_inference_model ON ai_inference_jobs(model_name, model_version);
CREATE INDEX IF NOT EXISTS idx_ai_inference_input_ref ON ai_inference_jobs(input_reference);
CREATE INDEX IF NOT EXISTS idx_ai_inference_status ON ai_inference_jobs(status);
