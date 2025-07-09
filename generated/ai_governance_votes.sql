-- ============================================================================
-- 🧠 Table: ai_governance_votes
-- 📘 Tracks AI-assisted or automated governance voting events
-- ============================================================================

CREATE TABLE IF NOT EXISTS ai_governance_votes (
  vote_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id          UUID NOT NULL REFERENCES governance_proposals(proposal_id) ON DELETE CASCADE,
  voter_type           TEXT NOT NULL CHECK (voter_type IN ('human', 'ai', 'hybrid')),
  voter_identity       TEXT NOT NULL,
  vote_value           TEXT NOT NULL CHECK (vote_value IN ('yes', 'no', 'abstain')),
  confidence_score     NUMERIC(5,4), -- Optional for AI votes, e.g., 0.9823
  reason               TEXT,
  submitted_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 📌 Indexes
CREATE INDEX IF NOT EXISTS idx_ai_votes_proposal_id ON ai_governance_votes(proposal_id);
CREATE INDEX IF NOT EXISTS idx_ai_votes_type_identity ON ai_governance_votes(voter_type, voter_identity);
