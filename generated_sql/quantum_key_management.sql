-- Table: quantum_key_management
-- Description: Registry for managing lifecycle and metadata of quantum-resistant cryptographic keys.

CREATE TABLE IF NOT EXISTS quantum_key_management (
    key_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    associated_wallet TEXT NOT NULL,
    public_key TEXT NOT NULL,
    key_type TEXT CHECK (key_type IN ('Dilithium', 'SPHINCS+', 'Falcon', 'Kyber', 'Hybrid', 'Other')) NOT NULL,
    key_usage TEXT CHECK (key_usage IN ('transaction_signing', 'contract_deployment', 'data_encryption')) NOT NULL,
    valid_from TIMESTAMPTZ NOT NULL,
    valid_until TIMESTAMPTZ,
    is_revoked BOOLEAN NOT NULL DEFAULT FALSE,
    revoked_reason TEXT,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_qkm_wallet ON quantum_key_management(associated_wallet);
CREATE INDEX IF NOT EXISTS idx_qkm_key_type ON quantum_key_management(key_type);
CREATE INDEX IF NOT EXISTS idx_qkm_validity ON quantum_key_management(valid_from, valid_until);
CREATE INDEX IF NOT EXISTS idx_qkm_revoked ON quantum_key_management(is_revoked);

COMMENT ON TABLE quantum_key_management IS 'Tracks post-quantum key material and lifecycle used for secure blockchain operations.';
COMMENT ON COLUMN quantum_key_management.key_type IS 'Algorithm used for quantum-safe operations.';
COMMENT ON COLUMN quantum_key_management.is_revoked IS 'Indicates whether the key was revoked.';
