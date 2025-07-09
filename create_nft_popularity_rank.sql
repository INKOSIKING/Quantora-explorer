-- ============================================================================================
-- 🖼️ Table: nft_popularity_rank
-- Description: Tracks popularity and trending score of NFTs based on on-chain + off-chain metrics.
-- ============================================================================================

CREATE TABLE IF NOT EXISTS nft_popularity_rank (
    rank_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_contract_address  TEXT NOT NULL,
    token_id              TEXT NOT NULL,
    collection_name       TEXT,
    view_count            BIGINT DEFAULT 0,
    mint_count            BIGINT DEFAULT 0,
    transfer_count        BIGINT DEFAULT 0,
    like_count            BIGINT DEFAULT 0,
    comment_count         BIGINT DEFAULT 0,
    social_mentions       INTEGER DEFAULT 0,
    trending_score        NUMERIC(10,4),
    rank_position         INTEGER,
    ranked_at             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_popularity_contract_token ON nft_popularity_rank(nft_contract_address, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_popularity_ranked_at ON nft_popularity_rank(ranked_at);
CREATE INDEX IF NOT EXISTS idx_nft_popularity_score ON nft_popularity_rank(trending_score DESC);
