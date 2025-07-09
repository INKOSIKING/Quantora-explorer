-- ======================================================
-- Table: zk_batch_proofs
-- Purpose: Stores batch proofs for zkRollups
-- ======================================================

CREATE TABLE IF NOT EXISTS zk_batch_proofs (
    proof_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_range_start   BIGINT NOT NULL,
    tx_range_end     BIGINT NOT NULL,
    zk_proof_blob    BYTEA NOT NULL,
    verification_key BYTEA,
    root_commitment  VARCHAR(66),
    verified         BOOLEAN DEFAULT FALSE,
    created_at       TIMESTAMPTZ DEFAULT NOW()
);
