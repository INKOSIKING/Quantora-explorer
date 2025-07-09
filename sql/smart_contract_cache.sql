-- ======================================================
-- Table: smart_contract_cache
-- Purpose: Cache parsed contract metadata, bytecode and ABI
-- Layer: Runtime Optimizations / Execution Caching
-- ======================================================

CREATE TABLE IF NOT EXISTS smart_contract_cache (
  contract_address     VARCHAR(66) PRIMARY KEY,
  bytecode_hash        VARCHAR(66) NOT NULL,
  deployed_bytecode    BYTEA NOT NULL,
  abi_json             JSONB,
  source_code_url      TEXT,
  compiler_version     TEXT,
  language             TEXT DEFAULT 'Solidity',
  optimizations_used   BOOLEAN DEFAULT FALSE,
  optimization_runs    INT,
  cache_generated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_contract_cache_bytecode_hash ON smart_contract_cache(bytecode_hash);
CREATE INDEX IF NOT EXISTS idx_contract_cache_language      ON smart_contract_cache(language);

-- === Trigger Function for updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'fn_update_contract_cache_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_contract_cache_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
  END IF;
END
$$;

-- === Trigger Assignment ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_contract_cache_updated_at'
  ) THEN
    CREATE TRIGGER trg_contract_cache_updated_at
    BEFORE UPDATE ON smart_contract_cache
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_contract_cache_updated_at();
  END IF;
END
$$;
