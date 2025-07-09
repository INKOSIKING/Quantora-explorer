-- Table: nft_authenticity_proofs
-- Purpose: Stores verifiable authenticity metadata and proofs for NFTs

CREATE TABLE IF NOT EXISTS nft_authenticity_proofs (
    proof_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    proof_type TEXT NOT NULL, -- e.g., 'zkSNARK', 'certificate', 'oracle_attestation'
    proof_source TEXT NOT NULL, -- e.g., 'IPFS hash', 'oracle URL', 'L2 chain'
    proof_hash TEXT NOT NULL,
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    verified_at TIMESTAMPTZ,
    verifier_identity TEXT,
    issued_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, proof_hash)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_proof_type ON nft_authenticity_proofs(proof_type);
CREATE INDEX IF NOT EXISTS idx_nft_verifier ON nft_authenticity_proofs(verifier_identity);
