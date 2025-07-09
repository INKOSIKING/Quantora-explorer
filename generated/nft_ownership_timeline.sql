-- =====================================================================
-- 🔐 Table: nft_ownership_timeline
-- 📜 Tracks every ownership interval of each NFT from mint to burn
-- =====================================================================

CREATE TABLE IF NOT EXISTS nft_ownership_timeline (
  timeline_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  token_id             UUID NOT NULL REFERENCES nft_tokens(token_id) ON DELETE CASCADE,
  owner_address        TEXT NOT NULL,
  acquired_tx_hash     TEXT NOT NULL,
  acquired_block       BIGINT NOT NULL,
  acquired_timestamp   TIMESTAMPTZ NOT NULL,
  released_tx_hash     TEXT,
  released_block       BIGINT,
  released_timestamp   TIMESTAMPTZ,
  ownership_type       TEXT CHECK (ownership_type IN ('transfer', 'mint', 'burn', 'airdrop', 'contract_migration')),
  holding_duration_sec BIGINT GENERATED ALWAYS AS (
    CASE
      WHEN released_timestamp IS NOT NULL THEN EXTRACT(EPOCH FROM released_timestamp - acquired_timestamp)
      ELSE NULL
    END
  ) STORED,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📈 Indexes for analytic speed
CREATE INDEX IF NOT EXISTS idx_nft_ownership_token ON nft_ownership_timeline(token_id);
CREATE INDEX IF NOT EXISTS idx_nft_ownership_owner ON nft_ownership_timeline(owner_address);
CREATE INDEX IF NOT EXISTS idx_nft_ownership_acquired ON nft_ownership_timeline(acquired_timestamp);
