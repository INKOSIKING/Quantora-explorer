-- ====================================================================================
-- 🔥 Table: nft_burn_events
-- Description: Records all NFT burn events — when an NFT is destroyed or sent to a burn address.
-- ====================================================================================

CREATE TABLE IF NOT EXISTS nft_burn_events (
    burn_event_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_id             UUID NOT NULL,
    collection_id        UUID NOT NULL,
    owner_address        TEXT NOT NULL,
    burn_tx_hash         TEXT UNIQUE NOT NULL,
    burn_block_num       BIGINT NOT NULL,
    burn_timestamp       TIMESTAMPTZ NOT NULL,
    reason               TEXT,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_burn_token FOREIGN KEY (token_id) REFERENCES nft_metadata(token_id),
    CONSTRAINT fk_burn_collection FOREIGN KEY (collection_id) REFERENCES nft_collections(collection_id)
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_burn_token ON nft_burn_events(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_burn_owner ON nft_burn_events(owner_address);
CREATE INDEX IF NOT EXISTS idx_nft_burn_block_num ON nft_burn_events(burn_block_num);
