-- ─────────────────────────────────────────────────────────────────────────────
-- 🧬 META_DYNAMIC_CONFIG — Runtime-tunable key/value config map for adaptive systems
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_dynamic_config (
    config_key        TEXT PRIMARY KEY,
    config_value      TEXT NOT NULL,
    value_type        TEXT CHECK (value_type IN ('integer', 'string', 'boolean', 'float', 'json')),
    is_active         BOOLEAN DEFAULT TRUE,
    updated_by        TEXT,
    updated_at        TIMESTAMPTZ DEFAULT NOW()
);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🧠 TX_GRAPH_FINGERPRINTS — Transaction graph behavior analytics for anomaly detection
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tx_graph_fingerprints (
    fingerprint_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash           VARCHAR(66) NOT NULL,
    graph_hash        VARCHAR(128) NOT NULL,
    pattern_label     TEXT,
    entropy_score     NUMERIC(10,6),
    graph_signature   BYTEA,
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_graph_tx_hash ON tx_graph_fingerprints(tx_hash);
CREATE INDEX IF NOT EXISTS idx_graph_label ON tx_graph_fingerprints(pattern_label);
