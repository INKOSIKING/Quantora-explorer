-- 📊 Table: blockchain_state_aging
CREATE TABLE IF NOT EXISTS blockchain_state_aging (
  aging_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  block_hash        VARCHAR(66) NOT NULL,
  block_height      BIGINT NOT NULL,
  age_ms            BIGINT NOT NULL,
  recorded_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_state_aging_block ON blockchain_state_aging(block_height);

-- ⚙️ Table: l2_rollup_metrics
CREATE TABLE IF NOT EXISTS l2_rollup_metrics (
  metric_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rollup_name       TEXT NOT NULL,
  batch_start       BIGINT NOT NULL,
  batch_end         BIGINT NOT NULL,
  tx_count          INTEGER NOT NULL,
  proof_generation_ms BIGINT,
  calldata_size     BIGINT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_l2_rollup_name ON l2_rollup_metrics(rollup_name);
CREATE INDEX IF NOT EXISTS idx_l2_rollup_batch_at ON l2_rollup_metrics(batch_start);
