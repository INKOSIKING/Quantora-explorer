-- ===================================================================================================
-- 🌊 Table: onchain_liquidity_flows
-- Description: Tracks liquidity movements across DEXes, pools, bridges, and token contracts on-chain.
-- Useful for analytics, MEV defense, bridge monitoring, risk detection, and protocol health.
-- ===================================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'onchain_liquidity_flows'
  ) THEN
    CREATE TABLE onchain_liquidity_flows (
      flow_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      source_address       TEXT,
      destination_address  TEXT,
      token_address        TEXT NOT NULL,
      token_symbol         TEXT,
      amount               NUMERIC(78, 0) NOT NULL,
      usd_value            NUMERIC(78, 2),
      protocol             TEXT, -- e.g. 'Uniswap', 'Hop', 'Curve'
      action_type          TEXT NOT NULL, -- e.g. 'add_liquidity', 'remove_liquidity', 'bridge', 'swap'
      chain_id             TEXT NOT NULL,
      tx_hash              TEXT,
      block_number         BIGINT,
      occurred_at          TIMESTAMPTZ NOT NULL,
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_liquidity_token_address ON onchain_liquidity_flows(token_address);
CREATE INDEX IF NOT EXISTS idx_liquidity_protocol_time ON onchain_liquidity_flows(protocol, occurred_at);
CREATE INDEX IF NOT EXISTS idx_liquidity_flow_direction ON onchain_liquidity_flows(source_address, destination_address);
