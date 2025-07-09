-- ================================================================================
-- 📸 Table: nft_royalty_snapshots
-- Description: Captures royalty distribution history for NFT collections
-- ================================================================================

CREATE TABLE IF NOT EXISTS nft_royalty_snapshots (
    snapshot_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id        UUID NOT NULL,
    snapshot_timestamp   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    royalty_distribution JSONB NOT NULL, -- { "address1": 5.0, "address2": 2.5 }
    effective_from_block BIGINT NOT NULL,
    effective_to_block   BIGINT,
    reason               TEXT,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (collection_id) REFERENCES nft_collection_metadata(collection_id) ON DELETE CASCADE
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_royalty_collection_time ON nft_royalty_snapshots(collection_id, snapshot_timestamp);
