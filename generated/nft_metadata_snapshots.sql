-- ===================================================
-- 🧬 Table: nft_metadata_snapshots
-- 📌 Immutable snapshot history of NFT metadata state
-- ===================================================

CREATE TABLE IF NOT EXISTS nft_metadata_snapshots (
  snapshot_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nft_id                UUID NOT NULL REFERENCES nft_assets(nft_id) ON DELETE CASCADE,
  snapshot_version      INTEGER NOT NULL,
  metadata              JSONB NOT NULL,
  captured_by           TEXT NOT NULL,
  block_number          BIGINT NOT NULL,
  timestamp             TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  is_latest             BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE (nft_id, snapshot_version)
);

-- 🔄 Trigger-friendly: Maintain only one is_latest = TRUE per nft_id
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_latest_snapshot
  ON nft_metadata_snapshots(nft_id)
  WHERE is_latest = TRUE;

-- 📊 Indexes
CREATE INDEX IF NOT EXISTS idx_snapshot_nft_id ON nft_metadata_snapshots(nft_id);
CREATE INDEX IF NOT EXISTS idx_snapshot_block_number ON nft_metadata_snapshots(block_number);
