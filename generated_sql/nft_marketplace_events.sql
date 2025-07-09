-- Table: nft_marketplace_events
-- Description: Captures event activity on NFT marketplaces: listings, bids, purchases, etc.

CREATE TABLE IF NOT EXISTS nft_marketplace_events (
    id BIGSERIAL PRIMARY KEY,
    event_type TEXT NOT NULL CHECK (event_type IN ('listed', 'delisted', 'bid', 'cancel_bid', 'sold', 'transferred')),
    marketplace TEXT NOT NULL,
    collection_address TEXT NOT NULL,
    token_id TEXT NOT NULL,
    seller_address TEXT,
    buyer_address TEXT,
    price NUMERIC(78, 0),
    currency TEXT,
    tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    event_timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB,
    UNIQUE(event_type, tx_hash, token_id, block_number)
);

CREATE INDEX IF NOT EXISTS idx_nft_mkt_event_type ON nft_marketplace_events(event_type);
CREATE INDEX IF NOT EXISTS idx_nft_mkt_collection_token ON nft_marketplace_events(collection_address, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_mkt_tx_hash ON nft_marketplace_events(tx_hash);
CREATE INDEX IF NOT EXISTS idx_nft_mkt_event_time ON nft_marketplace_events(event_timestamp);

COMMENT ON TABLE nft_marketplace_events IS 'Logs NFT marketplace activity including sales, bids, and listings.';
