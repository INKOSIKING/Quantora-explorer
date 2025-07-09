-- ==================================================================================
-- 🎨 Table: nft_collections
-- Description: Stores metadata and control flags for NFT collections on-chain
-- ==================================================================================

CREATE TABLE IF NOT EXISTS nft_collections (
    collection_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address      TEXT NOT NULL UNIQUE,
    creator_wallet        TEXT NOT NULL,
    name                  TEXT NOT NULL,
    symbol                TEXT NOT NULL,
    description           TEXT,
    category              TEXT,
    total_supply          BIGINT DEFAULT 0,
    is_verified           BOOLEAN DEFAULT FALSE,
    base_uri              TEXT,
    minting_enabled       BOOLEAN DEFAULT TRUE,
    royalty_info          JSONB,
    creation_block_number BIGINT,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_collections_creator ON nft_collections(creator_wallet);
CREATE INDEX IF NOT EXISTS idx_nft_collections_symbol ON nft_collections(symbol);
