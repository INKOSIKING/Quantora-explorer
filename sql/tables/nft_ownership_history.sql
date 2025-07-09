-- Table: nft_ownership_history
-- Purpose: Tracks every transfer and ownership change of NFTs from minting to the present.

CREATE TABLE IF NOT EXISTS nft_ownership_history (
    ownership_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_contract TEXT NOT NULL,
    token_id TEXT NOT NULL,
    from_address TEXT,
    to_address TEXT NOT NULL,
    tx_hash TEXT NOT NULL,
    block_number BIGINT NOT NULL,
    transferred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    is_mint BOOLEAN NOT NULL DEFAULT FALSE,
    is_burn BOOLEAN NOT NULL DEFAULT FALSE,
    platform TEXT DEFAULT NULL,
    metadata JSONB DEFAULT '{}'::jsonb
);

-- Indexes for efficient query access
CREATE INDEX IF NOT EXISTS idx_nft_ownership_token ON nft_ownership_history(nft_contract, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_ownership_from_to ON nft_ownership_history(from_address, to_address);
CREATE INDEX IF NOT EXISTS idx_nft_ownership_tx ON nft_ownership_history(tx_hash);
