-- ===========================================================================================
-- 🔥 Table: nft_transfer_heatmap
-- Description: Stores time-series and location-aware metadata on NFT transfers for heatmap analysis.
-- ===========================================================================================

CREATE TABLE IF NOT EXISTS nft_transfer_heatmap (
    heatmap_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nft_id               TEXT NOT NULL,
    token_address        TEXT NOT NULL,
    from_wallet          TEXT NOT NULL,
    to_wallet            TEXT NOT NULL,
    transfer_value_usd   NUMERIC(30, 10),
    block_number         BIGINT,
    tx_hash              TEXT,
    timestamp            TIMESTAMPTZ NOT NULL,
    country_code         TEXT,
    city                 TEXT,
    geo_location         POINT,
    network              TEXT NOT NULL,
    inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_nft_heatmap_timestamp ON nft_transfer_heatmap(timestamp);
CREATE INDEX IF NOT EXISTS idx_nft_heatmap_geo ON nft_transfer_heatmap(geo_location);
CREATE INDEX IF NOT EXISTS idx_nft_heatmap_token ON nft_transfer_heatmap(token_address);
CREATE INDEX IF NOT EXISTS idx_nft_heatmap_wallets ON nft_transfer_heatmap(from_wallet, to_wallet);
