-- ============================================================================
-- Table: fork_reorg_detector
-- Purpose: Logs reorg events, competing fork states, and finality disputes
-- ============================================================================

CREATE TABLE IF NOT EXISTS fork_reorg_detector (
    reorg_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    affected_chain_id   TEXT NOT NULL,
    reorg_height        BIGINT NOT NULL,
    original_block_hash VARCHAR(66) NOT NULL,
    new_block_hash      VARCHAR(66) NOT NULL,
    reorg_depth         INTEGER NOT NULL,
    fork_type           TEXT CHECK (fork_type IN (
                          'minor', 'temporary', 'major', 'permanent', 'attack')) DEFAULT 'temporary',
    detection_method    TEXT CHECK (detection_method IN (
                          'gossip_trigger', 'finality_lag', 'validator_inconsistency', 'manual_override')),
    resolver_node       TEXT,
    finalized           BOOLEAN DEFAULT FALSE,
    timestamp           TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_reorg_chain_height ON fork_reorg_detector(affected_chain_id, reorg_height);
