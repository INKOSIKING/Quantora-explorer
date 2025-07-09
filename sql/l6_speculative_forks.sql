-- ======================================================
-- Schema: L6 Speculative Forks
-- Purpose: Support deep parallel speculative fork states
-- ======================================================

CREATE TABLE IF NOT EXISTS l6_speculative_forks (
    fork_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_fork_id      UUID REFERENCES l6_speculative_forks(fork_id) ON DELETE CASCADE,
    speculative_root    VARCHAR(66) NOT NULL,
    originating_node    TEXT NOT NULL,
    predicted_state     BYTEA,
    prediction_confidence NUMERIC CHECK (prediction_confidence BETWEEN 0 AND 1),
    fork_depth          INT NOT NULL DEFAULT 0,
    sealed              BOOLEAN DEFAULT FALSE,
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    sealed_at           TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_l6_forks_parent ON l6_speculative_forks(parent_fork_id);
CREATE INDEX IF NOT EXISTS idx_l6_forks_root ON l6_speculative_forks(speculative_root);
