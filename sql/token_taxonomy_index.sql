-- ==========================================================================
-- 🧬 Table: token_taxonomy_index
-- Description: Classifies tokens by standard, behavior, metadata traits,
-- and governance characteristics for advanced querying, filtering, and AI usage.
-- ==========================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_taxonomy_index'
  ) THEN
    CREATE TABLE token_taxonomy_index (
      taxonomy_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address       TEXT NOT NULL,
      token_name          TEXT,
      token_symbol        TEXT,
      standard            TEXT CHECK (standard IN ('ERC20', 'ERC721', 'ERC1155', 'Custom')),
      governance_type     TEXT,
      supply_model        TEXT,
      mintable            BOOLEAN,
      burnable            BOOLEAN,
      pausable            BOOLEAN,
      upgradeable         BOOLEAN,
      access_control      JSONB,
      metadata_traits     JSONB,
      risk_rating         NUMERIC(4,2),
      inserted_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_taxonomy_token_address ON token_taxonomy_index(token_address);
CREATE INDEX IF NOT EXISTS idx_taxonomy_standard ON token_taxonomy_index(standard);
CREATE INDEX IF NOT EXISTS idx_taxonomy_governance_type ON token_taxonomy_index(governance_type);
