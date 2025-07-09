-- ====================================================================
-- Table: zk_rollup_jobs
-- Purpose: Tracks zkRollup job lifecycle, batching, proofs and states
-- ====================================================================

CREATE TABLE IF NOT EXISTS zk_rollup_jobs (
    job_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_type           TEXT NOT NULL CHECK (job_type IN ('batch_commitment', 'state_proof', 'finality_proof')),
    batch_root         VARCHAR(66) NOT NULL,
    tx_count           BIGINT NOT NULL,
    input_hash         VARCHAR(66),
    state_commitment   VARCHAR(66),
    proof_hash         VARCHAR(66),
    assigned_executor  TEXT,
    priority_level     INTEGER DEFAULT 0,
    status             TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'verifying', 'finalized', 'failed')) DEFAULT 'pending',
    created_at         TIMESTAMPTZ DEFAULT NOW(),
    updated_at         TIMESTAMPTZ DEFAULT NOW(),
    finalized_at       TIMESTAMPTZ
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_zk_jobs_status ON zk_rollup_jobs(status);
CREATE INDEX IF NOT EXISTS idx_zk_jobs_executor ON zk_rollup_jobs(assigned_executor);
CREATE INDEX IF NOT EXISTS idx_zk_jobs_priority ON zk_rollup_jobs(priority_level);
CREATE INDEX IF NOT EXISTS idx_zk_jobs_batch_root ON zk_rollup_jobs(batch_root);
