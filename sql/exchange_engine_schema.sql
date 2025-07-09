-- ====================================
-- Schema: Exchange Engine Core Tables
-- Purpose: Core trading infrastructure
-- ====================================

-- === Order Book Snapshots ===
CREATE TABLE IF NOT EXISTS order_book_snapshots (
  snapshot_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  market_symbol   VARCHAR(32) NOT NULL,
  snapshot_json   JSONB NOT NULL,
  recorded_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_obs_market_time ON order_book_snapshots(market_symbol, recorded_at DESC);

-- === Trade Executions ===
CREATE TABLE IF NOT EXISTS trade_executions (
  trade_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  market_symbol   VARCHAR(32) NOT NULL,
  taker_order_id  UUID NOT NULL,
  maker_order_id  UUID NOT NULL,
  price           NUMERIC NOT NULL,
  quantity        NUMERIC NOT NULL,
  trade_side      VARCHAR(10) CHECK (trade_side IN ('buy', 'sell')) NOT NULL,
  executed_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_trade_exec_market ON trade_executions(market_symbol);
CREATE INDEX IF NOT EXISTS idx_trade_exec_time ON trade_executions(executed_at DESC);

-- === Wallet Balances ===
CREATE TABLE IF NOT EXISTS wallet_balances (
  wallet_id     UUID NOT NULL,
  asset_symbol  VARCHAR(16) NOT NULL,
  balance       NUMERIC NOT NULL DEFAULT 0,
  last_updated  TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (wallet_id, asset_symbol)
);

-- === Market Depth Stats ===
CREATE TABLE IF NOT EXISTS market_depth_stats (
  stat_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  market_symbol   VARCHAR(32) NOT NULL,
  best_bid        NUMERIC,
  best_ask        NUMERIC,
  bid_depth       NUMERIC,
  ask_depth       NUMERIC,
  spread          NUMERIC,
  stat_time       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- === Open Orders (Optional Pre-Match Queue) ===
CREATE TABLE IF NOT EXISTS open_orders (
  order_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  wallet_id       UUID NOT NULL,
  market_symbol   VARCHAR(32) NOT NULL,
  order_type      VARCHAR(10) CHECK (order_type IN ('limit', 'market')) NOT NULL,
  side            VARCHAR(10) CHECK (side IN ('buy', 'sell')) NOT NULL,
  price           NUMERIC,
  quantity        NUMERIC NOT NULL,
  status          VARCHAR(16) CHECK (status IN ('open', 'filled', 'cancelled', 'partial')) DEFAULT 'open',
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_open_orders_market ON open_orders(market_symbol);
CREATE INDEX IF NOT EXISTS idx_open_orders_wallet ON open_orders(wallet_id);
