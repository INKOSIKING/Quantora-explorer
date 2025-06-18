-- 🧠 POST_HUMAN_OBSERVATION_VECTORS — Cognitive state overlay logs

CREATE TABLE IF NOT EXISTS post_human_observation_vectors (
  vector_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_identifier    TEXT NOT NULL,
  observation_type    TEXT NOT NULL,
  intent_overlay      TEXT,
  entropy_profile     TEXT,
  timestamp           TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_obs_vector_agent ON post_human_observation_vectors(agent_identifier);
CREATE INDEX IF NOT EXISTS idx_obs_vector_type ON post_human_observation_vectors(observation_type);
