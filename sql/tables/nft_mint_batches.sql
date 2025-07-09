-- Table: nft_mint_batches
-- Purpose: Represents grouped NFT minting operations (e.g., collections, drop batches, campaigns).

CREATE TABLE IF NOT EXISTS nft_mint_batches (
    batch_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_name TEXT NOT NULL,
    collection_slug TEXT NOT NULL,
    creator_address TEXT NOT NULL,
    nft_contract_address TEXT NOT NULL,
    total_nfts INTEGER NOT NULL CHECK (total_nfts > 0),
    minted_count INTEGER DEFAULT 0 CHECK (minted_count >= 0),
    mint_strategy TEXT NOT NULL CHECK (mint_strategy IN ('on-demand', 'pre-mint', 'lazy-mint')),
    metadata_uri TEXT,
    status TEXT NOT NULL CHECK (status IN ('draft', 'active', 'paused', 'completed', 'cancelled')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(collection_slug, nft_contract_address)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_mint_batches_creator ON nft_mint_batches(creator_address);
CREATE INDEX IF NOT EXISTS idx_mint_batches_status ON nft_mint_batches(status);
