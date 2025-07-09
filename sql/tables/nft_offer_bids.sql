-- Table: nft_offer_bids
-- Purpose: Tracks all offers and bids made on NFTs in the Quantora NFT marketplace

CREATE TABLE IF NOT EXISTS nft_offer_bids (
    bid_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_id UUID NOT NULL REFERENCES nft_metadata_index(nft_id) ON DELETE CASCADE,
    bidder_wallet_address TEXT NOT NULL,
    offer_price NUMERIC(78, 18) NOT NULL CHECK (offer_price > 0),
    payment_token TEXT NOT NULL, -- e.g. 'ETH', 'QNT', 'USDC'
    bid_status TEXT NOT NULL DEFAULT 'open' CHECK (
        bid_status IN ('open', 'cancelled', 'accepted', 'expired', 'rejected')
    ),
    expiration_timestamp TIMESTAMPTZ,
    transaction_hash TEXT UNIQUE,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_offer_bids_nft_id ON nft_offer_bids(nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_offer_bids_bidder ON nft_offer_bids(bidder_wallet_address);
CREATE INDEX IF NOT EXISTS idx_nft_offer_bids_status ON nft_offer_bids(bid_status);
CREATE INDEX IF NOT EXISTS idx_nft_offer_bids_created_at ON nft_offer_bids(created_at);
