-- =======================================================================
-- 🖼️ Table: nft_metadata_history
-- Description: Historical log of metadata changes for NFTs (auditable)
-- =======================================================================

CREATE TABLE IF NOT EXISTS nft_metadata_history (
    history_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token_id          TEXT NOT NULL,
    contract_address  TEXT NOT NULL,
    previous_metadata JSONB,
    new_metadata      JSONB NOT NULL,
    changed_by        TEXT,
    change_reason     TEXT,
    tx_hash           TEXT,
    block_number      BIGINT,
    changed_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_meta_hist_token ON nft_metadata_history(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_meta_hist_contract ON nft_metadata_history(contract_address);
CREATE INDEX IF NOT EXISTS idx_nft_meta_hist_tx ON nft_metadata_history(tx_hash);
