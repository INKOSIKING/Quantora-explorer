-- ==============================================================================
-- Table: nft_mint_entropy
-- Purpose: Track randomness and entropy sources used during NFT minting
-- Use Case: Ensures transparent and fair generation of on-chain or off-chain NFTs
-- ==============================================================================

CREATE TABLE IF NOT EXISTS nft_mint_entropy (
  entropy_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id             UUID NOT NULL,
  mint_tx_hash       VARCHAR(66) NOT NULL,
  entropy_source     TEXT NOT NULL, -- e.g., chainlink_vrf, local_rng, zk_random
  entropy_value      TEXT NOT NULL, -- base64 or hex encoded
  entropy_hash       VARCHAR(128) UNIQUE NOT NULL, -- SHA-256 or similar
  verified           BOOLEAN DEFAULT FALSE,
  verified_at        TIMESTAMPTZ,
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_nft_entropy_nft_id ON nft_mint_entropy(nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_entropy_tx ON nft_mint_entropy(mint_tx_hash);
CREATE INDEX IF NOT EXISTS idx_nft_entropy_verified ON nft_mint_entropy(verified);

-- === Constraints ===
ALTER TABLE nft_mint_entropy
  ADD CONSTRAINT chk_entropy_hash_format
    CHECK (entropy_hash ~ '^[a-fA-F0-9]{64,128}$');
