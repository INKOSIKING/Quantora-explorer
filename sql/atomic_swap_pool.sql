-- ======================================================================
-- Table: atomic_swap_pool
-- Purpose: Tracks atomic cross-chain swaps using HTLC or zk-based locks
-- ======================================================================

CREATE TABLE IF NOT EXISTS atomic_swap_pool (
    swap_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    initiator_address VARCHAR(66) NOT NULL,
    counterparty_address VARCHAR(66) NOT NULL,
    asset_symbol      TEXT NOT NULL,
    amount            NUMERIC(78, 0) NOT NULL CHECK (amount > 0),
    hash_lock         VARCHAR(128) NOT NULL,
    secret            VARCHAR(128),
    expiry_timestamp  TIMESTAMPTZ NOT NULL,
    swap_status       TEXT NOT NULL CHECK (swap_status IN ('initiated', 'redeemed', 'expired', 'cancelled')),
    source_chain      TEXT NOT NULL,
    destination_chain TEXT NOT NULL,
    created_at        TIMESTAMPTZ DEFAULT NOW(),
    updated_at        TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_atomic_swap_status ON atomic_swap_pool(swap_status);
CREATE INDEX IF NOT EXISTS idx_atomic_swap_expiry ON atomic_swap_pool(expiry_timestamp);

-- === Constraints ===
ALTER TABLE atomic_swap_pool
  ADD CONSTRAINT chk_hash_lock_format
    CHECK (hash_lock ~ '^[a-fA-F0-9]{64,128}$')
  NOT VALID;

-- === Triggers ===
-- Optional: Add expiry automation or slashing logic via jobs/cron
