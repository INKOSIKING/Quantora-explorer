-- ─────────────────────────────────────────────────────────────────────────────
-- ✅ SCHEMA_VALIDATION_RULES — Enforce dynamic data shape rules on smart contract storage or API schemas
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS schema_validation_rules (
    rule_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schema_namespace    TEXT NOT NULL,
    field_name          TEXT NOT NULL,
    expected_type       TEXT NOT NULL,
    validation_pattern  TEXT,
    required            BOOLEAN DEFAULT TRUE,
    example_value       TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_schema_namespace ON schema_validation_rules(schema_namespace);

-- ─────────────────────────────────────────────────────────────────────────────
-- 📣 META_EVENT_SIGNATURES — ABI-aware event signature tracking for analytics & trace decoding
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_event_signatures (
    signature_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_name          TEXT NOT NULL,
    event_signature     TEXT NOT NULL,
    contract_address    VARCHAR(66),
    decoded_fields      JSONB,
    is_standard         BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_event_signature_name ON meta_event_signatures(event_name);
