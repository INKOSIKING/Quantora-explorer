-- ============================================
-- Schema: Dashboard Metrics
-- Purpose: Provides metrics for UI dashboards
-- ============================================

-- === Block Statistics ===
CREATE TABLE IF NOT EXISTS dashboard_block_stats (
  stat_time          TIMESTAMPTZ PRIMARY KEY,
  block_count        INTEGER NOT NULL,
  avg_block_time     NUMERIC,
  avg_tx_per_block   NUMERIC,
  total_gas_used     BIGINT,
  total_gas_limit    BIGINT,
  created_at         TIMESTAMPTZ DEFAULT NOW()
);

-- === Transaction Statistics ===
CREATE TABLE IF NOT EXISTS dashboard_tx_stats (
  stat_time            TIMESTAMPTZ PRIMARY KEY,
  total_tx             BIGINT NOT NULL,
  failed_tx            BIGINT,
  pending_tx           BIGINT,
  avg_gas_price        NUMERIC,
  avg_tx_fee           NUMERIC,
  total_tx_volume      NUMERIC,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- === Account Statistics ===
CREATE TABLE IF NOT EXISTS dashboard_account_stats (
  stat_time            TIMESTAMPTZ PRIMARY KEY,
  new_accounts         INTEGER NOT NULL,
  total_accounts       BIGINT,
  active_accounts_24h  INTEGER,
  active_contracts_24h INTEGER,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- === Token Statistics ===
CREATE TABLE IF NOT EXISTS dashboard_token_stats (
  stat_time            TIMESTAMPTZ PRIMARY KEY,
  total_tokens         INTEGER,
  tokens_created_24h   INTEGER,
  top_token_address    VARCHAR(66),
  top_token_volume     NUMERIC,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- === Exchange Metrics ===
CREATE TABLE IF NOT EXISTS dashboard_exchange_stats (
  stat_time              TIMESTAMPTZ PRIMARY KEY,
  total_trades           BIGINT,
  total_trade_volume     NUMERIC,
  avg_trade_size         NUMERIC,
  active_pairs           INTEGER,
  created_at             TIMESTAMPTZ DEFAULT NOW()
);

-- === NFT Activity ===
CREATE TABLE IF NOT EXISTS dashboard_nft_stats (
  stat_time             TIMESTAMPTZ PRIMARY KEY,
  total_nft_transfers   BIGINT,
  nfts_minted_24h       INTEGER,
  unique_creators_24h   INTEGER,
  top_nft_collection    VARCHAR(255),
  created_at            TIMESTAMPTZ DEFAULT NOW()
);

-- === Chain Health ===
CREATE TABLE IF NOT EXISTS dashboard_chain_health (
  stat_time            TIMESTAMPTZ PRIMARY KEY,
  validator_uptime_pct NUMERIC,
  average_finality     NUMERIC,
  orphaned_blocks      INTEGER,
  reorg_events_24h     INTEGER,
  peer_count           INTEGER,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);
