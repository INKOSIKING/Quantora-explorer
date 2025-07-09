-- Table: nft_batch_minting
-- Description: Tracks batched NFT minting operations including metadata, execution status, and sources.

CREATE TABLE IF NOT EXISTS nft_batch_minting (
    batch_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_wallet_address TEXT NOT NULL,
    total_nfts INTEGER NOT NULL,
    metadata_uri TEXT,
    execution_status TEXT NOT NULL DEFAULT 'pending', -- pending | processing | completed | failed
    minting_tx_hash TEXT,
    scheduled_at TIMESTAMPTZ DEFAULT now(),
    executed_at TIMESTAMPTZ,
    failure_reason TEXT,
    mint_type TEXT DEFAULT 'bulk', -- single | bulk | programmatic
    originating_dapp TEXT,
    estimated_gas NUMERIC(20,8),
    actual_gas_used NUMERIC(20,8),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_nft_batch_creator ON nft_batch_minting(creator_wallet_address);
CREATE INDEX IF NOT EXISTS idx_nft_batch_status ON nft_batch_minting(execution_status);
CREATE INDEX IF NOT EXISTS idx_nft_minting_time ON nft_batch_minting(scheduled_at);

COMMENT ON TABLE nft_batch_minting IS 'Logs mass NFT minting sessions and their metadata, used for batch diagnostics and DApp analytics.';
