-- =============================================================================
-- 🖼️ Table: nft_marketplace_listings
-- 🛒 Tracks NFT listings, bids, prices, expirations, and marketplace metadata
-- =============================================================================

CREATE TABLE IF NOT EXISTS nft_marketplace_listings (
  id                  BIGSERIAL PRIMARY KEY,
  nft_id              TEXT NOT NULL,
  token_id            TEXT NOT NULL,
  collection_address  TEXT NOT NULL,
  marketplace         TEXT NOT NULL,
  chain_id            TEXT NOT NULL,
  seller_address      TEXT NOT NULL,
  listing_type        TEXT CHECK (listing_type IN ('fixed', 'auction', 'offer')),
  price               NUMERIC(38, 18) NOT NULL,
  currency            TEXT NOT NULL DEFAULT 'ETH',
  reserve_price       NUMERIC(38, 18),
  expiration_time     TIMESTAMPTZ,
  status              TEXT CHECK (status IN ('active', 'sold', 'cancelled', 'expired')) NOT NULL DEFAULT 'active',
  metadata_snapshot   JSONB,
  tx_hash             TEXT,
  block_number        BIGINT,
  listed_at           TIMESTAMPTZ DEFAULT now(),
  updated_at          TIMESTAMPTZ DEFAULT now()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_listings_collection ON nft_marketplace_listings(collection_address);
CREATE INDEX IF NOT EXISTS idx_nft_listings_market_status ON nft_marketplace_listings(marketplace, status);
CREATE INDEX IF NOT EXISTS idx_nft_listings_token ON nft_marketplace_listings(token_id, nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_listings_expiry ON nft_marketplace_listings(expiration_time);
