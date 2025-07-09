-- ======================================================
-- Table: execution_tasks
-- Purpose: Stateless, parallelizable execution units
-- ======================================================

CREATE TABLE IF NOT EXISTS execution_tasks (
    task_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_batch_hash   VARCHAR(66) NOT NULL,
    executor_node   TEXT NOT NULL,
    state_snapshot  BYTEA,
    execution_trace BYTEA,
    zk_proof_hash   VARCHAR(66),
    status          TEXT CHECK (status IN ('pending', 'executing', 'completed', 'failed')) DEFAULT 'pending',
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);
