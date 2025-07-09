-- ========================================
-- 🌉 Table: bridge_events
-- ========================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'bridge_events'
  ) THEN
    CREATE TABLE bridge_events (
      event_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      bridge_name        TEXT NOT NULL,
      direction          TEXT CHECK (direction IN ('INBOUND', 'OUTBOUND')),
      source_chain       TEXT NOT NULL,
      destination_chain  TEXT NOT NULL,
      source_tx_hash     TEXT NOT NULL,
      destination_tx_hash TEXT,
      asset              TEXT NOT NULL,
      amount             NUMERIC(78, 0) NOT NULL,
      status             TEXT CHECK (status IN ('PENDING', 'CONFIRMED', 'FAILED')) NOT NULL DEFAULT 'PENDING',
      payload            JSONB,
      detected_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      confirmed_at       TIMESTAMPTZ,
      retries            INT DEFAULT 0
    );
  END IF;
END;
$$;

