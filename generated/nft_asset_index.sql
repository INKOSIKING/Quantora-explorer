-- =============================================================================
-- 🖼️ Table: nft_asset_index
-- 📘 Tracks all NFTs on-chain, their metadata, and ownership
-- =============================================================================

CREATE TABLE IF NOT EXISTS nft_asset_index (
  nft_id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address        TEXT NOT NULL,
  token_id                TEXT NOT NULL,
  creator_address         TEXT NOT NULL,
  current_owner           TEXT NOT NULL,
  original_minter         TEXT,
  token_standard          TEXT NOT NULL CHECK (token_standard IN ('ERC721', 'ERC1155')),
  created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_transferred_at     TIMESTAMPTZ,
  metadata_uri            TEXT,
  image_url               TEXT,
  traits                  JSONB,
  on_chain_metadata       JSONB,
  status                  TEXT DEFAULT 'active' CHECK (status IN ('active', 'burned', 'frozen')),
  collection_name         TEXT,
  royalty_info            JSONB,
  mint_transaction_hash   TEXT,
  chain_id                TEXT NOT NULL,
  UNIQUE(contract_address, token_id)
);

-- ⚡ Indexes
CREATE INDEX IF NOT EXISTS idx_nft_owner ON nft_asset_index(current_owner);
CREATE INDEX IF NOT EXISTS idx_nft_contract_token ON nft_asset_index(contract_address, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_status ON nft_asset_index(status);
CREATE INDEX IF NOT EXISTS idx_nft_creator ON nft_asset_index(creator_address);
