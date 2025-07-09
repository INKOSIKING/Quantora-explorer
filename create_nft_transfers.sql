-- ====================================================================================
-- �� Table: nft_transfers
-- Description: Tracks ownership transfers for NFTs between addresses
-- ====================================================================================

CREATE TABLE IF NOT EXISTS nft_transfers (
    transfer_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_id             UUID NOT NULL,
    collection_id        UUID NOT NULL,
    from_address         TEXT NOT NULL,
    to_address           TEXT NOT NULL,
    transfer_tx_hash     TEXT UNIQUE NOT NULL,
    transfer_block_num   BIGINT NOT NULL,
    transfer_timestamp   TIMESTAMPTZ NOT NULL,
    gas_used             BIGINT,
    method               TEXT,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_nft_token FOREIGN KEY (token_id) REFERENCES nft_metadata(token_id),
    CONSTRAINT fk_nft_collection FOREIGN KEY (collection_id) REFERENCES nft_collections(collection_id)
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_transfers_token ON nft_transfers(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_transfers_from_addr ON nft_transfers(from_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfers_to_addr ON nft_transfers(to_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_block_num ON nft_transfers(transfer_block_num);
