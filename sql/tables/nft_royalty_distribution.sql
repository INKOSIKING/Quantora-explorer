-- Table: nft_royalty_distribution
-- Purpose: Tracks royalty entitlements and payouts across stakeholders on NFT resales

CREATE TABLE IF NOT EXISTS nft_royalty_distribution (
    royalty_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    transaction_hash TEXT NOT NULL,
    recipient_address TEXT NOT NULL,
    royalty_percentage NUMERIC(5, 2) NOT NULL CHECK (royalty_percentage >= 0 AND royalty_percentage <= 100),
    royalty_amount_wei NUMERIC(78, 0) NOT NULL CHECK (royalty_amount_wei >= 0),
    paid_at TIMESTAMPTZ,
    payment_status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'paid', 'failed'
    payment_tx_hash TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, transaction_hash, recipient_address)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_royalty_token ON nft_royalty_distribution(nft_token_id);
CREATE INDEX IF NOT EXISTS idx_royalty_recipient ON nft_royalty_distribution(recipient_address);
CREATE INDEX IF NOT EXISTS idx_royalty_status ON nft_royalty_distribution(payment_status);
