-- =====================================================
-- ⚖️ Table: governance_policy_enforcements
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'governance_policy_enforcements'
  ) THEN
    CREATE TABLE governance_policy_enforcements (
      enforcement_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      policy_version_id    UUID NOT NULL,
      enforced_by          TEXT NOT NULL,
      action_type          TEXT NOT NULL, -- e.g., "slashing", "permission_revoke"
      target_entity        TEXT,
      related_proposal_id  UUID,
      reason               TEXT,
      enforcement_hash     TEXT,
      valid                BOOLEAN DEFAULT TRUE,
      executed_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      recorded_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

      CONSTRAINT fk_enforced_policy FOREIGN KEY (policy_version_id)
        REFERENCES governance_policy_versions(version_id) ON DELETE CASCADE
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_enforcement_policy_version ON governance_policy_enforcements(policy_version_id);
CREATE INDEX IF NOT EXISTS idx_enforcement_hash ON governance_policy_enforcements(enforcement_hash);
