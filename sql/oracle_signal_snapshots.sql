-- ==========================================================================
-- Table: oracle_signal_snapshots
-- Purpose: Stores timestamped oracle data used for predictions, consensus,
-- pricing, and decision logic.
-- ==========================================================================

CREATE TABLE IF NOT EXISTS oracle_signal_snapshots (
  snapshot_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  oracle_name       VARCHAR(128) NOT NULL,
  signal_type       VARCHAR(64) NOT NULL CHECK (
                      signal_type IN (
                        'price_feed',
                        'weather',
                        'sports',
                        'economic_index',
                        'election_result',
                        'custom_signal'
                      )
                    ),
  signal_value      JSONB NOT NULL,
  confidence_score  NUMERIC CHECK (confidence_score >= 0 AND confidence_score <= 1),
  received_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at        TIMESTAMPTZ,
  integrity_hash    VARCHAR(128),
  verified          BOOLEAN DEFAULT FALSE
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_oracle_name_signal_type  ON oracle_signal_snapshots(oracle_name, signal_type);
CREATE INDEX IF NOT EXISTS idx_oracle_received_at       ON oracle_signal_snapshots(received_at);
CREATE INDEX IF NOT EXISTS idx_oracle_verified          ON oracle_signal_snapshots(verified);
