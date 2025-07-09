-- =====================================================
-- 🗳️ Table: governance_policy_versions
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'governance_policy_versions'
  ) THEN
    CREATE TABLE governance_policy_versions (
      version_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      version_number     INT NOT NULL,
      title              TEXT NOT NULL,
      description        TEXT,
      policy_hash        TEXT NOT NULL,
      policy_document    TEXT,
      activated_by       TEXT,
      approved_by_votes  BOOLEAN DEFAULT FALSE,
      total_votes        INT,
      quorum_required    INT,
      passed             BOOLEAN,
      valid_from_block   BIGINT,
      created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      activated_at       TIMESTAMPTZ
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_gov_version_number ON governance_policy_versions(version_number);
CREATE INDEX IF NOT EXISTS idx_gov_policy_hash ON governance_policy_versions(policy_hash);
