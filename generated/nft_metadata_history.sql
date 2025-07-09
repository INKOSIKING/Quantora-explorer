-- =============================================================
-- 🖼️ Table: nft_metadata_history
-- 📜 Tracks changes to NFT metadata across mints, updates, and forks
-- =============================================================

CREATE TABLE IF NOT EXISTS nft_metadata_history (
  metadata_history_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id                UUID NOT NULL REFERENCES nfts(nft_id) ON DELETE CASCADE,
  block_number          BIGINT NOT NULL,
  tx_hash               TEXT NOT NULL,
  metadata_uri          TEXT NOT NULL,
  metadata_content      JSONB NOT NULL,
  update_reason         TEXT,
  changed_fields        TEXT[],
  signature_verified    BOOLEAN NOT NULL DEFAULT FALSE,
  updated_by_address    TEXT NOT NULL,
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🗂️ Indexes
CREATE INDEX IF NOT EXISTS idx_nft_metadata_history_nft_id ON nft_metadata_history(nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_metadata_history_tx_hash ON nft_metadata_history(tx_hash);
CREATE INDEX IF NOT EXISTS idx_nft_metadata_history_block ON nft_metadata_history(block_number);
