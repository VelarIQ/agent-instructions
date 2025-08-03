#!/bin/bash

# Create directory structure
mkdir -p knowledge-base schemas scripts

# Create README.md
cat > README.md << 'EOF'
# DO Agent Instructions - Enterprise Workflow Builder

I build production-grade n8n workflows with AI mesh architecture, self-healing capabilities, and VelarIQ integration.

## My Process
1. **Gather Requirements** - Understand workflow objectives and integrations
2. **Validate Resources** - Check available APIs, data sources, and outputs
3. **Build Workflow** - Create n8n workflow with error handling and logging
4. **Test & Optimize** - Ensure reliability and performance
5. **Deliver** - Provide workflow JSON and documentation

## Core Capabilities

### AI Mesh Architecture
- Multi-model orchestration (GPT-4, Claude, Gemini, Grok, Perplexity)
- Intelligent routing based on task requirements
- Fallback chains for reliability
- Response validation and quality scoring

### Self-Healing Workflows
- Automatic retry with exponential backoff
- Error classification and smart recovery
- Circuit breakers for failing services
- Health checks and monitoring hooks

### Production Standards
- Comprehensive error handling
- Structured logging with correlation IDs
- Rate limiting and quota management
- Security best practices (env vars, encryption)
- Performance optimization

## Integration Ecosystem

### Knowledge Bases
- `knowledge-base-startradingnow` - Trading strategies and market analysis
- `knowledge-base-twobrain` - Fitness and gym management

### AI Services
- OpenAI GPT-4 (general intelligence)
- Anthropic Claude (complex reasoning)
- Google Gemini (multimodal tasks)
- X.AI Grok (real-time information)
- Perplexity (research queries)

### Infrastructure
- PostgreSQL (workflow state, metrics)
- Redis (caching, rate limiting)
- Weaviate (vector search, embeddings)
- DO Spaces (file storage, backups)

### Communication
- Slack (notifications, commands)
- SendGrid (email automation)
- Social Media APIs (content distribution)

## Workflow Patterns

### 1. Basic API Integration
```json
{
  "nodes": [{
    "type": "n8n-nodes-base.httpRequest",
    "parameters": {
      "authentication": "genericCredentialType",
      "genericAuthType": "httpHeaderAuth"
    }
  }]
}
```

### 2. AI Router Pattern
Routes requests to appropriate AI model based on:
- Task complexity
- Required capabilities
- Cost optimization
- Latency requirements

### 3. Error Recovery Chain
1. Primary attempt
2. Retry with backoff
3. Fallback service
4. Graceful degradation
5. Alert and log

### 4. Batch Processing
- Chunking for large datasets
- Parallel processing
- Progress tracking
- Result aggregation

## Best Practices

### Security
- All credentials in environment variables
- API key rotation reminders
- Encrypted storage for sensitive data
- Audit logging

### Performance
- Connection pooling
- Response caching
- Lazy loading
- Query optimization

### Monitoring
- Datadog/Grafana integration
- Custom metrics
- Alert thresholds
- SLA tracking

## Example Workflows

### 1. AI Content Pipeline
- Trigger: Webhook/Schedule
- Generate content with GPT-4
- Enhance with Claude
- Fact-check with Perplexity
- Optimize with Gemini
- Publish to multiple channels

### 2. Data Processing
- Ingest from multiple sources
- Clean and validate
- Enrich with AI
- Store in PostgreSQL/Weaviate
- Generate insights

### 3. Customer Support Bot
- Slack/Email trigger
- Context retrieval from knowledge base
- AI response generation
- Human escalation rules
- Feedback loop

## Available Resources

### Credentials (via env vars)
- `N8N_API_KEY` - N8N instance access
- `OPENAI_API_KEY` - GPT-4 access
- `ANTHROPIC_API_KEY` - Claude access
- `DB_PASSWORD` - PostgreSQL
- `REDIS_PASSWORD` - Redis cache
- `WEAVIATE_API_KEY` - Vector DB
- All other service keys in environment

### Endpoints
- N8N: `http://167.71.180.39:5678`
- PostgreSQL: `165.227.116.69:5432`
- Redis: `134.209.173.59:6379`
- Weaviate: `https://blcrrxlmtoqofluebp5tlw.c0.us-west3.gcp.weaviate.cloud`

## Quick Start

1. Describe your workflow requirements
2. I'll design the architecture
3. Build and test the workflow
4. Provide deployment-ready JSON
5. Include monitoring setup

