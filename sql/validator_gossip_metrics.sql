-- ===================================================
-- Table: validator_gossip_metrics
-- Purpose: Track gossip messages, propagation latency & relay behavior
-- Layer: Core Consensus / Validator Monitoring
-- ===================================================

CREATE TABLE IF NOT EXISTS validator_gossip_metrics (
  gossip_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  validator_address VARCHAR(66) NOT NULL,
  message_type      TEXT NOT NULL CHECK (message_type IN (
                        'block_proposal', 'attestation', 'sync_committee', 'slashing', 'voluntary_exit'
                      )),
  message_hash      VARCHAR(66) NOT NULL,
  propagation_delay_ms INT CHECK (propagation_delay_ms >= 0),
  peers_relayed_to  INT CHECK (peers_relayed_to >= 0),
  message_size_bytes INT CHECK (message_size_bytes >= 0),
  signature_valid   BOOLEAN NOT NULL DEFAULT TRUE,
  received_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- === Indexes ===
CREATE INDEX IF NOT EXISTS idx_gossip_validator_addr  ON validator_gossip_metrics(validator_address);
CREATE INDEX IF NOT EXISTS idx_gossip_message_type    ON validator_gossip_metrics(message_type);
CREATE INDEX IF NOT EXISTS idx_gossip_received_at     ON validator_gossip_metrics(received_at DESC);

-- === Trigger Function for updated_at ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_proc WHERE proname = 'fn_update_gossip_updated_at'
  ) THEN
    CREATE OR REPLACE FUNCTION fn_update_gossip_updated_at()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;
  END IF;
END
$$;

-- === Trigger Assignment ===
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_gossip_updated_at'
  ) THEN
    CREATE TRIGGER trg_gossip_updated_at
    BEFORE UPDATE ON validator_gossip_metrics
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_gossip_updated_at();
  END IF;
END
$$;
