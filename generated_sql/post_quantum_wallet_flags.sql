-- Table: post_quantum_wallet_flags
-- Description: Tracks wallets marked with quantum-safety metadata and cryptographic capabilities

CREATE TABLE IF NOT EXISTS post_quantum_wallet_flags (
    wallet_address TEXT PRIMARY KEY,
    uses_post_quantum_cryptography BOOLEAN DEFAULT FALSE,
    pq_algorithm TEXT, -- e.g., CRYSTALS-Kyber, Falcon, SPHINCS+
    fallback_curve TEXT, -- e.g., secp256k1, ed25519
    quantum_hardened_since TIMESTAMPTZ,
    wallet_provider TEXT,
    audit_certified BOOLEAN DEFAULT FALSE,
    certification_entity TEXT,
    last_verified TIMESTAMPTZ,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_pq_wallet_algo ON post_quantum_wallet_flags(pq_algorithm);
CREATE INDEX IF NOT EXISTS idx_pq_wallet_certified ON post_quantum_wallet_flags(audit_certified);
CREATE INDEX IF NOT EXISTS idx_pq_wallet_verified ON post_quantum_wallet_flags(last_verified);

COMMENT ON TABLE post_quantum_wallet_flags IS 'Flags and verifies wallets that implement post-quantum cryptographic schemes and standards.';