Need a workflow? Just ask!
EOF

# Create .env.example
cat > .env.example << 'EOF'
# PostgreSQL Database
DB_HOST=165.227.116.69
DB_PORT=5432
DB_NAME=velariq_workflows
DB_USER=postgres
DB_PASSWORD=your_password_here

# Redis Cache
REDIS_HOST=134.209.173.59
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password

# N8N Workflow Engine
N8N_URL=http://167.71.180.39:5678
N8N_USER=your_n8n_user
N8N_PASSWORD=your_n8n_password
N8N_API_KEY=your_n8n_api_key

# Digital Ocean Spaces
DO_SPACES_KEY=your_spaces_key
DO_SPACES_SECRET=your_spaces_secret
DO_SPACES_BUCKET=velariq
DO_SPACES_REGION=nyc3
DO_SPACES_ENDPOINT=https://velariq.nyc3.digitaloceanspaces.com

# Weaviate Vector Database
WEAVIATE_URL=https://blcrrxlmtoqofluebp5tlw.c0.us-west3.gcp.weaviate.cloud
WEAVIATE_API_KEY=your_weaviate_key

# AI Services
OPENAI_API_KEY=sk-proj-xxxxx
ANTHROPIC_API_KEY=sk-ant-xxxxx
GOOGLE_GEMINI_API_KEY=AIzaSyXXXXX
XAI_API_KEY=xai-xxxxx
PERPLEXITY_API_KEY=pplx-xxxxx

# Communication Services
SLACK_BOT_TOKEN=xoxb-xxxxx
SLACK_WORKSPACE=your_workspace
SENDGRID_API_KEY=SG.xxxxx

# VelarIQ Domains
DOMAIN_PRIMARY=velariq.ai
DOMAIN_SECONDARY=quantiumiq.ai
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Environment variables
.env
.env.*
!.env.example

# Secrets
*.key
*.pem
secrets.json
credentials.json

# Dependencies
node_modules/
package-lock.json

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Logs
*.log
logs/

# Temporary files
*.tmp
*.temp
.cache/
EOF

# Create knowledge-base files
cat > knowledge-base/patterns.json << 'EOF'
{
  "workflow_patterns": {
    "ai_mesh": {
      "description": "Multi-AI orchestration pattern",
      "use_cases": ["Complex reasoning", "Redundancy", "Best-of-breed selection"],
      "implementation": {
        "router_node": "Evaluates request and selects optimal AI",
        "parallel_processing": "Query multiple AIs simultaneously",
        "response_aggregation": "Combine and validate responses",
        "fallback_chain": ["primary_ai", "secondary_ai", "fallback_ai"]
      }
    },
    "self_healing": {
      "description": "Automatic error recovery pattern",
      "components": {
        "error_classifier": "Categorizes errors for appropriate handling",
        "retry_logic": "Exponential backoff with jitter",
        "circuit_breaker": "Prevents cascade failures",
        "health_checks": "Proactive service monitoring"
      }
    },
    "batch_processing": {
      "description": "Large dataset handling",
      "strategies": {
        "chunking": "Process data in manageable pieces",
        "parallel_execution": "Concurrent processing paths",
        "checkpoint_recovery": "Resume from last successful state",
        "resource_management": "Memory and rate limit awareness"
      }
    }
  }
}
EOF

cat > knowledge-base/prompts.md << 'EOF'
# AI Prompts Library

## System Prompts

### GPT-4 System Prompt
```
You are an AI assistant integrated into an n8n workflow system. 
Provide accurate, helpful responses while maintaining context 
awareness of the workflow environment. Format outputs for 
downstream processing.
```

### Claude System Prompt
```
You are Claude, operating within an automated workflow. Focus on 
detailed analysis and nuanced reasoning. Structure your responses 
for integration with other workflow nodes.
```

## Task-Specific Prompts

### Data Extraction
```
Extract the following information from the provided text:
- [Field 1]
- [Field 2]
- [Field 3]

Return as JSON with the exact field names specified.
```

### Content Generation
```
Generate [content type] based on these parameters:
- Tone: [professional/casual/technical]
- Length: [word count]
- Key points: [list]
- Target audience: [description]
```

### Error Analysis
```
Analyze this error and provide:
1. Root cause identification
2. Recommended fix
3. Prevention strategies
Return structured JSON response.
```

## Chaining Prompts

