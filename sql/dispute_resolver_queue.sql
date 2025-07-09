-- =========================================================================
-- Table: dispute_resolver_queue
-- Purpose: Queues fraud/challenge assertions in zk/fork environments
-- =========================================================================

CREATE TABLE IF NOT EXISTS dispute_resolver_queue (
    dispute_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    related_tx_hash   VARCHAR(66),
    related_block     BIGINT,
    challenger        VARCHAR(66) NOT NULL,
    defender          VARCHAR(66),
    reason_code       TEXT NOT NULL, -- e.g. 'INVALID_STATE', 'MEV_SLASH'
    resolution_type   TEXT CHECK (resolution_type IN ('zk_verification', 'arbitration', 'slashing', 'fork_vote')) NOT NULL,
    evidence_blob     BYTEA,
    status            TEXT CHECK (status IN ('queued', 'verifying', 'resolved', 'rejected')) DEFAULT 'queued',
    created_at        TIMESTAMPTZ DEFAULT NOW(),
    resolved_at       TIMESTAMPTZ
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_dispute_status ON dispute_resolver_queue(status);
CREATE INDEX IF NOT EXISTS idx_dispute_tx_hash ON dispute_resolver_queue(related_tx_hash);
CREATE INDEX IF NOT EXISTS idx_dispute_challenger ON dispute_resolver_queue(challenger);
