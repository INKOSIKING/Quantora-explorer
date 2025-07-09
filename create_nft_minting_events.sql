-- ==================================================================================
-- 🪙 Table: nft_minting_events
-- Description: Logs all minting events per NFT token with creator and recipient info
-- ==================================================================================

CREATE TABLE IF NOT EXISTS nft_minting_events (
    mint_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_id             UUID NOT NULL,
    collection_id        UUID NOT NULL,
    minter_address       TEXT NOT NULL,
    recipient_address    TEXT NOT NULL,
    mint_tx_hash         TEXT UNIQUE NOT NULL,
    mint_block_number    BIGINT NOT NULL,
    mint_timestamp       TIMESTAMPTZ NOT NULL,
    metadata_uri         TEXT,
    creator_fee_percent  NUMERIC(5,2),
    gas_used             BIGINT,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_collection FOREIGN KEY (collection_id) REFERENCES nft_collections(collection_id)
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_minting_events_token ON nft_minting_events(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_minting_events_minter ON nft_minting_events(minter_address);
CREATE INDEX IF NOT EXISTS idx_nft_minting_block_number ON nft_minting_events(mint_block_number);
