-- =============================================================
-- 📦 Table: nft_collection_metrics
-- 📈 Stores statistics and health metrics per NFT collection
-- =============================================================

CREATE TABLE IF NOT EXISTS nft_collection_metrics (
  metrics_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  collection_id           UUID NOT NULL REFERENCES nft_collections(collection_id) ON DELETE CASCADE,
  snapshot_timestamp      TIMESTAMPTZ NOT NULL DEFAULT now(),
  floor_price_eth         NUMERIC(38, 18) NOT NULL,
  highest_sale_eth        NUMERIC(38, 18),
  avg_sale_eth            NUMERIC(38, 18),
  volume_24h_eth          NUMERIC(38, 18) NOT NULL,
  volume_7d_eth           NUMERIC(38, 18),
  num_owners              INTEGER NOT NULL,
  total_supply            INTEGER NOT NULL,
  royalty_fee_percent     NUMERIC(5, 2),
  mint_price_eth          NUMERIC(38, 18),
  metadata_update_rate    DOUBLE PRECISION,
  traits_diversity_score  DOUBLE PRECISION,
  wash_trading_detected   BOOLEAN DEFAULT FALSE,
  flagged_count           INTEGER DEFAULT 0,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🗂️ Indexes
CREATE INDEX IF NOT EXISTS idx_nft_collection_metrics_collection ON nft_collection_metrics(collection_id);
CREATE INDEX IF NOT EXISTS idx_nft_collection_metrics_snapshot ON nft_collection_metrics(snapshot_timestamp);
