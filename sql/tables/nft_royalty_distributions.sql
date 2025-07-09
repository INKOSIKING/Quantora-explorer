-- Table: nft_royalty_distributions
-- Purpose: Tracks royalty payments to creators and associated stakeholders for NFT secondary sales.

CREATE TABLE IF NOT EXISTS nft_royalty_distributions (
    distribution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_id UUID NOT NULL REFERENCES nft_metadata_index(nft_id) ON DELETE CASCADE,
    transaction_hash TEXT NOT NULL,
    recipient_wallet TEXT NOT NULL,
    royalty_percentage NUMERIC(5, 2) NOT NULL CHECK (royalty_percentage >= 0 AND royalty_percentage <= 100),
    amount_paid NUMERIC(78, 18) NOT NULL CHECK (amount_paid >= 0),
    payment_token TEXT NOT NULL,
    distribution_status TEXT NOT NULL DEFAULT 'pending' CHECK (
        distribution_status IN ('pending', 'completed', 'failed')
    ),
    metadata JSONB DEFAULT '{}'::jsonb,
    distributed_at TIMESTAMPTZ DEFAULT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_royalty_distributions_nft_id ON nft_royalty_distributions(nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_royalty_distributions_recipient ON nft_royalty_distributions(recipient_wallet);
CREATE INDEX IF NOT EXISTS idx_nft_royalty_distributions_status ON nft_royalty_distributions(distribution_status);
CREATE INDEX IF NOT EXISTS idx_nft_royalty_distributions_txhash ON nft_royalty_distributions(transaction_hash);
