-- ================================================================================================
-- ��️ Table: contract_permission_audit
-- Description: Logs all permission or role changes within smart contracts, including admin role
-- changes, function access updates, blacklists/whitelists, and critical gatekeeper transitions.
-- Used to monitor contract-level governance integrity and security.
-- ================================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'contract_permission_audit'
  ) THEN
    CREATE TABLE contract_permission_audit (
      audit_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      contract_address      TEXT NOT NULL,
      affected_function     TEXT,
      changed_by_address    TEXT NOT NULL,
      permission_type       TEXT NOT NULL,         -- e.g. 'grant_role', 'revoke_role', 'access_change'
      old_state             JSONB,
      new_state             JSONB,
      tx_hash               TEXT,
      block_number          BIGINT,
      chain_id              TEXT,
      triggered_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      reviewed              BOOLEAN DEFAULT FALSE,
      reviewer              TEXT,
      review_notes          TEXT,
      resolved_at           TIMESTAMPTZ
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_perm_audit_contract ON contract_permission_audit(contract_address);
CREATE INDEX IF NOT EXISTS idx_perm_audit_triggered_at ON contract_permission_audit(triggered_at);
CREATE INDEX IF NOT EXISTS idx_perm_audit_tx_hash ON contract_permission_audit(tx_hash);

