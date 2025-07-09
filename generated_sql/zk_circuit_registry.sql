-- Table: zk_circuit_registry
-- Description: Registry of deployed zero-knowledge circuits used across Quantora blockchain

CREATE TABLE IF NOT EXISTS zk_circuit_registry (
    id BIGSERIAL PRIMARY KEY,
    circuit_name TEXT NOT NULL,
    version TEXT NOT NULL,
    circuit_hash TEXT UNIQUE NOT NULL,
    description TEXT,
    purpose TEXT NOT NULL CHECK (purpose IN ('identity_proof', 'scalability', 'privacy', 'compliance', 'data_integrity')),
    proving_key_hash TEXT,
    verification_key_hash TEXT,
    deployment_block_height BIGINT,
    deployment_tx_hash TEXT,
    audit_status TEXT DEFAULT 'pending' CHECK (audit_status IN ('pending', 'audited', 'rejected')),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_zk_circuit_name_version ON zk_circuit_registry(circuit_name, version);

COMMENT ON TABLE zk_circuit_registry IS 'Tracks all ZK circuits used in Quantora, including versioning and purposes like privacy or scalability.';
