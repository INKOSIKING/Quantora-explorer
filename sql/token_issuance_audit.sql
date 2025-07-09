-- ===============================================================
-- 📜 Table: token_issuance_audit
-- Description: Audits and records all token minting events including
-- contract address, creator, rules, and issuance signatures.
-- ===============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_issuance_audit'
  ) THEN
    CREATE TABLE token_issuance_audit (
      audit_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address        TEXT NOT NULL,
      creator_address      TEXT NOT NULL,
      initial_supply       NUMERIC(78, 0) NOT NULL,
      token_standard       TEXT CHECK (token_standard IN ('ERC20', 'ERC721', 'ERC1155', 'Custom')),
      minting_tx_hash      TEXT NOT NULL UNIQUE,
      issuance_rules       JSONB,
      is_verified          BOOLEAN DEFAULT FALSE,
      verification_method  TEXT,
      signature_hash       TEXT,
      issued_at_block      BIGINT NOT NULL,
      issued_at_time       TIMESTAMPTZ DEFAULT NOW(),
      inserted_at          TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_token_issuance_address ON token_issuance_audit(token_address);
CREATE INDEX IF NOT EXISTS idx_token_issuance_creator ON token_issuance_audit(creator_address);
CREATE INDEX IF NOT EXISTS idx_token_issuance_block ON token_issuance_audit(issued_at_block);
