-- ============================================================================
-- File: quantum_sidechain_entropy.sql
-- Purpose: Extend blockchain with predictive forking, sidechain tracking, and quantum mempool decay
-- ============================================================================

-- 1. Quantum Mempool Decay
CREATE TABLE IF NOT EXISTS quantum_mempool_decay (
    decay_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash          VARCHAR(66) NOT NULL,
    qubit_entropy    NUMERIC NOT NULL,
    decay_probability NUMERIC CHECK (decay_probability >= 0 AND decay_probability <= 1),
    decay_window     INTERVAL,
    measured_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_decay_tx_hash ON quantum_mempool_decay(tx_hash);

-- 2. Sidechain Bridge Flows
CREATE TABLE IF NOT EXISTS sidechain_bridge_flows (
    bridge_tx_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    origin_chain     TEXT NOT NULL,
    dest_chain       TEXT NOT NULL,
    asset_type       TEXT NOT NULL,
    amount           NUMERIC NOT NULL,
    user_address     VARCHAR(66) NOT NULL,
    status           TEXT CHECK (status IN ('pending', 'confirmed', 'failed')) DEFAULT 'pending',
    relayer_node     TEXT,
    initiated_at     TIMESTAMPTZ DEFAULT NOW(),
    completed_at     TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_bridge_origin_dest ON sidechain_bridge_flows(origin_chain, dest_chain);

-- 3. Chaosnet Simulation Events
CREATE TABLE IF NOT EXISTS chaosnet_simulation_events (
    event_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    simulation_type  TEXT NOT NULL,
    affected_nodes   JSONB,
    triggered_by     TEXT,
    fault_model      TEXT,
    duration         INTERVAL,
    outcome_summary  TEXT,
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Validator Entropy Beacons
CREATE TABLE IF NOT EXISTS validator_entropy_beacons (
    beacon_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    validator_address VARCHAR(66) NOT NULL,
    entropy_seed     BYTEA NOT NULL,
    beacon_round     BIGINT NOT NULL,
    generated_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_beacon_validator ON validator_entropy_beacons(validator_address);

-- 5. Neural Fork Predictor
CREATE TABLE IF NOT EXISTS neural_fork_predictor (
    predictor_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fork_probability NUMERIC CHECK (fork_probability >= 0 AND fork_probability <= 1),
    block_height     BIGINT NOT NULL,
    model_version    TEXT,
    feature_vector   JSONB,
    predicted_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_nfp_block_height ON neural_fork_predictor(block_height);
