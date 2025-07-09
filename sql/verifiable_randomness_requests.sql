-- =============================================================================
-- Table: verifiable_randomness_requests
-- Purpose: Tracks requests and results for secure randomness using VRF/VDF/ZKP
-- =============================================================================

CREATE TABLE IF NOT EXISTS verifiable_randomness_requests (
  request_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  requester_address    VARCHAR(66) NOT NULL,
  randomness_type      VARCHAR(32) NOT NULL CHECK (randomness_type IN ('vrf', 'vdf', 'zk_rng')),
  seed_hash            VARCHAR(66) NOT NULL,
  randomness_result    VARCHAR(66),
  proof_blob           BYTEA,
  verified             BOOLEAN DEFAULT FALSE,
  request_block        BIGINT NOT NULL,
  fulfilled_block      BIGINT,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  verified_at          TIMESTAMPTZ,
  metadata             JSONB
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_randomness_requester ON verifiable_randomness_requests(requester_address);
CREATE INDEX IF NOT EXISTS idx_randomness_type ON verifiable_randomness_requests(randomness_type);
CREATE INDEX IF NOT EXISTS idx_randomness_verified ON verifiable_randomness_requests(verified);

-- === Constraints ===
ALTER TABLE verifiable_randomness_requests
  ADD CONSTRAINT chk_requester_format
    CHECK (requester_address ~ '^0x[a-fA-F0-9]{40}$');

ALTER TABLE verifiable_randomness_requests
  ADD CONSTRAINT chk_seed_hash_format
    CHECK (seed_hash ~ '^0x[a-fA-F0-9]{64}$');

ALTER TABLE verifiable_randomness_requests
  ADD CONSTRAINT chk_result_format
    CHECK (
      randomness_result IS NULL OR randomness_result ~ '^0x[a-fA-F0-9]{64}$'
    );
