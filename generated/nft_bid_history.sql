-- ============================================================================
-- 📈 Table: nft_bid_history
-- 📘 Logs every bid submitted on an NFT auction
-- ============================================================================

CREATE TABLE IF NOT EXISTS nft_bid_history (
  bid_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auction_id        UUID NOT NULL,
  bidder_address    TEXT NOT NULL,
  bid_amount        NUMERIC(38, 18) NOT NULL CHECK (bid_amount > 0),
  bid_currency      TEXT NOT NULL DEFAULT 'QTC',
  bid_time          TIMESTAMPTZ NOT NULL DEFAULT now(),
  tx_hash           TEXT,
  block_number      BIGINT,
  status            TEXT DEFAULT 'valid', -- valid, overbid, withdrawn, refunded, failed
  created_at        TIMESTAMPTZ DEFAULT now()
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_bid_history_auction_id ON nft_bid_history(auction_id);
CREATE INDEX IF NOT EXISTS idx_bid_history_bidder ON nft_bid_history(bidder_address);
CREATE INDEX IF NOT EXISTS idx_bid_history_status ON nft_bid_history(status);
CREATE INDEX IF NOT EXISTS idx_bid_history_time ON nft_bid_history(bid_time);

-- 🔗 Foreign Keys (deferred until enforcement phase)
-- ALTER TABLE nft_bid_history ADD CONSTRAINT fk_auction_id FOREIGN KEY (auction_id) REFERENCES nft_auctions(auction_id);
