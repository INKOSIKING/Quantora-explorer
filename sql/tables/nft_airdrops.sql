-- Table: nft_airdrops
-- Purpose: Records NFT airdrop events, recipients, conditions, and statuses.

CREATE TABLE IF NOT EXISTS nft_airdrops (
    airdrop_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_name TEXT NOT NULL,
    nft_id UUID REFERENCES nft_metadata_index(nft_id) ON DELETE SET NULL,
    recipient_wallet TEXT NOT NULL,
    eligibility_criteria JSONB DEFAULT '{}'::jsonb,
    distributed BOOLEAN NOT NULL DEFAULT FALSE,
    distributed_at TIMESTAMPTZ,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (
        status IN ('pending', 'distributed', 'failed', 'cancelled')
    ),
    airdrop_type TEXT NOT NULL DEFAULT 'single' CHECK (
        airdrop_type IN ('single', 'batch', 'random', 'merkle')
    ),
    metadata JSONB DEFAULT '{}'::jsonb,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_airdrops_wallet ON nft_airdrops(recipient_wallet);
CREATE INDEX IF NOT EXISTS idx_nft_airdrops_status ON nft_airdrops(status);
CREATE INDEX IF NOT EXISTS idx_nft_airdrops_nft_id ON nft_airdrops(nft_id);
