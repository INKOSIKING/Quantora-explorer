-- ================================================
-- 🧠 Table: ai_inference_sessions
-- Description: Tracks all AI inference requests, results and metadata
-- ================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'ai_inference_sessions'
  ) THEN
    CREATE TABLE ai_inference_sessions (
      session_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      model_name         TEXT NOT NULL,
      model_version      TEXT,
      input_hash         TEXT NOT NULL,
      output_hash        TEXT,
      result             JSONB,
      status             TEXT NOT NULL CHECK (status IN ('pending', 'completed', 'failed')),
      error_message      TEXT,
      duration_ms        INT,
      initiated_by       TEXT NOT NULL,
      source_ip          INET,
      initiated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      completed_at       TIMESTAMPTZ
    );
  END IF;
END;
$$;

-- 📈 Indexes
CREATE INDEX IF NOT EXISTS idx_inference_model ON ai_inference_sessions(model_name);
CREATE INDEX IF NOT EXISTS idx_inference_status ON ai_inference_sessions(status);
CREATE INDEX IF NOT EXISTS idx_inference_initiated_at ON ai_inference_sessions(initiated_at);
