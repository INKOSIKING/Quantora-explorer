-- ======================================================
-- Table: shard_registry
-- Purpose: Metadata for scalable parallel execution shards
-- ======================================================

CREATE TABLE IF NOT EXISTS shard_registry (
    shard_id        BIGSERIAL PRIMARY KEY,
    parent_shard    BIGINT,
    node_host       TEXT NOT NULL,
    status          TEXT CHECK (status IN ('active', 'syncing', 'offline')) DEFAULT 'active',
    current_height  BIGINT DEFAULT 0,
    last_updated    TIMESTAMPTZ DEFAULT NOW()
);
