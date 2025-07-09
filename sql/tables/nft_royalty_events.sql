-- Table: nft_royalty_events
-- Purpose: Records royalty payments distributed to NFT creators during secondary market sales.

CREATE TABLE IF NOT EXISTS nft_royalty_events (
    royalty_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_contract TEXT NOT NULL,
    token_id TEXT NOT NULL,
    sale_tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    creator_address TEXT NOT NULL,
    payer_address TEXT NOT NULL,
    marketplace TEXT,
    royalty_amount NUMERIC(78, 0) NOT NULL CHECK (royalty_amount >= 0),
    royalty_percentage NUMERIC(5, 2) NOT NULL CHECK (royalty_percentage >= 0 AND royalty_percentage <= 100),
    currency TEXT NOT NULL DEFAULT 'ETH',
    paid_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_royalty_nft ON nft_royalty_events(nft_contract, token_id);
CREATE INDEX IF NOT EXISTS idx_royalty_creator ON nft_royalty_events(creator_address);
CREATE INDEX IF NOT EXISTS idx_royalty_tx_hash ON nft_royalty_events(sale_tx_hash);