### Initial Analysis
```
Analyze the provided data and identify:
1. Key patterns
2. Anomalies
3. Actionable insights
```

### Enhancement Prompt
```
Based on the initial analysis:
[Previous output]

Provide detailed recommendations for:
1. Optimization opportunities
2. Risk mitigation
3. Implementation steps
```

## Validation Prompts

### Response Validator
```
Validate the following response against these criteria:
- Accuracy: [criteria]
- Completeness: [requirements]
- Format: [specification]

Return validation result with confidence score.
```
EOF

cat > knowledge-base/integrations.md << 'EOF'
# Integration Guide

## API Integrations

### OpenAI
- Endpoint: `https://api.openai.com/v1/`
- Auth: Bearer token
- Models: gpt-4, gpt-3.5-turbo
- Rate limits: 10000 TPM, 1000 RPM

### Anthropic Claude
- Endpoint: `https://api.anthropic.com/v1/`
- Auth: x-api-key header
- Models: claude-3-opus, claude-3-sonnet
- Rate limits: Based on tier

### Google Gemini
- Endpoint: `https://generativelanguage.googleapis.com/v1/`
- Auth: API key
- Models: gemini-pro, gemini-pro-vision
- Features: Multimodal support

### Weaviate
- Endpoint: `https://blcrrxlmtoqofluebp5tlw.c0.us-west3.gcp.weaviate.cloud`
- Auth: API key
- Operations: Vector search, CRUD, batch import

## Database Connections

### PostgreSQL
```javascript
{
  host: process.env.DB_HOST,
  port: 5432,
  database: 'velariq_workflows',
  user: 'postgres',
  password: process.env.DB_PASSWORD,
  ssl: { rejectUnauthorized: false }
}
```

### Redis
```javascript
{
  host: process.env.REDIS_HOST,
  port: 6379,
  password: process.env.REDIS_PASSWORD,
  db: 0
}
```

## Webhook Endpoints

### Incoming Webhooks
- Base URL: `http://167.71.180.39:5678/webhook/`
- Test endpoint: `/webhook-test/[workflow-id]`
- Production: `/webhook/[workflow-id]`

### Webhook Security
- HMAC validation
- IP whitelisting
- Rate limiting
- Request logging

## File Storage

### DO Spaces
- Bucket: `velariq`
- Region: `nyc3`
- URL pattern: `https://velariq.nyc3.digitaloceanspaces.com/[path]`
- Operations: Upload, download, delete, list

## Communication Channels

### Slack
- Workspace: `velariq`
- Bot permissions: chat:write, files:write, channels:read
- Event subscriptions: message.channels, app_mention

### Email (SendGrid)
- From domain: `@velariq.ai`
- Templates: Stored in DO Spaces
- Tracking: Opens, clicks, bounces

## Authentication Patterns

### API Key Authentication
```javascript
headers: {
  'Authorization': `Bearer ${process.env.API_KEY}`,
  'Content-Type': 'application/json'
}
```

### OAuth2 Flow
- Authorization endpoint
- Token exchange
- Refresh token handling
- Scope management
EOF

cat > knowledge-base/error-handling.json << 'EOF'
{
  "error_categories": {
    "rate_limit": {
      "indicators": ["429", "rate_limit", "quota_exceeded"],
      "handling": {
        "strategy": "exponential_backoff",
        "initial_delay": 1000,
        "max_retries": 5,
        "fallback": "queue_for_later"
      }
    },
    "authentication": {
      "indicators": ["401", "403", "unauthorized", "forbidden"],
      "handling": {
        "strategy": "refresh_and_retry",
        "max_attempts": 2,
        "fallback": "alert_admin"
      }
    },
    "timeout": {
      "indicators": ["ETIMEDOUT", "ECONNRESET", "timeout"],
      "handling": {
        "strategy": "retry_with_shorter_timeout",
        "timeout_reduction": 0.5,
        "max_retries": 3,
        "fallback": "use_cached_response"
      }
    },
    "server_error": {
      "indicators": ["500", "502", "503", "504"],
      "handling": {
        "strategy": "circuit_breaker",
        "threshold": 5,
        "timeout": 60000,
        "fallback": "use_alternative_service"
      }
    },
    "validation": {
      "indicators": ["400", "validation_error", "invalid_request"],
      "handling": {
        "strategy": "parse_and_fix",
        "max_attempts": 1,
        "fallback": "log_and_skip"
      }
    }
  },
  "recovery_strategies": {
    "exponential_backoff": {
      "formula": "min(initial_delay * Math.pow(2, attempt), max_delay)",
      "jitter": true,
      "max_delay": 60000
    },
    "circuit_breaker": {
      "states": ["closed", "open", "half_open"],
      "failure_threshold": 5,
      "recovery_timeout": 60000,
      "monitoring_period": 120000
    },
    "retry_policies": {
      "default": {
        "max_attempts": 3,
        "backoff_multiplier": 2,
        "randomization_factor": 0.5
      },
      "aggressive": {
        "max_attempts": 10,
        "backoff_multiplier": 1.5,
        "randomization_factor": 0.3
      },
      "conservative": {
        "max_attempts": 2,
        "backoff_multiplier": 3,
        "randomization_factor": 0.7
      }
    }
  },
  "logging_templates": {
    "error_log": {
      "timestamp": "ISO8601",
      "correlation_id": "UUID",
      "workflow_id": "string",
      "node_id": "string",
      "error_type": "string",
      "error_message": "string",
      "stack_trace": "string",
      "context": "object",
      "recovery_action": "string"
    }
  }
}
EOF

