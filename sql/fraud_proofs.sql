-- ===================================================================
-- Table: fraud_proofs
-- Purpose: Logs all submitted and verified fraud proofs for disputes
-- ===================================================================

CREATE TABLE IF NOT EXISTS fraud_proofs (
    proof_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    layer_id         TEXT NOT NULL CHECK (layer_id IN ('L2', 'L3', 'L1-mirror')),
    dispute_id       UUID NOT NULL,
    challenger       VARCHAR(66) NOT NULL,
    accused          VARCHAR(66),
    fraud_type       TEXT CHECK (fraud_type IN (
                        'state_root_mismatch',
                        'invalid_transition',
                        'incorrect_proof',
                        'double_spend',
                        'sequencer_misbehavior',
                        'timestamp_forgery',
                        'execution_divergence'
                    )) NOT NULL,
    related_tx_hash  VARCHAR(66),
    related_block    BIGINT,
    submitted_at     TIMESTAMPTZ DEFAULT NOW(),
    verified_at      TIMESTAMPTZ,
    resolution       TEXT CHECK (resolution IN ('confirmed', 'dismissed', 'pending')) DEFAULT 'pending',
    zk_proof_blob    BYTEA,
    notes            TEXT
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_fraud_challenger ON fraud_proofs(challenger);
CREATE INDEX IF NOT EXISTS idx_fraud_dispute_id ON fraud_proofs(dispute_id);
CREATE INDEX IF NOT EXISTS idx_fraud_layer_id    ON fraud_proofs(layer_id);
CREATE INDEX IF NOT EXISTS idx_fraud_type        ON fraud_proofs(fraud_type);
CREATE INDEX IF NOT EXISTS idx_fraud_tx_hash     ON fraud_proofs(related_tx_hash);
