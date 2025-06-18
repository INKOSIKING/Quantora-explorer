-- 📡 SEQUENCER_SIGNAL_HEALTH — Monitors rollup sequencer performance

CREATE TABLE IF NOT EXISTS sequencer_signal_health (
  signal_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sequencer_name      TEXT NOT NULL,
  region_zone         TEXT,
  last_heartbeat_at   TIMESTAMPTZ NOT NULL,
  drift_ms            BIGINT,
  missed_blocks       INTEGER,
  sync_status         TEXT CHECK (sync_status IN ('synced', 'drifting', 'offline')),
  checked_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_seq_signal_heartbeat ON sequencer_signal_health(sequencer_name, last_heartbeat_at);
