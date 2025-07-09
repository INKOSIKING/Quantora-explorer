-- ============================================================================
-- 🎨 Table: nft_auctions
-- 📘 Manages NFT auctions and bid lifecycle on-chain
-- ============================================================================

CREATE TABLE IF NOT EXISTS nft_auctions (
  auction_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id             UUID NOT NULL,
  seller_address     TEXT NOT NULL,
  starting_price     NUMERIC(38, 18) NOT NULL CHECK (starting_price >= 0),
  reserve_price      NUMERIC(38, 18),
  current_bid        NUMERIC(38, 18),
  current_bidder     TEXT,
  bid_currency       TEXT NOT NULL DEFAULT 'QTC',
  auction_status     TEXT NOT NULL DEFAULT 'pending', -- pending, active, completed, cancelled
  start_time         TIMESTAMPTZ NOT NULL,
  end_time           TIMESTAMPTZ NOT NULL,
  settlement_tx      TEXT,
  created_at         TIMESTAMPTZ DEFAULT now(),
  updated_at         TIMESTAMPTZ
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_auctions_status ON nft_auctions(auction_status);
CREATE INDEX IF NOT EXISTS idx_nft_auctions_nft_id ON nft_auctions(nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_auctions_seller ON nft_auctions(seller_address);
CREATE INDEX IF NOT EXISTS idx_nft_auctions_end_time ON nft_auctions(end_time);
