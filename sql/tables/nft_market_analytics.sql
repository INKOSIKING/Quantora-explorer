-- Table: nft_market_analytics
-- Purpose: Stores analytics, trends, and performance data on NFT sales, trades, and liquidity.

CREATE TABLE IF NOT EXISTS nft_market_analytics (
    analytics_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id UUID REFERENCES nft_collections(collection_id) ON DELETE CASCADE,
    token_contract TEXT NOT NULL,
    time_bucket INTERVAL NOT NULL, -- e.g., '1 hour', '1 day'
    window_start TIMESTAMPTZ NOT NULL,
    window_end TIMESTAMPTZ NOT NULL,
    
    total_sales BIGINT DEFAULT 0,
    total_volume_eth NUMERIC(36, 18) DEFAULT 0,
    average_price_eth NUMERIC(36, 18),
    median_price_eth NUMERIC(36, 18),
    floor_price_eth NUMERIC(36, 18),
    unique_buyers BIGINT DEFAULT 0,
    unique_sellers BIGINT DEFAULT 0,
    token_count_sold BIGINT DEFAULT 0,

    liquidity_score NUMERIC(10, 4),
    trend_score NUMERIC(10, 4),
    engagement_score NUMERIC(10, 4),
    volatility_score NUMERIC(10, 4),
    
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_nft_market_analytics_collection_time ON nft_market_analytics(collection_id, window_start);
CREATE INDEX IF NOT EXISTS idx_nft_market_analytics_contract_time ON nft_market_analytics(token_contract, window_start);
