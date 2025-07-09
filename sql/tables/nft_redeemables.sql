-- Table: nft_redeemables
-- Purpose: Links NFTs to redeemable benefits, both digital and physical (merch, event access, etc.)

CREATE TABLE IF NOT EXISTS nft_redeemables (
    redeemable_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_token_id TEXT NOT NULL,
    contract_address TEXT NOT NULL,
    redeemable_type TEXT NOT NULL CHECK (redeemable_type IN ('physical', 'digital', 'event', 'subscription', 'other')),
    description TEXT,
    redemption_url TEXT,
    redeem_status TEXT NOT NULL CHECK (redeem_status IN ('available', 'redeemed', 'expired', 'cancelled')),
    redeemed_at TIMESTAMPTZ,
    redeemed_by TEXT,
    expires_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    UNIQUE(nft_token_id, contract_address)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_nft_redeemables_status ON nft_redeemables(redeem_status);
CREATE INDEX IF NOT EXISTS idx_nft_redeemables_expiry ON nft_redeemables(expires_at);
