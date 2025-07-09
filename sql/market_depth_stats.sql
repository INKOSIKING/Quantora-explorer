-- Table: market_depth_stats
-- Purpose: Snapshot statistics of market order book depth over time for trading analytics and transparency.

CREATE TABLE IF NOT EXISTS market_depth_stats (
    depth_id               BIGSERIAL PRIMARY KEY,
    trading_pair           TEXT NOT NULL,
    timestamp              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    exchange_source        TEXT NOT NULL, -- e.g. 'Quantora', 'Binance', 'CrossChain'
    bid_depth_total        NUMERIC(32,8) NOT NULL,
    ask_depth_total        NUMERIC(32,8) NOT NULL,
    top_bid_price          NUMERIC(32,8),
    top_ask_price          NUMERIC(32,8),
    bid_ask_spread         NUMERIC(32,8),
    depth_distribution     JSONB DEFAULT '{}'::JSONB, -- optional histogram by price buckets
    created_at             TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for fast lookup
CREATE INDEX IF NOT EXISTS idx_market_depth_pair_time ON market_depth_stats(trading_pair, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_market_depth_exchange ON market_depth_stats(exchange_source);
