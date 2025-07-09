-- =======================================================================================
-- 📚 Table: onchain_model_registry
-- Description: Stores metadata, versioning, and deployment context for AI/ML models used on-chain.
-- =======================================================================================

CREATE TABLE IF NOT EXISTS onchain_model_registry (
    model_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_name          TEXT NOT NULL,
    model_version       TEXT NOT NULL,
    model_type          TEXT NOT NULL CHECK (model_type IN ('classification', 'regression', 'nlp', 'vision', 'reinforcement')),
    source_code_hash    TEXT NOT NULL,
    training_data_hash  TEXT,
    training_date       DATE,
    deployed_by         TEXT NOT NULL,
    deployment_block    BIGINT,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    is_verified         BOOLEAN NOT NULL DEFAULT FALSE,
    metadata            JSONB,
    registered_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_model_name_version ON onchain_model_registry(model_name, model_version);
CREATE INDEX IF NOT EXISTS idx_model_type ON onchain_model_registry(model_type);
CREATE INDEX IF NOT EXISTS idx_model_deployment_block ON onchain_model_registry(deployment_block);
