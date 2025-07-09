-- Table: nft_collection_metadata
-- Purpose: Stores metadata for NFT collections or series

CREATE TABLE IF NOT EXISTS nft_collection_metadata (
    collection_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_address TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    symbol TEXT NOT NULL,
    creator_address TEXT NOT NULL,
    total_supply BIGINT CHECK (total_supply >= 0),
    base_uri TEXT,
    description TEXT,
    cover_image_url TEXT,
    external_url TEXT,
    royalty_basis_points INTEGER CHECK (royalty_basis_points >= 0 AND royalty_basis_points <= 10000),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_collection_creator ON nft_collection_metadata(creator_address);
CREATE INDEX IF NOT EXISTS idx_collection_name ON nft_collection_metadata(name);
