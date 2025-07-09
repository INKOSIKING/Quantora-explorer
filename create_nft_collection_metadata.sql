-- ================================================================================
-- 🖼️ Table: nft_collection_metadata
-- Description: Stores metadata for NFT collections deployed on the Quantora chain
-- ================================================================================

CREATE TABLE IF NOT EXISTS nft_collection_metadata (
    collection_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address     TEXT NOT NULL UNIQUE,
    collection_name      TEXT NOT NULL,
    creator_address      TEXT NOT NULL,
    description          TEXT,
    external_link        TEXT,
    image_url            TEXT,
    total_supply         BIGINT,
    royalty_percent      NUMERIC(5,2) CHECK (royalty_percent >= 0 AND royalty_percent <= 100),
    is_verified          BOOLEAN DEFAULT FALSE,
    category             TEXT,
    tags                 TEXT[],
    created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_coll_creator ON nft_collection_metadata(creator_address);
CREATE INDEX IF NOT EXISTS idx_nft_coll_name ON nft_collection_metadata(collection_name);
