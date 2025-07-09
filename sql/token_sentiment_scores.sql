-- ===============================================================================================
-- 📊 Table: token_sentiment_scores
-- Description: Stores AI/ML or feed-based sentiment metrics for tokens, including historical trend,
-- confidence score, and associated metadata.
-- ===============================================================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_name = 'token_sentiment_scores'
  ) THEN
    CREATE TABLE token_sentiment_scores (
      sentiment_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      token_address      TEXT NOT NULL,
      token_symbol       TEXT NOT NULL,
      sentiment_score    NUMERIC(6,3) NOT NULL,       -- e.g. -1 to 1
      confidence_level   NUMERIC(5,2),                -- 0 to 100
      sentiment_type     TEXT DEFAULT 'aggregate',    -- e.g. 'social', 'market', 'news'
      captured_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      source             TEXT,                        -- e.g. 'twitter_feed', 'price_model'
      metadata           JSONB
    );
  END IF;
END;
$$;

-- 🔍 Indexes
CREATE INDEX IF NOT EXISTS idx_sentiment_token ON token_sentiment_scores(token_address);
CREATE INDEX IF NOT EXISTS idx_sentiment_symbol ON token_sentiment_scores(token_symbol);
CREATE INDEX IF NOT EXISTS idx_sentiment_captured_at ON token_sentiment_scores(captured_at);

