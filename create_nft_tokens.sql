-- ============================================================
-- 🎨 Table: nft_tokens
-- Description: Tracks individual NFTs within collections
-- ============================================================

CREATE TABLE IF NOT EXISTS nft_tokens (
    token_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id        UUID NOT NULL REFERENCES nft_collections(collection_id) ON DELETE CASCADE,
    token_index          BIGINT NOT NULL,
    owner_address        TEXT NOT NULL,
    metadata_uri         TEXT,
    image_url            TEXT,
    name                 TEXT,
    description          TEXT,
    attributes           JSONB,
    minted_at            TIMESTAMPTZ DEFAULT NOW(),
    last_transferred_at  TIMESTAMPTZ,
    burn_status          BOOLEAN DEFAULT FALSE,
    burn_reason          TEXT,
    created_at           TIMESTAMPTZ DEFAULT NOW(),
    updated_at           TIMESTAMPTZ DEFAULT NOW(),

    UNIQUE(collection_id, token_index)
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_tokens_owner ON nft_tokens(owner_address);
CREATE INDEX IF NOT EXISTS idx_nft_tokens_collection_token ON nft_tokens(collection_id, token_index);
CREATE INDEX IF NOT EXISTS idx_nft_tokens_burned ON nft_tokens(burn_status);
