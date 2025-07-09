-- =============================================================================
-- File: liquidity_resilience_stack.sql
-- Purpose: Deep resilience tooling for liquidity, censorship, and agent mesh security
-- =============================================================================

-- 1. Liquidity Protection Grid
CREATE TABLE IF NOT EXISTS liquidity_protection_grid (
    zone_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    asset_pair        TEXT NOT NULL,
    threshold_level   NUMERIC NOT NULL,
    cooldown_window   INTERVAL NOT NULL,
    auto_rebalance    BOOLEAN DEFAULT TRUE,
    last_triggered_at TIMESTAMPTZ
);

-- 2. Dark Forest Avoidance
CREATE TABLE IF NOT EXISTS dark_forest_avoidance (
    alert_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    detection_type  TEXT,
    tx_hash         VARCHAR(66),
    evasion_method  TEXT,
    detected_by     TEXT,
    severity        TEXT CHECK (severity IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
    detected_at     TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Atomic Composer Registry
CREATE TABLE IF NOT EXISTS atomic_composer_registry (
    composer_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_sequence     TEXT[],
    atomic_type     TEXT,
    timeout_window  INTERVAL,
    is_active       BOOLEAN DEFAULT TRUE,
    registered_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Sequencer Governance Council
CREATE TABLE IF NOT EXISTS sequencer_governance_council (
    council_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_address  VARCHAR(66),
    role            TEXT,
    weight_vote     NUMERIC DEFAULT 1,
    term_start      TIMESTAMPTZ,
    term_end        TIMESTAMPTZ
);

-- 5. Multi-Agent Vulnerability Zones
CREATE TABLE IF NOT EXISTS multi_agent_vulnerability_zones (
    zone_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    affected_modules TEXT[],
    exploit_vector  TEXT,
    zk_flag         BOOLEAN DEFAULT FALSE,
    mitigation_plan TEXT,
    discovered_at   TIMESTAMPTZ DEFAULT NOW()
);
