#!/bin/bash

cd /Users/leightonbingham/Documents/github/agent-instructions

# Update .env.example to remove sensitive data
cat > .env.example << 'EOF'
# All values loaded from environment
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

REDIS_HOST=${REDIS_HOST}
REDIS_PORT=${REDIS_PORT}
REDIS_PASSWORD=${REDIS_PASSWORD}

N8N_URL=${N8N_URL}
N8N_USER=${N8N_USER}
N8N_PASSWORD=${N8N_PASSWORD}
N8N_API_KEY=${N8N_API_KEY}

WEAVIATE_URL=${WEAVIATE_URL}
WEAVIATE_API_KEY=${WEAVIATE_API_KEY}

DO_SPACES_KEY=${DO_SPACES_KEY}
DO_SPACES_SECRET=${DO_SPACES_SECRET}
DO_SPACES_BUCKET=${DO_SPACES_BUCKET}
DO_SPACES_REGION=${DO_SPACES_REGION}
DO_SPACES_ENDPOINT=${DO_SPACES_ENDPOINT}

OPENAI_API_KEY=${OPENAI_API_KEY}
ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
GOOGLE_GEMINI_API_KEY=${GOOGLE_GEMINI_API_KEY}
XAI_API_KEY=${XAI_API_KEY}
PERPLEXITY_API_KEY=${PERPLEXITY_API_KEY}

SLACK_BOT_TOKEN=${SLACK_BOT_TOKEN}
SLACK_WORKSPACE=${SLACK_WORKSPACE}
SENDGRID_API_KEY=${SENDGRID_API_KEY}

DOMAIN_PRIMARY=${DOMAIN_PRIMARY}
DOMAIN_SECONDARY=${DOMAIN_SECONDARY}
EOF

# Update velariq-integration.example.json
cat > knowledge-base/velariq-integration.example.json << 'EOF'
{
  "infrastructure": {
    "domains": ["${DOMAIN_PRIMARY}", "${DOMAIN_SECONDARY}"],
    "n8n_url": "${N8N_URL}",
    "postgres": "postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}",
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

# Update integrations.md to remove IPs
sed -i '' 's/165\.227\.116\.69/${DB_HOST}/g' knowledge-base/integrations.md
sed -i '' 's/134\.209\.173\.59/${REDIS_HOST}/g' knowledge-base/integrations.md
sed -i '' 's/167\.71\.180\.39:5678/${N8N_URL}/g' knowledge-base/integrations.md
sed -i '' 's/https:\/\/blcrrxlmtoqofluebp5tlw\.c0\.us-west3\.gcp\.weaviate\.cloud/${WEAVIATE_URL}/g' knowledge-base/integrations.md

# Update README.md endpoints section
sed -i '' 's/N8N: `http:\/\/167\.71\.180\.39:5678`/N8N: `${N8N_URL}`/g' README.md
sed -i '' 's/PostgreSQL: `165\.227\.116\.69:5432`/PostgreSQL: `${DB_HOST}:${DB_PORT}`/g' README.md
sed -i '' 's/Redis: `134\.209\.173\.59:6379`/Redis: `${REDIS_HOST}:${REDIS_PORT}`/g' README.md
sed -i '' 's/Weaviate: `https:\/\/blcrrxlmtoqofluebp5tlw\.c0\.us-west3\.gcp\.weaviate\.cloud`/Weaviate: `${WEAVIATE_URL}`/g' README.md

# Update test script
sed -i '' 's/165\.227\.116\.69/process.env.DB_HOST/g' scripts/test-connections.js
sed -i '' 's/134\.209\.173\.59/process.env.REDIS_HOST/g' scripts/test-connections.js

# Commit changes
git add .
git commit -m "Security update - remove sensitive data, use environment variables"
git push

echo "✅ Security updates complete!"