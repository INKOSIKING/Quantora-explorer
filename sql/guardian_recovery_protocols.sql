-- ===================================================================================
-- Table: guardian_recovery_protocols
-- Purpose: Track multi-party account/wallet recovery protocols
-- Use Case: Enables social or AI-assisted recovery for lost or compromised keys
-- ===================================================================================

CREATE TABLE IF NOT EXISTS guardian_recovery_protocols (
  protocol_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address      VARCHAR(66) NOT NULL,
  requester_id        UUID NOT NULL, -- could be a user_id
  requested_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  approved            BOOLEAN DEFAULT FALSE,
  approved_at         TIMESTAMPTZ,
  recovery_status     VARCHAR(32) DEFAULT 'pending' CHECK (
                        recovery_status IN ('pending', 'approved', 'rejected', 'executed', 'expired')
                      ),
  threshold_required  INTEGER NOT NULL DEFAULT 2,
  notes               TEXT,
  expires_at          TIMESTAMPTZ,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Recovery Guardians Mapping Table ===
CREATE TABLE IF NOT EXISTS recovery_guardians (
  guardian_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  protocol_id         UUID NOT NULL REFERENCES guardian_recovery_protocols(protocol_id) ON DELETE CASCADE,
  guardian_address    VARCHAR(66) NOT NULL,
  approved            BOOLEAN DEFAULT FALSE,
  approval_signature  TEXT,
  responded_at        TIMESTAMPTZ,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_grp_wallet ON guardian_recovery_protocols(wallet_address);
CREATE INDEX IF NOT EXISTS idx_grp_status ON guardian_recovery_protocols(recovery_status);
CREATE INDEX IF NOT EXISTS idx_guardians_protocol ON recovery_guardians(protocol_id);

-- === Constraints ===
ALTER TABLE guardian_recovery_protocols
  ADD CONSTRAINT chk_valid_status
    CHECK (recovery_status IN ('pending', 'approved', 'rejected', 'executed', 'expired'));

ALTER TABLE recovery_guardians
  ADD CONSTRAINT chk_guardian_addr_format
    CHECK (guardian_address ~ '^0x[a-fA-F0-9]{40}$');
