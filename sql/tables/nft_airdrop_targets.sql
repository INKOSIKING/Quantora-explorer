-- Table: nft_airdrop_targets
-- Purpose: Records addresses eligible for NFT airdrops, their allocation, and distribution status.

CREATE TABLE IF NOT EXISTS nft_airdrop_targets (
    target_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id TEXT NOT NULL,
    recipient_address TEXT NOT NULL,
    nft_contract TEXT NOT NULL,
    nft_token_id TEXT,
    allocation_amount INTEGER DEFAULT 1 CHECK (allocation_amount >= 0),
    claim_status TEXT NOT NULL DEFAULT 'pending' CHECK (claim_status IN ('pending', 'claimed', 'expired', 'failed')),
    claim_deadline TIMESTAMPTZ,
    claimed_at TIMESTAMPTZ,
    claim_tx_hash TEXT,
    eligibility_proof JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_airdrop_targets_campaign ON nft_airdrop_targets(campaign_id);
CREATE INDEX IF NOT EXISTS idx_airdrop_targets_recipient ON nft_airdrop_targets(recipient_address);
