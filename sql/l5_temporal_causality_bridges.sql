-- 🛰️ L5_TEMPORAL_CAUSALITY_BRIDGES — Finality/intent linkage across timelines

CREATE TABLE IF NOT EXISTS l5_temporal_causality_bridges (
  bridge_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  origin_block_hash   VARCHAR(66) NOT NULL,
  target_block_hash   VARCHAR(66) NOT NULL,
  causality_vector    TEXT NOT NULL,
  bridge_weight       NUMERIC(6,5) CHECK (bridge_weight >= 0),
  reconciled_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_causality_origin ON l5_temporal_causality_bridges(origin_block_hash);
CREATE INDEX IF NOT EXISTS idx_causality_target ON l5_temporal_causality_bridges(target_block_hash);
