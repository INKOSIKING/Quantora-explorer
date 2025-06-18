-- ─────────────────────────────────────────────────────────────────────────────
-- ⚖️ VALIDATOR_CHALLENGE_MARKET — Truth Challenge Incentivization
-- ─────────────────────────────────────────────────────────────────────────────

-- 🧾 Table: validator_challenges
CREATE TABLE IF NOT EXISTS validator_challenges (
  challenge_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenger        TEXT NOT NULL,
  challenged_node   TEXT NOT NULL,
  block_hash        VARCHAR(66) NOT NULL,
  reason_code       TEXT NOT NULL,
  zkp_evidence_hash TEXT,
  stake_amount      NUMERIC(36,18) NOT NULL,
  challenge_time    TIMESTAMPTZ DEFAULT NOW(),
  resolved          BOOLEAN DEFAULT FALSE,
  resolution_outcome TEXT CHECK (resolution_outcome IN ('accepted', 'rejected', 'invalid_proof')),
  resolved_at       TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_challenge_block ON validator_challenges(block_hash);
CREATE INDEX IF NOT EXISTS idx_challenge_challenger ON validator_challenges(challenger);
