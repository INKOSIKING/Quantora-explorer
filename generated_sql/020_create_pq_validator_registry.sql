-- 📜 PQ Validator Registry Table
CREATE TABLE IF NOT EXISTS pq_validator_registry (
    validator_id         UUID PRIMARY KEY,
    node_id              TEXT NOT NULL UNIQUE,
    pq_public_key        TEXT NOT NULL,
    signature_algorithm  TEXT NOT NULL,
    key_type             TEXT DEFAULT 'pq-safe',
    created_at           TIMESTAMPTZ DEFAULT now(),
    metadata             JSONB,
    is_active            BOOLEAN DEFAULT TRUE,
    last_verified_at     TIMESTAMPTZ,
    UNIQUE (pq_public_key)
);
