-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    api_key VARCHAR(255) UNIQUE NOT NULL,
    tokens_allocated INTEGER DEFAULT 100000,
    tokens_used INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    stripe_subscription_id VARCHAR(255) UNIQUE,
    stripe_customer_id VARCHAR(255),
    plan_id VARCHAR(255),
    status VARCHAR(50),
    current_period_end TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Workflows table
CREATE TABLE IF NOT EXISTS workflows (
    id UUID PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    name VARCHAR(255),
    config JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Token usage logs
CREATE TABLE IF NOT EXISTS token_usage_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    tokens INTEGER,
    workflow_id UUID,
    timestamp TIMESTAMP DEFAULT NOW()
);

-- API request logs
CREATE TABLE IF NOT EXISTS api_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    endpoint VARCHAR(255),
    method VARCHAR(10),
    status_code INTEGER,
    response_time INTEGER,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT NOW()
);

-- Email journey table
CREATE TABLE IF NOT EXISTS email_journey (
    id SERIAL PRIMARY KEY,
    user_email VARCHAR(255),
    current_day INTEGER DEFAULT 1,
    started_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_users_api_key ON users(api_key);
CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_workflows_user ON workflows(user_id);
CREATE INDEX idx_token_logs_user ON token_usage_logs(user_id);
CREATE INDEX idx_api_logs_timestamp ON api_logs(timestamp);