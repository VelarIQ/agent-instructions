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
