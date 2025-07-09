-- ─────────────────────────────────────────────────────────────────────────────
-- 🧾 TX_ANNOTATION_INSIGHTS — Stores human/AI-generated tags, labels & reasoning for transactions
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS tx_annotation_insights (
    annotation_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tx_hash           VARCHAR(66) NOT NULL,
    label             TEXT NOT NULL,
    confidence_score  NUMERIC(5,2),
    explanation       TEXT,
    source            TEXT CHECK (source IN ('user', 'ai', 'governance_oracle')),
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tx_annot_hash ON tx_annotation_insights(tx_hash);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🛡️ META_CHAIN_THREAT_INTEL — Real-time and historic threat intel across the chain
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_chain_threat_intel (
    threat_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    threat_type       TEXT NOT NULL,
    description       TEXT,
    affected_entities JSONB,
    severity_level    TEXT CHECK (severity_level IN ('low', 'moderate', 'critical')) NOT NULL,
    detected_by       TEXT,
    timestamp         TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_threat_type ON meta_chain_threat_intel(threat_type);
CREATE INDEX IF NOT EXISTS idx_threat_severity ON meta_chain_threat_intel(severity_level);
