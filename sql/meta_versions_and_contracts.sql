-- ─────────────────────────────────────────────────────────────────────────────
-- 🧬 DATA_MODEL_VERSIONS — Track historical versions of internal data schemas
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS data_model_versions (
    model_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    model_name       TEXT NOT NULL,
    version_number   TEXT NOT NULL,
    description      TEXT,
    schema_diff      TEXT,
    introduced_at    TIMESTAMPTZ DEFAULT NOW(),
    deprecated_at    TIMESTAMPTZ
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_model_version ON data_model_versions(model_name, version_number);

-- ─────────────────────────────────────────────────────────────────────────────
-- 📡 API_CONTRACTS_REGISTRY — Registry of REST/gRPC/WebSocket contract schemas
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS api_contracts_registry (
    contract_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    interface_name   TEXT NOT NULL,
    version          TEXT NOT NULL,
    spec_format      TEXT CHECK (spec_format IN ('OpenAPI', 'gRPC', 'GraphQL', 'WSDL')) NOT NULL,
    contract_blob    BYTEA NOT NULL,
    live_status      BOOLEAN DEFAULT TRUE,
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_api_interface ON api_contracts_registry(interface_name);
