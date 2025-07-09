-- Table: trade_executions
-- Purpose: Records finalized trade executions on the exchange (both maker and taker).

CREATE TABLE IF NOT EXISTS trade_executions (
    execution_id          BIGSERIAL PRIMARY KEY,
    trade_hash            TEXT UNIQUE NOT NULL,
    order_id_maker        TEXT NOT NULL,
    order_id_taker        TEXT NOT NULL,
    wallet_maker          TEXT NOT NULL,
    wallet_taker          TEXT NOT NULL,
    market_symbol         TEXT NOT NULL, -- e.g., ETH/USDT
    base_token            TEXT NOT NULL,
    quote_token           TEXT NOT NULL,
    base_amount           NUMERIC(78, 0) NOT NULL,
    quote_amount          NUMERIC(78, 0) NOT NULL,
    price                 NUMERIC(78, 18) NOT NULL,
    fee_maker             NUMERIC(78, 18),
    fee_taker             NUMERIC(78, 18),
    fee_currency          TEXT,
    executed_at_block     BIGINT NOT NULL,
    executed_at_timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    side                  TEXT CHECK (side IN ('buy', 'sell')),
    is_liquidation        BOOLEAN DEFAULT FALSE,
    metadata              JSONB DEFAULT '{}'::JSONB
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_trade_executions_market ON trade_executions(market_symbol);
CREATE INDEX IF NOT EXISTS idx_trade_executions_time ON trade_executions(executed_at_timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_trade_executions_wallets ON trade_executions(wallet_maker, wallet_taker);
