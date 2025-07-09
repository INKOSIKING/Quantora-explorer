-- =============================================
-- 🔁 Table: proof_pipeline_tasks
-- =============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'proof_pipeline_tasks'
  ) THEN
    CREATE TABLE proof_pipeline_tasks (
      task_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      pipeline_id        UUID NOT NULL,
      step_name          TEXT NOT NULL,
      step_order         INT NOT NULL,
      input_refs         JSONB,
      output_refs        JSONB,
      status             TEXT NOT NULL CHECK (status IN ('queued', 'running', 'succeeded', 'failed', 'skipped')),
      started_at         TIMESTAMPTZ,
      finished_at        TIMESTAMPTZ,
      logs               TEXT,
      retries            INT DEFAULT 0,
      worker_node        TEXT,
      error_details      TEXT,
      created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_proof_pipeline_step_order ON proof_pipeline_tasks(pipeline_id, step_order);
CREATE INDEX IF NOT EXISTS idx_proof_pipeline_status ON proof_pipeline_tasks(status);
