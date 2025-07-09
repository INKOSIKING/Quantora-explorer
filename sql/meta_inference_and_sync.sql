-- ─────────────────────────────────────────────────────────────────────────────
-- 🔍 SCHEMA_INFERENCE_LAYERS — Tracks inferred schema logic or AI outputs
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS schema_inference_layers (
    inference_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_entity    TEXT NOT NULL,
    inferred_fields  JSONB NOT NULL,
    confidence_score NUMERIC(5,4),
    model_used       TEXT,
    notes            TEXT,
    generated_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_inference_source ON schema_inference_layers(source_entity);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🧭 META_SYNC_STATUS — Status of schema/contract registry synchronization
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_sync_status (
    sync_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subsystem        TEXT NOT NULL,
    target_component TEXT NOT NULL,
    last_synced_at   TIMESTAMPTZ,
    sync_status      TEXT CHECK (sync_status IN ('synced', 'drifted', 'error')) DEFAULT 'synced',
    sync_notes       TEXT,
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_meta_subsystem ON meta_sync_status(subsystem);
