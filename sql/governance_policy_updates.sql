-- ===================================================================================================
-- 🗳️ Table: governance_policy_updates
-- Description: Tracks all governance policy changes such as staking requirements, vote quorum levels,
-- proposal eligibility, governance models, and treasury disbursement parameters. Critical for auditing
-- chain-level rule evolution and DAO dynamics.
-- ===================================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'governance_policy_updates'
  ) THEN
    CREATE TABLE governance_policy_updates (
      policy_update_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      proposal_id          UUID,
      policy_area          TEXT NOT NULL,        -- e.g. 'staking_rules', 'voting_quorum', 'proposal_rights'
      old_value            JSONB,
      new_value            JSONB,
      updated_by_address   TEXT,
      reason               TEXT,
      policy_version       TEXT,
      tx_hash              TEXT,
      block_number         BIGINT,
      chain_id             TEXT,
      effective_at         TIMESTAMPTZ,
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_policy_updates_area ON governance_policy_updates(policy_area);
CREATE INDEX IF NOT EXISTS idx_policy_updates_effective_at ON governance_policy_updates(effective_at);
CREATE INDEX IF NOT EXISTS idx_policy_updates_tx_hash ON governance_policy_updates(tx_hash);

