-- Table: nft_collection_registry
-- Description: Stores metadata and management info for NFT collections deployed on-chain.

CREATE TABLE IF NOT EXISTS nft_collection_registry (
    id BIGSERIAL PRIMARY KEY,
    collection_address TEXT UNIQUE NOT NULL,
    creator_address TEXT NOT NULL,
    name TEXT NOT NULL,
    symbol TEXT NOT NULL,
    base_uri TEXT,
    total_supply BIGINT DEFAULT 0,
    chain_id TEXT NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_block BIGINT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_nft_creator ON nft_collection_registry(creator_address);
CREATE INDEX IF NOT EXISTS idx_nft_verified ON nft_collection_registry(verified);
CREATE INDEX IF NOT EXISTS idx_nft_chain_id ON nft_collection_registry(chain_id);

COMMENT ON TABLE nft_collection_registry IS 'Registry for NFT collections deployed on the chain, with creator, supply, and URI metadata.';
