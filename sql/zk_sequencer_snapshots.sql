-- ========================================================================
-- Table: zk_sequencer_snapshots
-- Purpose: Captures periodic zk sequencer states (ordering, batch roots)
-- ========================================================================

CREATE TABLE IF NOT EXISTS zk_sequencer_snapshots (
    snapshot_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sequencer_node    TEXT NOT NULL,
    l2_block_number   BIGINT NOT NULL,
    state_root        VARCHAR(66) NOT NULL,
    tx_root           VARCHAR(66) NOT NULL,
    batch_root        VARCHAR(66),
    proof_hash        VARCHAR(66),
    snapshot_hash     VARCHAR(66),
    finalized         BOOLEAN DEFAULT FALSE,
    fault_detected    BOOLEAN DEFAULT FALSE,
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_zk_seq_snapshots_node ON zk_sequencer_snapshots(sequencer_node);
CREATE INDEX IF NOT EXISTS idx_zk_seq_snapshots_l2block ON zk_sequencer_snapshots(l2_block_number);
CREATE INDEX IF NOT EXISTS idx_zk_seq_snapshots_finalized ON zk_sequencer_snapshots(finalized);
