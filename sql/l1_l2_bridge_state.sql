-- ============================================
-- 🔁 Table: l1_l2_bridge_state
-- ============================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'l1_l2_bridge_state'
  ) THEN
    CREATE TABLE l1_l2_bridge_state (
      bridge_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      origin_chain         TEXT NOT NULL,
      destination_chain    TEXT NOT NULL,
      asset_address        TEXT NOT NULL,
      bridge_status        TEXT NOT NULL CHECK (bridge_status IN ('pending', 'in_transit', 'finalized', 'failed')),
      message_hash         TEXT,
      tx_hash              TEXT,
      sequence_id          BIGINT,
      retry_count          INT DEFAULT 0,
      last_retry_at        TIMESTAMPTZ,
      finalized_at         TIMESTAMPTZ,
      created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

