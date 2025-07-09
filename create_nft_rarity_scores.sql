-- ====================================================================================
-- 🖼️ Table: nft_rarity_scores
-- Description: Stores rarity calculations, ranks, and traits used to compute NFT uniqueness.
-- ====================================================================================

CREATE TABLE IF NOT EXISTS nft_rarity_scores (
    rarity_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_id               UUID NOT NULL,
    collection_address   TEXT NOT NULL,
    token_id             TEXT NOT NULL,
    rarity_score         NUMERIC(10,4) NOT NULL,
    rank                 INTEGER NOT NULL,
    total_in_collection  INTEGER NOT NULL,
    percentile           NUMERIC(5,2) GENERATED ALWAYS AS ((rank::DECIMAL / total_in_collection) * 100) STORED,
    scoring_factors      JSONB,
    calculated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_rarity_nft_id ON nft_rarity_scores(nft_id);
CREATE INDEX IF NOT EXISTS idx_rarity_collection_token ON nft_rarity_scores(collection_address, token_id);
CREATE INDEX IF NOT EXISTS idx_rarity_score ON nft_rarity_scores(rarity_score DESC);
