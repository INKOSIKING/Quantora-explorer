-- Portfolio & Watchlist
CREATE TABLE IF NOT EXISTS user_balances (
    user_id VARCHAR(64) NOT NULL,
    token VARCHAR(64) NOT NULL,
    amount NUMERIC DEFAULT 0,
    PRIMARY KEY(user_id, token)
);

CREATE TABLE IF NOT EXISTS watchlists (
    user_id VARCHAR(64) NOT NULL,
    address VARCHAR(128) NOT NULL,
    PRIMARY KEY(user_id, address)
);

-- Historical trade data for charts
CREATE TABLE IF NOT EXISTS trades (
    id SERIAL PRIMARY KEY,
    token VARCHAR(64) NOT NULL,
    price NUMERIC NOT NULL,
    volume NUMERIC NOT NULL,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Staking
CREATE TABLE IF NOT EXISTS staking (
    user_id VARCHAR(64) PRIMARY KEY,
    amount NUMERIC NOT NULL,
    since TIMESTAMPTZ NOT NULL
);

-- Referrals
CREATE TABLE IF NOT EXISTS referrals (
    referrer VARCHAR(64) NOT NULL,
    referred VARCHAR(64) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (referrer, referred)
);

CREATE TABLE IF NOT EXISTS referral_rewards (
    user_id VARCHAR(64) PRIMARY KEY,
    bonus NUMERIC DEFAULT 0
);

-- Loyalty Points
CREATE TABLE IF NOT EXISTS loyalty_points (
    user_id VARCHAR(64) PRIMARY KEY,
    points NUMERIC DEFAULT 0
);

-- Community: Comments & Bug Reports
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(64) NOT NULL,
    target VARCHAR(128) NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS bug_reports (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(64) NOT NULL,
    detail TEXT NOT NULL,
    page VARCHAR(128) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Verified contracts
ALTER TABLE contracts ADD COLUMN IF NOT EXISTS verified BOOLEAN DEFAULT FALSE;

-- Multi-tenant support
CREATE TABLE IF NOT EXISTS tenants (
    domain VARCHAR(128) PRIMARY KEY,
    branding JSONB,
    api_keys JSONB
);