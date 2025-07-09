-- ============================================================================
-- 🖼️ Table: nft_metadata_versions
-- 📘 Tracks historical metadata versions for NFTs
-- ============================================================================

CREATE TABLE IF NOT EXISTS nft_metadata_versions (
  version_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id           UUID NOT NULL REFERENCES nfts(nft_id) ON DELETE CASCADE,
  metadata         JSONB NOT NULL,
  metadata_hash    TEXT NOT NULL,
  updated_by       TEXT NOT NULL, -- wallet or user
  update_reason    TEXT,
  version_number   INTEGER NOT NULL,
  is_current       BOOLEAN DEFAULT false,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_metadata_nft_id ON nft_metadata_versions(nft_id);
CREATE INDEX IF NOT EXISTS idx_nft_metadata_current ON nft_metadata_versions(is_current);
CREATE UNIQUE INDEX IF NOT EXISTS idx_nft_metadata_version ON nft_metadata_versions(nft_id, version_number);
