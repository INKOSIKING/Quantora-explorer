-- ==========================================
-- Table: mev_capture_analysis
-- Purpose: Tracks MEV events, agents involved, and economic effect
-- ==========================================

CREATE TABLE IF NOT EXISTS mev_capture_analysis (
  mev_event_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  block_hash         VARCHAR(66) NOT NULL,
  tx_hash            VARCHAR(66) NOT NULL,
  validator_address  VARCHAR(66),
  searcher_address   VARCHAR(66),
  extracted_value    NUMERIC NOT NULL,
  technique_used     TEXT CHECK (technique_used IN (
    'arbitrage', 'sandwich', 'liquidation', 'frontrun', 'backrun', 'time-bandit', 'cross-domain'
  )),
  affected_protocols TEXT[],
  victim_address     VARCHAR(66),
  timestamp          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  notes              TEXT
);

CREATE INDEX IF NOT EXISTS idx_mev_event_block      ON mev_capture_analysis(block_hash);
CREATE INDEX IF NOT EXISTS idx_mev_event_validator  ON mev_capture_analysis(validator_address);
CREATE INDEX IF NOT EXISTS idx_mev_event_searcher   ON mev_capture_analysis(searcher_address);
CREATE INDEX IF NOT EXISTS idx_mev_event_tx_hash    ON mev_capture_analysis(tx_hash);
