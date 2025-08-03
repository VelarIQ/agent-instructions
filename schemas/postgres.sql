-- PostgreSQL Schema
CREATE TABLE workflows (
  id UUID PRIMARY KEY,
  name VARCHAR(255),
  description TEXT,
  n8n_workflow_id VARCHAR(100),
  created_by VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  version INT,
  status VARCHAR(50),
  config JSONB
);

CREATE TABLE conversations (
  id UUID PRIMARY KEY,
  user_id VARCHAR(255),
  started_at TIMESTAMP,
  context JSONB,
  workflow_ids UUID[]
);

CREATE TABLE executions (
  id UUID PRIMARY KEY,
  workflow_id UUID,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  status VARCHAR(50),
  logs JSONB,
  metrics JSONB
);
