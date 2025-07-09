-- ===================================================================
--  💸 Transactions Table Definition (Production-grade)
-- ===================================================================
CREATE TABLE IF NOT EXISTS transactions (
    tx_id               SERIAL PRIMARY KEY,
    tx_hash             VARCHAR(66) NOT NULL UNIQUE,
    block_id            INTEGER REFERENCES blocks(block_id) ON DELETE CASCADE,
    block_hash          VARCHAR(66),
    block_height        BIGINT,
    sender_address      VARCHAR(64) NOT NULL,
    receiver_address    VARCHAR(64),
    contract_address    VARCHAR(64),
    nonce               BIGINT NOT NULL,
    gas_price           NUMERIC(30, 0) NOT NULL,
    gas_limit           BIGINT NOT NULL,
    gas_used            BIGINT,
    value               NUMERIC(38, 0) NOT NULL,
    input_data          TEXT,
    status              VARCHAR(16) DEFAULT 'pending',
    error_reason        TEXT,
    created_at          TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_tx_hash         ON transactions(tx_hash);
CREATE INDEX IF NOT EXISTS idx_tx_sender       ON transactions(sender_address);
CREATE INDEX IF NOT EXISTS idx_tx_receiver     ON transactions(receiver_address);
CREATE INDEX IF NOT EXISTS idx_tx_block_id     ON transactions(block_id);
CREATE INDEX IF NOT EXISTS idx_tx_contract     ON transactions(contract_address);
