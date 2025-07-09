-- ============================================
-- 📜 Table: contract_registry
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'contract_registry'
  ) THEN
    CREATE TABLE contract_registry (
      contract_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address     TEXT NOT NULL UNIQUE,
      creator_address      TEXT NOT NULL,
      creation_tx_hash     TEXT NOT NULL,
      deployed_at_block    BIGINT NOT NULL,
      verified             BOOLEAN DEFAULT FALSE,
      verification_source  TEXT,
      contract_name        TEXT,
      compiler_version     TEXT,
      source_code_hash     TEXT,
      abi_hash             TEXT,
      bytecode_hash        TEXT,
      tags                 TEXT[],
      notes                TEXT,
      registered_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

