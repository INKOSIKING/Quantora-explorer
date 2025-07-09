-- =====================================================
-- 🌐 Table: cross_chain_event_log
-- =====================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'cross_chain_event_log'
  ) THEN
    CREATE TABLE cross_chain_event_log (
      event_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      origin_chain         TEXT NOT NULL,
      destination_chain    TEXT NOT NULL,
      tx_hash              TEXT NOT NULL,
      block_number         BIGINT NOT NULL,
      event_type           TEXT NOT NULL CHECK (event_type IN ('lock', 'mint', 'burn', 'unlock', 'message', 'relay')),
      contract_address     TEXT,
      payload              JSONB,
      status               TEXT NOT NULL CHECK (status IN ('pending', 'confirmed', 'failed')),
      relayer              TEXT,
      confirmed_at         TIMESTAMPTZ,
      inserted_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