cat > knowledge-base/velariq-integration.example.json << 'EOF'
{
  "infrastructure": {
    "domains": ["velariq.ai", "quantiumiq.ai"],
    "n8n_url": "${N8N_URL}",
    "postgres": "postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}/${DB_NAME}",
    "redis": "${REDIS_HOST}:${REDIS_PORT}",
    "weaviate": "${WEAVIATE_URL}"
  },
  "services": {
    "knowledge_bases": [
      "knowledge-base-startradingnow",
      "knowledge-base-twobrain"
    ],
    "ai_models": [
      "gpt-4",
      "claude-3",
      "gemini-pro",
      "grok",
      "perplexity"
    ],
    "communication": [
      "slack",
      "sendgrid",
      "social_apis"
    ]
  },
  "deployment": {
    "platform": "digital_ocean",
    "monitoring": "datadog",
    "logging": "do_logs",
    "backups": "do_spaces"
  }
}
EOF

cat > knowledge-base/secure-connections.example.md << 'EOF'
# Secure Connections Guide

## Environment Variable Usage

All connections must use environment variables. Never hardcode credentials.

### Database Connections
```javascript
// PostgreSQL
const pgClient = new Client({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl: { rejectUnauthorized: false }
});

// Redis
const redisClient = createClient({
  host: process.env.REDIS_HOST,
  port: process.env.REDIS_PORT,
  password: process.env.REDIS_PASSWORD
});
```

### API Connections
```javascript
// OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

// Anthropic
const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY
});

// Generic API
const headers = {
  'Authorization': `Bearer ${process.env.API_KEY}`,
  'Content-Type': 'application/json'
};
```

## Security Best Practices

1. **Credential Rotation**
   - Rotate API keys quarterly
   - Update in DO environment variables
   - No downtime deployment

2. **Access Control**
   - Use least privilege principle
   - Service-specific credentials
   - IP whitelisting where possible

3. **Encryption**
   - TLS for all connections
   - Encrypt sensitive data at rest
   - Use DO Spaces encryption

4. **Monitoring**
   - Log all authentication attempts
   - Alert on repeated failures
   - Track API usage patterns

## DO App Platform Configuration

```yaml
envs:
  - key: DB_HOST
    value: "165.227.116.69"
    type: "SECRET"
  - key: DB_PASSWORD
    value: "${DB_PASSWORD}"
    type: "SECRET"
  - key: OPENAI_API_KEY
    value: "${OPENAI_API_KEY}"
    type: "SECRET"
```

## Testing Connections

Always test connections before deployment:

```bash
node scripts/test-connections.js
```

This validates all service connections using environment variables.
EOF

# Create schema files
cat > schemas/postgres.sql << 'EOF'
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
EOF

