-- ============================================================
-- Table: nft_metadata_cache
-- Purpose: Caches metadata for NFTs (off-chain or IPFS-linked)
-- ============================================================

CREATE TABLE IF NOT EXISTS nft_metadata_cache (
  nft_id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_address     VARCHAR(66) NOT NULL,
  token_id             VARCHAR(128) NOT NULL,
  metadata_url         TEXT,
  metadata_json        JSONB,
  image_url            TEXT,
  animation_url        TEXT,
  name                 TEXT,
  description          TEXT,
  attributes           JSONB,
  fetch_status         VARCHAR(32) CHECK (fetch_status IN ('pending', 'fetched', 'failed')) DEFAULT 'pending',
  fetch_error          TEXT,
  last_fetched_at      TIMESTAMPTZ,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  updated_at           TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE UNIQUE INDEX IF NOT EXISTS uq_nft_contract_token
  ON nft_metadata_cache(contract_address, token_id);

CREATE INDEX IF NOT EXISTS idx_nft_metadata_status
  ON nft_metadata_cache(fetch_status);

-- === Trigger: auto-update updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_nft_metadata_cache_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_nft_metadata_cache_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_nft_metadata_cache_updated_at
    BEFORE UPDATE ON nft_metadata_cache
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_nft_metadata_cache_updated_at();
  END IF;
END
$$;
