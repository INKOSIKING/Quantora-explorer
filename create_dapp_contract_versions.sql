-- ======================================================================================
-- 📦 Table: dapp_contract_versions
-- Description: Tracks versioned smart contracts associated with deployed dApps
-- ======================================================================================

CREATE TABLE IF NOT EXISTS dapp_contract_versions (
    contract_version_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dapp_id               UUID NOT NULL,
    contract_address      TEXT NOT NULL,
    contract_name         TEXT NOT NULL,
    version_semver        TEXT NOT NULL, -- e.g. "1.2.3"
    deployed_by           TEXT,
    deployed_at_block     BIGINT NOT NULL,
    deployed_at_time      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    changelog             TEXT,
    audit_report_url      TEXT,
    inserted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (dapp_id) REFERENCES dapp_registry(dapp_id) ON DELETE CASCADE
);

-- 🔍 Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_contract_version_unique ON dapp_contract_versions(dapp_id, version_semver);
CREATE INDEX IF NOT EXISTS idx_dapp_contract_address ON dapp_contract_versions(contract_address);
