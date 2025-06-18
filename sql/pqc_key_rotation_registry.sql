-- 🔐 PQC_KEY_ROTATION_REGISTRY — Tracks keygen, expiry, rotation, and PQ-safe revocation

CREATE TABLE IF NOT EXISTS pqc_key_rotation_registry (
  key_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_address      VARCHAR(66) NOT NULL,
  pqc_algo            TEXT NOT NULL CHECK (pqc_algo IN ('Kyber', 'Dilithium', 'SPHINCS+', 'BIKE', 'FrodoKEM')),
  public_key          TEXT NOT NULL,
  issued_at           TIMESTAMPTZ DEFAULT NOW(),
  expires_at          TIMESTAMPTZ,
  revoked             BOOLEAN DEFAULT FALSE,
  replacement_key_id  UUID,
  rotation_reason     TEXT
);

CREATE INDEX IF NOT EXISTS idx_pqc_wallet_address ON pqc_key_rotation_registry(wallet_address);
