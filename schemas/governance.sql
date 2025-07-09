-- File: schemas/governance.sql

-- 🗳️ Proposals Table
CREATE TABLE IF NOT EXISTS proposals (
  proposal_id      BIGSERIAL PRIMARY KEY,
  title            TEXT NOT NULL,
  description      TEXT,
  proposer         VARCHAR(66) NOT NULL,
  status           TEXT NOT NULL CHECK (status IN ('pending', 'active', 'passed', 'rejected', 'executed')),
  start_block      BIGINT NOT NULL,
  end_block        BIGINT NOT NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔄 Automatically update `updated_at`
CREATE OR REPLACE FUNCTION update_proposals_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_proposals_updated_at
BEFORE UPDATE ON proposals
FOR EACH ROW EXECUTE FUNCTION update_proposals_updated_at();

-- 🗳️ Votes Table
CREATE TABLE IF NOT EXISTS governance_votes (
  vote_id          BIGSERIAL PRIMARY KEY,
  proposal_id      BIGINT NOT NULL REFERENCES proposals(proposal_id) ON DELETE CASCADE,
  voter_address    VARCHAR(66) NOT NULL,
  support          BOOLEAN NOT NULL, -- true = yes, false = no
  weight           NUMERIC(78, 0) NOT NULL,
  voted_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (proposal_id, voter_address)
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_proposals_status ON proposals (status);
CREATE INDEX IF NOT EXISTS idx_votes_proposal_id ON governance_votes (proposal_id);
CREATE INDEX IF NOT EXISTS idx_votes_voter ON governance_votes (voter_address);
