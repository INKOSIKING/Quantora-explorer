-- ======================================
-- 🧠 Table: prover_jobs
-- ======================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'prover_jobs'
  ) THEN
    CREATE TABLE prover_jobs (
      job_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      job_type           TEXT NOT NULL CHECK (job_type IN ('zkSNARK', 'zkSTARK', 'bulletproof', 'plonk', 'halo2', 'other')),
      status             TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
      payload_hash       TEXT,
      proof_blob         BYTEA,
      error_message      TEXT,
      submitted_by       TEXT,
      assigned_prover    TEXT,
      compute_time_ms    INT,
      memory_usage_mb    INT,
      cpu_usage_pct      NUMERIC(5,2),
      metadata           JSONB,
      submitted_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      completed_at       TIMESTAMPTZ
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_prover_jobs_status ON prover_jobs(status);
CREATE INDEX IF NOT EXISTS idx_prover_jobs_type ON prover_jobs(job_type);
CREATE INDEX IF NOT EXISTS idx_prover_jobs_submitted_at ON prover_jobs(submitted_at);
