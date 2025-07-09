-- =====================================================================================
-- Table: agent_reward_claims
-- Purpose: Tracks autonomous or AI agent-based reward claims, conditions, and payouts
-- =====================================================================================

CREATE TABLE IF NOT EXISTS agent_reward_claims (
  claim_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id            UUID NOT NULL,                          -- Foreign key from registered agents table (optional)
  related_task_id     UUID,                                   -- Reference to task, job, or simulation
  reward_type         TEXT NOT NULL CHECK (
                          reward_type IN ('compute', 'data_contribution', 'validation', 'oracle_proof', 'autonomy')
                      ),
  reward_amount       NUMERIC(38, 18) NOT NULL,
  reward_token        VARCHAR(66) NOT NULL,                   -- ERC20 or native token address
  claim_status        TEXT NOT NULL CHECK (
                          claim_status IN ('pending', 'approved', 'rejected', 'paid')
                      ),
  proof_reference     TEXT,                                   -- IPFS or zkProof reference
  payout_tx_hash      VARCHAR(66),
  created_at          TIMESTAMPTZ DEFAULT NOW(),
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_arc_agent_id ON agent_reward_claims(agent_id);
CREATE INDEX IF NOT EXISTS idx_arc_status ON agent_reward_claims(claim_status);
CREATE INDEX IF NOT EXISTS idx_arc_reward_token ON agent_reward_claims(reward_token);
CREATE INDEX IF NOT EXISTS idx_arc_task ON agent_reward_claims(related_task_id);

-- === Trigger for updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_agent_reward_claims_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_arc_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trg_agent_reward_claims_updated_at
    BEFORE UPDATE ON agent_reward_claims
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_arc_updated_at();
  END IF;
END
$$;
