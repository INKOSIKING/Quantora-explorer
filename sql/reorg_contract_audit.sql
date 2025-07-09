-- ===================================================================
-- Table: reorg_contract_audit
-- Purpose: Tracks contract-level reorg impact for forensic analysis
-- ===================================================================

CREATE TABLE IF NOT EXISTS reorg_contract_audit (
    audit_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address  VARCHAR(66) NOT NULL,
    reorg_block_hash  VARCHAR(66) NOT NULL,
    original_block    BIGINT NOT NULL,
    replacement_block BIGINT NOT NULL,
    tx_hash           VARCHAR(66),
    method_signature  TEXT,
    affected_storage_keys TEXT[],
    reorg_type        TEXT CHECK (reorg_type IN ('short', 'deep', 'consensus_fault')),
    anomaly_flag      BOOLEAN DEFAULT FALSE,
    rollback_status   TEXT CHECK (rollback_status IN ('pending', 'completed', 'failed')) DEFAULT 'pending',
    detected_at       TIMESTAMPTZ DEFAULT NOW(),
    resolved_at       TIMESTAMPTZ
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_reorg_contract_addr ON reorg_contract_audit(contract_address);
CREATE INDEX IF NOT EXISTS idx_reorg_contract_block ON reorg_contract_audit(reorg_block_hash);
CREATE INDEX IF NOT EXISTS idx_reorg_contract_rollback ON reorg_contract_audit(rollback_status);

-- === Constraints ===
ALTER TABLE reorg_contract_audit
  ADD CONSTRAINT chk_contract_format
    CHECK (contract_address ~ '^0x[a-fA-F0-9]{40}$')
  NOT VALID;
