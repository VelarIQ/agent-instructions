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
