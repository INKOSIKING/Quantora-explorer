-- ─────────────────────────────────────────────────────────────────────────────
-- 🧬 META_VALIDATOR_PROFILES — Rich profile of validators over time
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_validator_profiles (
    profile_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    validator_address VARCHAR(66) NOT NULL,
    reputation_score  NUMERIC(5,2) DEFAULT 100.0,
    uptime_percent    NUMERIC(5,2),
    slashing_events   INTEGER DEFAULT 0,
    delegated_stake   NUMERIC(30, 0),
    region_code       TEXT,
    last_seen         TIMESTAMPTZ,
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_validator_addr ON meta_validator_profiles(validator_address);
CREATE INDEX IF NOT EXISTS idx_validator_region ON meta_validator_profiles(region_code);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🔧 META_SYNC_FAULT_DETECTOR — Detects desyncs, drift, or ghost fork propagation
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_sync_fault_detector (
    fault_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    node_id           TEXT NOT NULL,
    fault_type        TEXT CHECK (fault_type IN ('time-drift', 'forked', 'finality-delay', 'lagging')),
    detected_height   BIGINT NOT NULL,
    reference_hash    VARCHAR(66),
    local_hash        VARCHAR(66),
    resolved          BOOLEAN DEFAULT FALSE,
    detected_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_fault_node ON meta_sync_fault_detector(node_id);
CREATE INDEX IF NOT EXISTS idx_fault_type ON meta_sync_fault_detector(fault_type);
