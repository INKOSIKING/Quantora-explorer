-- ==================================================================================
-- Table: oracle_feed_events
-- Purpose: Logs external data delivered to the blockchain via oracles
-- ==================================================================================

CREATE TABLE IF NOT EXISTS oracle_feed_events (
  event_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  oracle_name      TEXT NOT NULL,                         -- E.g., Chainlink, internal_oracle_1
  feed_type        TEXT NOT NULL,                         -- E.g., price_feed, weather_data
  asset_symbol     TEXT,                                  -- If applicable (e.g., BTC, ETH, ZAR)
  payload          JSONB NOT NULL,                        -- Raw data delivered by the oracle
  received_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),    -- Time oracle data received
  block_hash       VARCHAR(66),                           -- Optional blockchain block tie-in
  tx_hash          VARCHAR(66),                           -- If delivered via on-chain transaction
  status           TEXT CHECK (status IN ('pending', 'verified', 'rejected')),
  error_message    TEXT,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_oracle_feed_events_name ON oracle_feed_events(oracle_name);
CREATE INDEX IF NOT EXISTS idx_oracle_feed_events_feed ON oracle_feed_events(feed_type);
CREATE INDEX IF NOT EXISTS idx_oracle_feed_events_asset ON oracle_feed_events(asset_symbol);
CREATE INDEX IF NOT EXISTS idx_oracle_feed_events_status ON oracle_feed_events(status);
