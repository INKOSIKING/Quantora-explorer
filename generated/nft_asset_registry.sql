-- ============================================================================
-- 🖼️ Table: nft_asset_registry
-- 📘 Registers every unique NFT ever minted in the Quantora blockchain
-- ============================================================================

CREATE TABLE IF NOT EXISTS nft_asset_registry (
  nft_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_id              TEXT NOT NULL,
  contract_address      TEXT NOT NULL,
  creator_address       TEXT NOT NULL,
  current_owner_address TEXT NOT NULL,
  metadata_uri          TEXT,
  ipfs_cid              TEXT,
  name                  TEXT,
  description           TEXT,
  image_url             TEXT,
  category              TEXT, -- e.g., art, collectible, game item, ticket
  minted_at_block       BIGINT NOT NULL,
  burned_at_block       BIGINT,
  is_active             BOOLEAN DEFAULT TRUE,
  on_chain              BOOLEAN DEFAULT TRUE,
  chain_id              TEXT DEFAULT 'quantora-mainnet',
  created_at            TIMESTAMPTZ DEFAULT now(),
  updated_at            TIMESTAMPTZ
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_contract_token ON nft_asset_registry(contract_address, token_id);
CREATE INDEX IF NOT EXISTS idx_nft_creator ON nft_asset_registry(creator_address);
CREATE INDEX IF NOT EXISTS idx_nft_owner ON nft_asset_registry(current_owner_address);
CREATE INDEX IF NOT EXISTS idx_nft_active ON nft_asset_registry(is_active);
