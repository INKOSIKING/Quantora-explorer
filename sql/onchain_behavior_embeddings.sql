-- ===============================================================================================
-- 🧬 Table: onchain_behavior_embeddings
-- Description: Vectorized behavior profiles of wallets, contracts, or addresses for clustering,
-- anomaly detection, and AI/ML applications like predictive analytics, wallet fingerprinting.
-- ===============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'onchain_behavior_embeddings'
  ) THEN
    CREATE TABLE onchain_behavior_embeddings (
      embedding_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      address               TEXT NOT NULL,
      address_type          TEXT NOT NULL,               -- e.g. 'EOA', 'contract'
      model_id              UUID REFERENCES ml_models(model_id),
      embedding_vector      VECTOR(256),                 -- Requires pgvector
      label                 TEXT,                        -- Optional (e.g. risk_label, cluster)
      score                 NUMERIC(10, 5),
      tags                  TEXT[],
      computed_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      metadata              JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_behavior_embeddings_address ON onchain_behavior_embeddings(address);
CREATE INDEX IF NOT EXISTS idx_behavior_embeddings_label ON onchain_behavior_embeddings(label);

