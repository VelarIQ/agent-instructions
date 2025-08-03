-- VelarIQ Workflow Management Schema

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Workflows table
CREATE TABLE workflows (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    n8n_workflow_id VARCHAR(100) UNIQUE,
    version INTEGER DEFAULT 1,
    status VARCHAR(50) DEFAULT 'draft',
    config JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    tags TEXT[]
);

-- Workflow executions
CREATE TABLE workflow_executions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workflow_id UUID REFERENCES workflows(id) ON DELETE CASCADE,
    execution_id VARCHAR(100) UNIQUE,
    status VARCHAR(50) NOT NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP WITH TIME ZONE,
    duration_ms INTEGER,
    error_message TEXT,
    metadata JSONB DEFAULT '{}',
    metrics JSONB DEFAULT '{}'
);

-- AI interactions log
CREATE TABLE ai_interactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workflow_execution_id UUID REFERENCES workflow_executions(id) ON DELETE CASCADE,
    ai_provider VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    request_tokens INTEGER,
    response_tokens INTEGER,
    total_cost DECIMAL(10, 6),
    latency_ms INTEGER,
    request JSONB,
    response JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Error tracking
CREATE TABLE error_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workflow_execution_id UUID REFERENCES workflow_executions(id) ON DELETE CASCADE,
    error_type VARCHAR(100),
    error_code VARCHAR(50),
    error_message TEXT,
    stack_trace TEXT,
    recovery_action VARCHAR(100),
    node_id VARCHAR(100),
    occurred_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP WITH TIME ZONE,
    metadata JSONB DEFAULT '{}'
);

-- API usage tracking
CREATE TABLE api_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_name VARCHAR(100) NOT NULL,
    endpoint VARCHAR(255),
    method VARCHAR(10),
    status_code INTEGER,
    latency_ms INTEGER,
    request_size_bytes INTEGER,
    response_size_bytes INTEGER,
    workflow_execution_id UUID REFERENCES workflow_executions(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB DEFAULT '{}'
);

-- Knowledge base queries
CREATE TABLE knowledge_queries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    knowledge_base VARCHAR(100) NOT NULL,
    query_text TEXT NOT NULL,
    query_embedding VECTOR(1536),
    results_count INTEGER,
    relevance_scores FLOAT[],
    workflow_execution_id UUID REFERENCES workflow_executions(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB DEFAULT '{}'
);

-- Indexes
CREATE INDEX idx_workflows_status ON workflows(status);
CREATE INDEX idx_workflows_tags ON workflows USING GIN(tags);
CREATE INDEX idx_executions_workflow ON workflow_executions(workflow_id);
CREATE INDEX idx_executions_status ON workflow_executions(status);
CREATE INDEX idx_executions_started ON workflow_executions(started_at DESC);
CREATE INDEX idx_ai_interactions_execution ON ai_interactions(workflow_execution_id);
CREATE INDEX idx_ai_interactions_provider ON ai_interactions(ai_provider, model);
CREATE INDEX idx_errors_execution ON error_logs(workflow_execution_id);
CREATE INDEX idx_errors_type ON error_logs(error_type);
CREATE INDEX idx_api_usage_service ON api_usage(service_name);
CREATE INDEX idx_api_usage_created ON api_usage(created_at DESC);

-- Full text search
CREATE INDEX idx_workflows_search ON workflows USING GIN(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Updated timestamp trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_workflows_updated_at BEFORE UPDATE ON workflows
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Views
CREATE VIEW workflow_metrics AS
SELECT 
    w.id,
    w.name,
    COUNT(DISTINCT we.id) as total_executions,
    COUNT(DISTINCT CASE WHEN we.status = 'success' THEN we.id END) as successful_executions,
    COUNT(DISTINCT CASE WHEN we.status = 'error' THEN we.id END) as failed_executions,
    AVG(we.duration_ms) as avg_duration_ms,
    MAX(we.started_at) as last_execution
FROM workflows w
LEFT JOIN workflow_executions we ON w.id = we.workflow_id
GROUP BY w.id, w.name;

CREATE VIEW ai_usage_summary AS
SELECT 
    ai_provider,
    model,
    COUNT(*) as total_calls,
    SUM(request_tokens) as total_request_tokens,
    SUM(response_tokens) as total_response_tokens,
    SUM(total_cost) as total_cost,
    AVG(latency_ms) as avg_latency_ms,
    DATE_TRUNC('day', created_at) as date
FROM ai_interactions
GROUP BY ai_provider, model, DATE_TRUNC('day', created_at);
