-- Table: quantum_key_rotation_logs
-- Description: Audits all key rotation events especially those aligned with post-quantum cryptographic standards.

CREATE TABLE IF NOT EXISTS quantum_key_rotation_logs (
    rotation_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wallet_address TEXT NOT NULL,
    old_public_key TEXT NOT NULL,
    new_public_key TEXT NOT NULL,
    quantum_resistant BOOLEAN NOT NULL DEFAULT FALSE,
    reason TEXT,
    rotated_by TEXT, -- Could be user, system, or guardian contract
    rotation_method TEXT CHECK (rotation_method IN ('automated', 'manual', 'scheduled', 'emergency')),
    rotation_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    network TEXT DEFAULT 'mainnet'
);

CREATE INDEX IF NOT EXISTS idx_qkrl_wallet ON quantum_key_rotation_logs(wallet_address);
CREATE INDEX IF NOT EXISTS idx_qkrl_timestamp ON quantum_key_rotation_logs(rotation_timestamp);
CREATE INDEX IF NOT EXISTS idx_qkrl_quantum_resistance ON quantum_key_rotation_logs(quantum_resistant);

COMMENT ON TABLE quantum_key_rotation_logs IS 'Lifecycle audit trail for quantum-aware key rotations across wallets on the Quantora chain.';
COMMENT ON COLUMN quantum_key_rotation_logs.quantum_resistant IS 'Whether the new key complies with quantum-safe cryptography.';
