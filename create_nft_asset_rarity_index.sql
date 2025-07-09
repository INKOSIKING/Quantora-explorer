-- ===============================================================================================
-- 🌟 Table: nft_asset_rarity_index
-- Description: Stores computed rarity metrics and trait analysis for NFTs to support rankings.
-- ===============================================================================================

CREATE TABLE IF NOT EXISTS nft_asset_rarity_index (
    rarity_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_name        TEXT NOT NULL,
    contract_address       TEXT NOT NULL,
    token_id               TEXT NOT NULL,
    trait_hash             TEXT,
    trait_details          JSONB,
    rarity_score           NUMERIC(10,4) NOT NULL,
    percentile_rank        NUMERIC(6,2),
    market_cap_usd         NUMERIC(30,2),
    floor_price_eth        NUMERIC(20,8),
    last_evaluated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    inserted_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_rarity_token ON nft_asset_rarity_index(contract_address, token_id);
CREATE INDEX IF NOT EXISTS idx_rarity_score_rank ON nft_asset_rarity_index(rarity_score DESC);
CREATE INDEX IF NOT EXISTS idx_rarity_collection ON nft_asset_rarity_index(collection_name);
