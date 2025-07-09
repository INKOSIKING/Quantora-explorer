-- Table: post_quantum_transaction_signatures
-- Description: Stores metadata about post-quantum cryptographic signatures used in blockchain transactions

CREATE TABLE IF NOT EXISTS post_quantum_transaction_signatures (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash TEXT NOT NULL,
    signature_algorithm TEXT NOT NULL, -- e.g., Dilithium, Falcon, SPHINCS+
    signature BYTEA NOT NULL,
    public_key BYTEA NOT NULL,
    key_type TEXT CHECK (key_type IN ('public', 'hybrid', 'threshold')) DEFAULT 'public',
    is_valid BOOLEAN DEFAULT TRUE,
    verified_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_pq_tx_signature_txhash ON post_quantum_transaction_signatures(tx_hash);
CREATE INDEX IF NOT EXISTS idx_pq_signature_algo ON post_quantum_transaction_signatures(signature_algorithm);
CREATE INDEX IF NOT EXISTS idx_pq_signature_validity ON post_quantum_transaction_signatures(is_valid);

COMMENT ON TABLE post_quantum_transaction_signatures IS 'Captures post-quantum secure signatures associated with blockchain transactions for validation and audit.';
