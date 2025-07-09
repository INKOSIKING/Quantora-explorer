-- ==========================================================================
-- 🎨 Table: nft_transfer_events
-- Description: Historical log of all NFT transfer events
-- ==========================================================================

CREATE TABLE IF NOT EXISTS nft_transfer_events (
    event_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_contract       TEXT NOT NULL,
    token_id           TEXT NOT NULL,
    from_address       TEXT,
    to_address         TEXT,
    transaction_hash   TEXT NOT NULL,
    block_number       BIGINT NOT NULL,
    timestamp          TIMESTAMPTZ NOT NULL,
    event_type         TEXT CHECK (event_type IN ('mint', 'transfer', 'burn')),
    tx_fee             NUMERIC(38, 2),
    marketplace        TEXT,
    inserted_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_transfer_contract ON nft_transfer_events(nft_contract);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_token_id ON nft_transfer_events(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_from ON nft_transfer_events(from_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_to ON nft_transfer_events(to_address);
CREATE INDEX IF NOT EXISTS idx_nft_transfer_tx_hash ON nft_transfer_events(transaction_hash);
