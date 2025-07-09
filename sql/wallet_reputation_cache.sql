-- ===============================================================================================
-- 🧠 Table: wallet_reputation_cache
-- Description: AI/ML-based or rule-based reputation cache for known wallets based on transaction 
-- history, contract interaction, volume, flags, and anomalies.
-- ===============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'wallet_reputation_cache'
  ) THEN
    CREATE TABLE wallet_reputation_cache (
      wallet_address      TEXT PRIMARY KEY,
      reputation_score    NUMERIC(5,2) CHECK (reputation_score BETWEEN 0 AND 100),
      trust_level         TEXT CHECK (trust_level IN ('low', 'medium', 'high', 'unknown')),
      last_updated        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      transaction_count   BIGINT DEFAULT 0,
      anomaly_flags       TEXT[],
      reputation_source   TEXT DEFAULT 'system_model_v1',
      notes               TEXT,
      metadata            JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_wallet_reputation_score ON wallet_reputation_cache(reputation_score);
CREATE INDEX IF NOT EXISTS idx_wallet_trust_level ON wallet_reputation_cache(trust_level);
CREATE INDEX IF NOT EXISTS idx_wallet_last_updated ON wallet_reputation_cache(last_updated);

