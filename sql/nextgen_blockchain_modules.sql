-- ============================================================================
-- File: nextgen_blockchain_modules.sql
-- Purpose: Extends blockchain to AI+Orbital+Mempool intelligence layer
-- ============================================================================

-- 1. dApp Mempool Fingerprint
CREATE TABLE IF NOT EXISTS dapp_mempool_fingerprint (
    fingerprint_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dapp_address      VARCHAR(66) NOT NULL,
    tx_pattern_hash   VARCHAR(128) NOT NULL,
    tx_type           TEXT,
    frequency_score   NUMERIC,
    entropy_level     NUMERIC,
    block_reference   BIGINT,
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dapp_fingerprint_dapp ON dapp_mempool_fingerprint(dapp_address);

-- 2. Satellite Consensus Links
CREATE TABLE IF NOT EXISTS satellite_consensus_links (
    link_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    node_id           VARCHAR(128) NOT NULL,
    satellite_id      TEXT,
    orbit_band        TEXT,
    latency_ms        INT,
    packet_loss_pct   NUMERIC,
    sync_state        TEXT CHECK (sync_state IN ('synced', 'lagging', 'failed')),
    updated_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_satellite_node_id ON satellite_consensus_links(node_id);

-- 3. AI Relayer Oracle Sync
CREATE TABLE IF NOT EXISTS ai_relayer_oracle_sync (
    sync_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    oracle_node       TEXT NOT NULL,
    model_type        TEXT NOT NULL,
    model_version     TEXT,
    synced_blocks     BIGINT,
    inference_window  INTERVAL,
    sync_accuracy     NUMERIC,
    last_sync_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_oracle_node ON ai_relayer_oracle_sync(oracle_node);