cat > schemas/weaviate.json << 'EOF'
{
  "classes": [
    {
      "class": "WorkflowTemplate",
      "description": "N8N workflow templates and patterns",
      "vectorizer": "text2vec-openai",
      "moduleConfig": {
        "text2vec-openai": {
          "model": "text-embedding-ada-002",
          "type": "text"
        }
      },
      "properties": [
        {
          "name": "name",
          "dataType": ["text"],
          "description": "Template name"
        },
        {
          "name": "description",
          "dataType": ["text"],
          "description": "Template description"
        },
        {
          "name": "category",
          "dataType": ["text"],
          "description": "Template category"
        },
        {
          "name": "workflow_json",
          "dataType": ["text"],
          "description": "N8N workflow JSON"
        },
        {
          "name": "tags",
          "dataType": ["text[]"],
          "description": "Template tags"
        },
        {
          "name": "use_count",
          "dataType": ["int"],
          "description": "Number of times used"
        },
        {
          "name": "created_at",
          "dataType": ["date"],
          "description": "Creation timestamp"
        }
      ]
    },
    {
      "class": "KnowledgeArticle",
      "description": "Knowledge base articles",
      "vectorizer": "text2vec-openai",
      "moduleConfig": {
        "text2vec-openai": {
          "model": "text-embedding-ada-002",
          "type": "text"
        }
      },
      "properties": [
        {
          "name": "title",
          "dataType": ["text"],
          "description": "Article title"
        },
        {
          "name": "content",
          "dataType": ["text"],
          "description": "Article content"
        },
        {
          "name": "knowledge_base",
          "dataType": ["text"],
          "description": "Source knowledge base"
        },
        {
          "name": "category",
          "dataType": ["text"],
          "description": "Article category"
        },
        {
          "name": "tags",
          "dataType": ["text[]"],
          "description": "Article tags"
        },
        {
          "name": "relevance_score",
          "dataType": ["number"],
          "description": "Article relevance score"
        },
        {
          "name": "last_updated",
          "dataType": ["date"],
          "description": "Last update timestamp"
        }
      ]
    },
    {
      "class": "ErrorPattern",
      "description": "Common error patterns and solutions",
      "vectorizer": "text2vec-openai",
      "moduleConfig": {
        "text2vec-openai": {
          "model": "text-embedding-ada-002",
          "type": "text"
        }
      },
      "properties": [
        {
          "name": "error_type",
          "dataType": ["text"],
          "description": "Type of error"
        },
        {
          "name": "error_message",
          "dataType": ["text"],
          "description": "Error message pattern"
        },
        {
          "name": "solution",
          "dataType": ["text"],
          "description": "Recommended solution"
        },
        {
          "name": "root_cause",
          "dataType": ["text"],
          "description": "Root cause analysis"
        },
        {
          "name": "prevention",
          "dataType": ["text"],
          "description": "Prevention strategies"
        },
        {
          "name": "occurrence_count",
          "dataType": ["int"],
          "description": "Number of occurrences"
        },
        {
          "name": "last_seen",
          "dataType": ["date"],
          "description": "Last occurrence timestamp"
        }
      ]
    },
    {
      "class": "AIPrompt",
      "description": "Effective AI prompts library",
      "vectorizer": "text2vec-openai",
      "moduleConfig": {
        "text2vec-openai": {
          "model": "text-embedding-ada-002",
          "type": "text"
        }
      },
      "properties": [
        {
          "name": "name",
          "dataType": ["text"],
          "description": "Prompt name"
        },
        {
          "name": "prompt_text",
          "dataType": ["text"],
          "description": "The actual prompt"
        },
        {
          "name": "ai_model",
          "dataType": ["text"],
          "description": "Target AI model"
        },
        {
          "name": "use_case",
          "dataType": ["text"],
          "description": "Primary use case"
        },
        {
          "name": "parameters",
          "dataType": ["text"],
          "description": "Configurable parameters"
        },
        {
          "name": "effectiveness_score",
          "dataType": ["number"],
          "description": "Effectiveness rating"
        },
        {
          "name": "usage_count",
          "dataType": ["int"],
          "description": "Times used"
        }
      ]
    }
  ]
}
EOF

# Create scripts
cat > scripts/test-connections.js << 'EOF'
#!/usr/bin/env node

require('dotenv').config();
const { Client } = require('pg');
const redis = require('redis');
const axios = require('axios');

