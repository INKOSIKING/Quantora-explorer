-- Table: nft_token_ownership
-- Description: Tracks ownership and metadata of individual NFTs per collection.

CREATE TABLE IF NOT EXISTS nft_token_ownership (
    id BIGSERIAL PRIMARY KEY,
    token_id TEXT NOT NULL,
    collection_address TEXT NOT NULL,
    owner_address TEXT NOT NULL,
    metadata_uri TEXT,
    minted_block BIGINT,
    burned BOOLEAN DEFAULT FALSE,
    burn_reason TEXT,
    last_transfer_tx_hash TEXT,
    last_transfer_block BIGINT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(token_id, collection_address)
);

CREATE INDEX IF NOT EXISTS idx_nft_owner ON nft_token_ownership(owner_address);
CREATE INDEX IF NOT EXISTS idx_nft_token_id ON nft_token_ownership(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_collection ON nft_token_ownership(collection_address);
CREATE INDEX IF NOT EXISTS idx_nft_burned ON nft_token_ownership(burned);

COMMENT ON TABLE nft_token_ownership IS 'Tracks who owns which NFT tokens and relevant transfer/burn metadata.';
