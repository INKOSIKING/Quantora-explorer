-- Table: order_book_snapshots
-- Purpose: Captures periodic full snapshots of the order book (both bids and asks)

CREATE TABLE IF NOT EXISTS order_book_snapshots (
    snapshot_id           BIGSERIAL PRIMARY KEY,
    market_symbol         TEXT NOT NULL, -- e.g., BTC/USDT
    block_height          BIGINT NOT NULL,
    captured_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    bids                  JSONB NOT NULL, -- [{price, quantity}]
    asks                  JSONB NOT NULL, -- [{price, quantity}]
    depth_level           INTEGER NOT NULL DEFAULT 50, -- How deep into the book this snapshot captures
    source_node_id        UUID,
    metadata              JSONB DEFAULT '{}'::JSONB
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_order_book_snapshots_market_time ON order_book_snapshots(market_symbol, captured_at DESC);
CREATE INDEX IF NOT EXISTS idx_order_book_snapshots_block ON order_book_snapshots(block_height);
