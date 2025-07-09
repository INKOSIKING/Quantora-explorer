-- ============================================================
-- 🧩 Table: chain_integrity_gaps
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables WHERE table_name = 'chain_integrity_gaps'
  ) THEN
    CREATE TABLE chain_integrity_gaps (
      gap_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      missing_from      BIGINT NOT NULL,
      missing_to        BIGINT NOT NULL,
      estimated_gap     INT NOT NULL,
      detection_method  TEXT NOT NULL,
      detected_by       TEXT,
      reason            TEXT,
      severity          TEXT CHECK (severity IN ('low', 'moderate', 'high', 'critical')) NOT NULL DEFAULT 'moderate',
      detected_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      resolved          BOOLEAN DEFAULT FALSE,
      resolution_notes  TEXT,
      resolved_at       TIMESTAMPTZ
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_gap_range ON chain_integrity_gaps(missing_from, missing_to);
CREATE INDEX IF NOT EXISTS idx_gap_detected_at ON chain_integrity_gaps(detected_at);
