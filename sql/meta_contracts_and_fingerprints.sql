-- ─────────────────────────────────────────────────────────────────────────────
-- 📦 META_CONTRACT_DEPENDENCIES — Tracks inter-contract & API-Schema dependencies
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_contract_dependencies (
    dependency_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contract_address    VARCHAR(66) NOT NULL,
    depends_on_address  VARCHAR(66) NOT NULL,
    dependency_type     TEXT CHECK (dependency_type IN ('contract', 'oracle', 'api', 'schema')),
    relation_label      TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_contract_dependency ON meta_contract_dependencies(contract_address);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🧬 INFRASTRUCTURE_FINGERPRINT — Verifies node or deployment authenticity
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS infrastructure_fingerprint (
    fingerprint_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    component_name      TEXT NOT NULL,
    hash_type           TEXT NOT NULL,
    hash_value          TEXT NOT NULL,
    captured_by_node    TEXT,
    verified            BOOLEAN DEFAULT FALSE,
    captured_at         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_infra_fingerprint_component ON infrastructure_fingerprint(component_name);
