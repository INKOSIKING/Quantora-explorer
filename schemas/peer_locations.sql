-- File: schemas/peer_locations.sql

CREATE TABLE IF NOT EXISTS peer_locations (
  peer_id       VARCHAR(128) PRIMARY KEY,
  ip_address    INET NOT NULL,
  country       VARCHAR(64),
  region        VARCHAR(64),
  city          VARCHAR(128),
  latitude      NUMERIC(10, 6),
  longitude     NUMERIC(10, 6),
  last_seen     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_peer_locations_country ON peer_locations (country);
CREATE INDEX IF NOT EXISTS idx_peer_locations_last_seen ON peer_locations (last_seen DESC);
