-- ==========================================================
-- Table: consensus_time_sync
-- Purpose: Tracks validator time sync offsets and drifts
-- Used for latency correction and timestamp finality audits
-- ==========================================================

CREATE TABLE IF NOT EXISTS consensus_time_sync (
    sync_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    validator_address VARCHAR(66) NOT NULL,
    node_id           TEXT NOT NULL,
    reported_time     TIMESTAMPTZ NOT NULL,
    local_time        TIMESTAMPTZ NOT NULL,
    drift_millis      INTEGER NOT NULL,
    ntp_offset_millis INTEGER,
    sync_status       TEXT CHECK (sync_status IN ('accurate', 'drifting', 'unsynced')) DEFAULT 'accurate',
    region            TEXT,
    recorded_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_time_sync_validator ON consensus_time_sync(validator_address);
CREATE INDEX IF NOT EXISTS idx_time_sync_status ON consensus_time_sync(sync_status);
