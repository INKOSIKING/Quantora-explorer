-- ======================================================
-- Table: inter_shard_messages
-- Purpose: Messaging layer for cross-shard transactions
-- ======================================================

CREATE TABLE IF NOT EXISTS inter_shard_messages (
    message_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_shard      BIGINT NOT NULL,
    to_shard        BIGINT NOT NULL,
    payload         BYTEA NOT NULL,
    status          TEXT CHECK (status IN ('queued', 'delivered', 'failed')) DEFAULT 'queued',
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
