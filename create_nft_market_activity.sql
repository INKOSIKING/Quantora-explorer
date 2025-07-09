-- ========================================================================================
-- 📈 Table: nft_market_activity
-- Description: Captures real-time and historical market activity for NFTs (sales, bids, etc).
-- ========================================================================================

CREATE TABLE IF NOT EXISTS nft_market_activity (
    activity_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_id               UUID NOT NULL,
    collection_address   TEXT NOT NULL,
    token_id             TEXT NOT NULL,
    event_type           TEXT NOT NULL CHECK (event_type IN ('listing', 'sale', 'bid', 'cancel', 'transfer')),
    marketplace          TEXT,
    price_eth            NUMERIC(20,8),
    price_usd            NUMERIC(20,2),
    buyer_address        TEXT,
    seller_address       TEXT,
    tx_hash              TEXT,
    block_number         BIGINT,
    event_timestamp      TIMESTAMPTZ NOT NULL,
    metadata             JSONB,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_market_token ON nft_market_activity(collection_address, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_market_event_type ON nft_market_activity(event_type);
CREATE INDEX IF NOT EXISTS idx_nft_market_timestamp ON nft_market_activity(event_timestamp);
CREATE INDEX IF NOT EXISTS idx_nft_market_price_usd ON nft_market_activity(price_usd DESC);
