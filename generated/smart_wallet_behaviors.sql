-- ============================================================================
-- 🤖 Table: smart_wallet_behaviors
-- 📘 Captures AI-inferred behavioral patterns of wallets
-- ============================================================================

CREATE TABLE IF NOT EXISTS smart_wallet_behaviors (
  behavior_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address      TEXT NOT NULL,
  behavior_type       TEXT NOT NULL CHECK (
    behavior_type IN (
      'frequent_trader', 'long_term_holder', 'contract_deployer',
      'liquidity_provider', 'airdrop_hunter', 'flash_loan_attacker',
      'bridge_user', 'bot', 'whale', 'governance_participant',
      'nft_collector', 'sybil_suspect'
    )
  ),
  behavior_score      NUMERIC(5,4) NOT NULL CHECK (behavior_score >= 0 AND behavior_score <= 1),
  detected_by         TEXT NOT NULL DEFAULT 'ml_model_v1',
  first_seen_at       TIMESTAMPTZ NOT NULL,
  last_updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 🔐 Indexes
CREATE INDEX IF NOT EXISTS idx_wallet_behavior_address ON smart_wallet_behaviors(wallet_address);
CREATE INDEX IF NOT EXISTS idx_wallet_behavior_type_score ON smart_wallet_behaviors(behavior_type, behavior_score);
