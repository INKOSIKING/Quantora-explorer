-- =======================================================================
-- Table: zero_latency_commit_log
-- Purpose: Ultra-fast append-only log of write operations to ensure
--          zero-latency commit across distributed consensus
-- Used for: HFT chains, sub-second rollups, flash execution validation
-- =======================================================================

CREATE TABLE IF NOT EXISTS zero_latency_commit_log (
    log_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    shard_id         BIGINT NOT NULL,
    sequence_number  BIGINT NOT NULL,
    operation_type   TEXT NOT NULL CHECK (operation_type IN ('INSERT', 'UPDATE', 'DELETE')),
    table_name       TEXT NOT NULL,
    record_key       TEXT NOT NULL,
    payload_hash     VARCHAR(66) NOT NULL,
    payload_snapshot BYTEA,
    node_id          TEXT NOT NULL,
    latency_ns       BIGINT NOT NULL,  -- nanoseconds
    commit_status    TEXT NOT NULL CHECK (commit_status IN ('committed', 'pending', 'failed')),
    committed_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_zlcl_shard_seq ON zero_latency_commit_log(shard_id, sequence_number);
CREATE INDEX IF NOT EXISTS idx_zlcl_status ON zero_latency_commit_log(commit_status);
CREATE INDEX IF NOT EXISTS idx_zlcl_table ON zero_latency_commit_log(table_name);