const tests = {
  postgres: async () => {
    console.log('Testing PostgreSQL connection...');
    const client = new Client({
      host: process.env.DB_HOST,
      port: process.env.DB_PORT || 5432,
      database: process.env.DB_NAME || 'velariq_workflows',
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD
    });
    
    try {
      await client.connect();
      const res = await client.query('SELECT NOW()');
      console.log('✅ PostgreSQL connected:', res.rows[0].now);
    } catch (err) {
      console.error('❌ PostgreSQL failed:', err.message);
    } finally {
      await client.end();
    }
  },

  redis: async () => {
    console.log('Testing Redis connection...');
    const client = redis.createClient({
      socket: {
        host: process.env.REDIS_HOST,
        port: process.env.REDIS_PORT || 6379
      },
      password: process.env.REDIS_PASSWORD
    });
    
    try {
      await client.connect();
      await client.set('test', 'value');
      const value = await client.get('test');
      console.log('✅ Redis connected: test =', value);
    } catch (err) {
      console.error('❌ Redis failed:', err.message);
    } finally {
      await client.quit();
    }
  },

  n8n: async () => {
    console.log('Testing N8N API connection...');
    try {
      const response = await axios.get(`${process.env.N8N_URL}/api/v1/workflows`, {
        headers: {
          'X-N8N-API-KEY': process.env.N8N_API_KEY
        }
      });
      console.log('✅ N8N API connected: Found', response.data.data.length, 'workflows');
    } catch (err) {
      console.error('❌ N8N API failed:', err.message);
    }
  },

  weaviate: async () => {
    console.log('Testing Weaviate connection...');
    try {
      const response = await axios.get(`${process.env.WEAVIATE_URL}/v1/schema`, {
        headers: {
          'Authorization': `Bearer ${process.env.WEAVIATE_API_KEY}`
        }
      });
      console.log('✅ Weaviate connected: Found', response.data.classes.length, 'classes');
    } catch (err) {
      console.error('❌ Weaviate failed:', err.message);
    }
  },

  openai: async () => {
    console.log('Testing OpenAI API...');
    try {
      const response = await axios.get('https://api.openai.com/v1/models', {
        headers: {
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
        }
      });
      console.log('✅ OpenAI API connected');
    } catch (err) {
      console.error('❌ OpenAI API failed:', err.response?.data?.error?.message || err.message);
    }
  }
};

// Run all tests
async function runTests() {
  console.log('🔧 VelarIQ Connection Tests\n');
  
  for (const [name, test] of Object.entries(tests)) {
    await test();
    console.log('');
  }
  
  console.log('✨ Tests complete!');
}

runTests().catch(console.error);
EOF

cat > scripts/deploy.sh << 'EOF'
#!/bin/bash

echo "🚀 Deploying to Digital Ocean..."

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "❌ doctl CLI not found. Please install it first."
    exit 1
fi

# Get app ID from environment or prompt
APP_ID=${DO_APP_ID:-""}
if [ -z "$APP_ID" ]; then
    echo "Enter your DO App ID:"
    read APP_ID
fi

# Deploy
echo "📦 Creating deployment..."
doctl apps create-deployment $APP_ID

# Monitor deployment
echo "👀 Monitoring deployment status..."
doctl apps get-deployment $APP_ID --format ID,Phase,Progress

echo "✅ Deployment initiated!"
echo "View progress at: https://cloud.digitalocean.com/apps/$APP_ID"
EOF

# Create package.json
cat > package.json << 'EOF'
{
  "name": "velariq-workflow-builder",
  "version": "1.0.0",
  "description": "Enterprise n8n workflow builder with AI mesh",
  "scripts": {
    "test": "node scripts/test-connections.js",
    "deploy": "bash scripts/deploy.sh"
  },
  "dependencies": {
    "pg": "^8.11.3",
    "redis": "^4.6.7",
    "axios": "^1.5.0",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {},
  "keywords": ["n8n", "workflow", "ai", "automation"],
  "author": "VelarIQ",
  "license": "MIT"
}
EOF

# Make scripts executable
chmod +x scripts/deploy.sh
chmod +x scripts/test-connections.js

echo "✅ All files created successfully!"
echo ""
echo "📁 Created structure:"
echo "├── README.md"
echo "├── .env.example"
echo "├── .gitignore"
echo "├── package.json"
echo "├── knowledge-base/"
echo "│   ├── patterns.json"
echo "│   ├── prompts.md"
echo "│   ├── integrations.md"
echo "│   ├── error-handling.json"
echo "│   ├── velariq-integration.example.json"
echo "│   └── secure-connections.example.md"
echo "├── schemas/"
echo "│   ├── postgres.sql"
echo "│   └── weaviate.json"
echo "└── scripts/"
echo "    ├── test-connections.js"
echo "    └── deploy.sh"
echo ""
echo "Next steps:"
echo "1. Copy .env.example to .env and add actual values"
echo "2. Run: npm install"
echo "3. Test connections: npm test"
echo "4. Commit and push to GitHub"