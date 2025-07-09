-- =============================================================================
-- File: fork_intelligence_stack.sql
-- Purpose: Fork-aware intelligence, validator hiveminds, and real-time ZK censorship detection
-- =============================================================================

-- 1. Intent Graph Links
CREATE TABLE IF NOT EXISTS intent_graph_links (
    link_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_address  VARCHAR(66) NOT NULL,
    target_address  VARCHAR(66) NOT NULL,
    interaction_type TEXT,
    link_weight     NUMERIC,
    context         JSONB,
    observed_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_igl_source_target ON intent_graph_links(source_address, target_address);

-- 2. Autonomous Validator Hivemind
CREATE TABLE IF NOT EXISTS validator_hivemind_status (
    node_address    VARCHAR(66) PRIMARY KEY,
    hivemind_group  TEXT NOT NULL,
    neural_checksum TEXT,
    consensus_role  TEXT,
    memory_state    JSONB,
    last_sync_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Real-Time Censorship Oracles
CREATE TABLE IF NOT EXISTS censorship_oracle_reports (
    report_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    oracle_node     TEXT NOT NULL,
    suspected_tx    VARCHAR(66),
    evidence_blob   BYTEA,
    report_reason   TEXT,
    verified        BOOLEAN DEFAULT FALSE,
    reported_at     TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Fork Choice Tendencies
CREATE TABLE IF NOT EXISTS fork_choice_tendencies (
    fork_event_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    block_hash      VARCHAR(66) NOT NULL,
    competing_hash  VARCHAR(66),
    choice_reason   TEXT,
    vote_weight     NUMERIC,
    observed_by     TEXT,
    resolved_at     TIMESTAMPTZ DEFAULT NOW()
);

-- 5. ZK Activity Heatmap
CREATE TABLE IF NOT EXISTS zk_activity_heatmap (
    zk_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    block_height    BIGINT NOT NULL,
    zk_tx_count     INT NOT NULL,
    prover_id       TEXT,
    geographic_zone TEXT,
    heat_score      NUMERIC,
    sampled_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_zkah_block_height ON zk_activity_heatmap(block_height);
