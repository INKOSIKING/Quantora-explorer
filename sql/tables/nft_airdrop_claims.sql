-- Table: nft_airdrop_claims
-- Purpose: Manages airdrop eligibility, claim status, and tracking for NFT campaigns.

CREATE TABLE IF NOT EXISTS nft_airdrop_claims (
    claim_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    airdrop_campaign_id UUID NOT NULL,
    recipient_address TEXT NOT NULL,
    nft_contract TEXT NOT NULL,
    token_id TEXT NOT NULL,
    claim_status TEXT NOT NULL CHECK (claim_status IN ('unclaimed', 'claimed', 'expired', 'revoked')),
    claim_deadline TIMESTAMPTZ NOT NULL,
    claimed_at TIMESTAMPTZ,
    tx_hash TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_airdrop_recipient_status ON nft_airdrop_claims(recipient_address, claim_status);
CREATE INDEX IF NOT EXISTS idx_airdrop_campaign_id ON nft_airdrop_claims(airdrop_campaign_id);
