-- ============================================================
-- 📡 Table: consensus_epoch_metrics
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'consensus_epoch_metrics'
  ) THEN
    CREATE TABLE consensus_epoch_metrics (
      epoch_id             BIGINT PRIMARY KEY,
      start_block_number   BIGINT NOT NULL,
      end_block_number     BIGINT NOT NULL,
      validator_count      INT NOT NULL,
      active_validators    INT NOT NULL,
      missed_blocks        INT NOT NULL,
      slashed_validators   INT DEFAULT 0,
      average_latency_ms   NUMERIC(10,2),
      finality_delay_sec   NUMERIC(10,2),
      epoch_hash           TEXT,
      consistency_score    NUMERIC(5,2),
      created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END;
$$;

-- 📊 Indexes
CREATE INDEX IF NOT EXISTS idx_epoch_range ON consensus_epoch_metrics(start_block_number, end_block_number);
