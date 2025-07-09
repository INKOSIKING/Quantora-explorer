-- ========================================================================
-- 🎨 Table: nft_asset_lineage
-- 📘 Tracks the origin, transfer path, and historical metadata of NFTs
-- ========================================================================

CREATE TABLE IF NOT EXISTS nft_asset_lineage (
  lineage_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id               UUID NOT NULL,  -- Links to core NFT record
  originating_contract TEXT NOT NULL,
  mint_tx_hash         TEXT NOT NULL,
  original_owner       TEXT NOT NULL,
  transfer_chain       JSONB NOT NULL, -- Ordered array of transfers
  current_owner        TEXT NOT NULL,
  burn_status          BOOLEAN DEFAULT FALSE,
  last_transfer_tx     TEXT,
  lineage_notes        TEXT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📊 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_lineage_id ON nft_asset_lineage(nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_owner ON nft_asset_lineage(current_owner);
CREATE INDEX IF NOT EXISTS idx_nft_origin ON nft_asset_lineage(originating_contract);
