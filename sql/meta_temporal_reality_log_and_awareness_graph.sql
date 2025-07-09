-- ─────────────────────────────────────────────────────────────────────────────
-- 🧭 META_TEMPORAL_REALITY_LOG — Anchors external events to chain state
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_temporal_reality_log (
    event_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    external_event   TEXT NOT NULL,
    timestamp_real   TIMESTAMPTZ NOT NULL,
    anchor_block     BIGINT NOT NULL,
    anchor_tx_hash   VARCHAR(66),
    confidence_level NUMERIC(5,4) CHECK (confidence_level BETWEEN 0.0000 AND 1.0000),
    recorded_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_temporal_anchor ON meta_temporal_reality_log(anchor_block);
CREATE INDEX IF NOT EXISTS idx_temporal_confidence ON meta_temporal_reality_log(confidence_level);

-- ─────────────────────────────────────────────────────────────────────────────
-- 🧠 META_BLOCKCHAIN_AWARENESS_GRAPH — Models inter-node awareness propagation
-- ─────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS meta_blockchain_awareness_graph (
    awareness_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    node_id          TEXT NOT NULL,
    known_state_hash VARCHAR(66),
    propagation_lag  INTEGER, -- in milliseconds
    awareness_vector BYTEA,
    recorded_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_awareness_node ON meta_blockchain_awareness_graph(node_id);
CREATE INDEX IF NOT EXISTS idx_awareness_propagation ON meta_blockchain_awareness_graph(propagation_lag);
