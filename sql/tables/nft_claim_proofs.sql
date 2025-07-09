-- Table: nft_claim_proofs
-- Purpose: Stores verifiable cryptographic proofs for NFT claims (e.g., airdrops, access rights)

CREATE TABLE IF NOT EXISTS nft_claim_proofs (
    proof_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    claimant_address TEXT NOT NULL,
    nft_id TEXT NOT NULL,
    contract_address TEXT NOT NULL,
    claim_hash TEXT NOT NULL UNIQUE, -- hash of claim data to verify uniqueness
    merkle_root TEXT,
    merkle_proof JSONB,
    zk_proof JSONB,
    proof_type TEXT NOT NULL CHECK (proof_type IN ('merkle', 'zk', 'hybrid')),
    verified BOOLEAN NOT NULL DEFAULT FALSE,
    verified_at TIMESTAMPTZ,
    verifier_node TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_claim_proofs_claimant ON nft_claim_proofs(claimant_address);
CREATE INDEX IF NOT EXISTS idx_nft_claim_proofs_nft ON nft_claim_proofs(nft_id);
