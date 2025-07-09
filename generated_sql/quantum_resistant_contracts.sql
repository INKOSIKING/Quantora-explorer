-- Table: quantum_resistant_contracts
-- Description: Metadata registry for smart contracts designed or migrated with post-quantum cryptographic protections.

CREATE TABLE IF NOT EXISTS quantum_resistant_contracts (
    contract_address TEXT PRIMARY KEY,
    deployed_by TEXT NOT NULL,
    quantum_safe BOOLEAN NOT NULL DEFAULT FALSE,
    hash_algorithm TEXT CHECK (hash_algorithm IN ('SHA3', 'Blake3', 'SPHINCS+', 'Dilithium', 'Other')),
    quantum_algorithm_details TEXT,
    verification_mechanism TEXT,
    source_code_hash TEXT,
    audit_status TEXT CHECK (audit_status IN ('unaudited', 'pending', 'verified', 'flagged')) DEFAULT 'unaudited',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_qrc_deployer ON quantum_resistant_contracts(deployed_by);
CREATE INDEX IF NOT EXISTS idx_qrc_created ON quantum_resistant_contracts(created_at);
CREATE INDEX IF NOT EXISTS idx_qrc_audit_status ON quantum_resistant_contracts(audit_status);
CREATE INDEX IF NOT EXISTS idx_qrc_qsafe ON quantum_resistant_contracts(quantum_safe);

COMMENT ON TABLE quantum_resistant_contracts IS 'Registry of contracts secured with post-quantum mechanisms or flagged for migration.';
COMMENT ON COLUMN quantum_resistant_contracts.hash_algorithm IS 'Indicates the post-quantum algorithm used for signing or verifying.';
