-- 🔄 Table: reorg_contract_state
CREATE TABLE IF NOT EXISTS reorg_contract_state (
  reorg_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  block_height      BIGINT NOT NULL,
  affected_contract VARCHAR(66) NOT NULL,
  state_root_before VARCHAR(66),
  state_root_after  VARCHAR(66),
  reorg_reason      TEXT,
  detected_at       TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_reorg_contract_height 
  ON reorg_contract_state (block_height);

-- 🧾 Table: fraud_proof_registry
CREATE TABLE IF NOT EXISTS fraud_proof_registry (
  proof_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  submitted_by      VARCHAR(66) NOT NULL,
  target_tx_hash    VARCHAR(66) NOT NULL,
  proof_blob        BYTEA NOT NULL,
  proof_type        TEXT CHECK (proof_type IN ('invalid_state', 'double_spend', 'unauthorized_access')),
  status            TEXT CHECK (status IN ('pending', 'validated', 'rejected')) DEFAULT 'pending',
  submitted_at      TIMESTAMPTZ DEFAULT NOW(),
  validated_at      TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_fraud_proof_target_tx 
  ON fraud_proof_registry (target_tx_hash);
