-- File: schemas/index_jobs.sql

CREATE TABLE IF NOT EXISTS index_jobs (
  job_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_type         TEXT NOT NULL, -- e.g., reorg_repair, backfill, snapshot, metrics
  status           TEXT NOT NULL DEFAULT 'pending', -- pending, running, success, failed
  priority         INTEGER NOT NULL DEFAULT 100,
  params           JSONB,
  retries          INTEGER NOT NULL DEFAULT 0,
  error_message    TEXT,
  started_at       TIMESTAMPTZ,
  finished_at      TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔄 Auto-update updated_at
CREATE OR REPLACE FUNCTION update_index_jobs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_index_jobs_updated_at
BEFORE UPDATE ON index_jobs
FOR EACH ROW
EXECUTE FUNCTION update_index_jobs_updated_at();

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_index_jobs_status ON index_jobs (status);
CREATE INDEX IF NOT EXISTS idx_index_jobs_type ON index_jobs (job_type);
CREATE INDEX IF NOT EXISTS idx_index_jobs_priority ON index_jobs (priority);
CREATE INDEX IF NOT EXISTS idx_index_jobs_created ON index_jobs (created_at DESC);
