-- 🔁 META_BLOCK_FINALITY_ECHO — Redundant validation & echo confirmations
CREATE TABLE IF NOT EXISTS meta_block_finality_echo (
    echo_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    block_hash      VARCHAR(66) NOT NULL,
    echo_node       TEXT NOT NULL,
    finality_score  NUMERIC(4,3) CHECK (finality_score BETWEEN 0.000 AND 1.000),
    echo_round      INTEGER NOT NULL,
    echo_timestamp  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_finality_echo_block ON meta_block_finality_echo(block_hash);
CREATE INDEX IF NOT EXISTS idx_finality_echo_round ON meta_block_finality_echo(echo_round);

-- 🕸️ META_LOGICAL_HYPERGRAPH_NETWORK — Multidimensional truth mapping
CREATE TABLE IF NOT EXISTS meta_logical_hypergraph_network (
    link_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_entity    TEXT NOT NULL,
    predicate         TEXT NOT NULL,
    object_entity     TEXT NOT NULL,
    confidence_score  NUMERIC(5,4) CHECK (confidence_score BETWEEN 0.0000 AND 1.0000),
    origin_source     TEXT,
    created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_hypergraph_subject ON meta_logical_hypergraph_network(subject_entity);
CREATE INDEX IF NOT EXISTS idx_hypergraph_confidence ON meta_logical_hypergraph_network(confidence_score);
