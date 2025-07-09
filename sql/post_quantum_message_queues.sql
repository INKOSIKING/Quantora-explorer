-- ==============================================================
-- Schema: Post-Quantum Message Queues
-- Purpose: Asynchronous message delivery with post-quantum safety
-- ==============================================================

CREATE TABLE IF NOT EXISTS post_quantum_message_queues (
    message_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_address  VARCHAR(66) NOT NULL,
    recipient_address VARCHAR(66) NOT NULL,
    pqc_algorithm   TEXT NOT NULL,
    encrypted_payload BYTEA NOT NULL,
    delivery_status TEXT CHECK (delivery_status IN ('queued', 'delivered', 'expired', 'failed')) DEFAULT 'queued',
    priority_level  SMALLINT CHECK (priority_level BETWEEN 0 AND 10) DEFAULT 5,
    expires_at      TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    delivered_at    TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_pqmq_sender ON post_quantum_message_queues(sender_address);
CREATE INDEX IF NOT EXISTS idx_pqmq_recipient ON post_quantum_message_queues(recipient_address);
CREATE INDEX IF NOT EXISTS idx_pqmq_status ON post_quantum_message_queues(delivery_status);
