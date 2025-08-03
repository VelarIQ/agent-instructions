// server.js - Enterprise Grade
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const { Pool } = require('pg');
const redis = require('redis');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const winston = require('winston');
const { v4: uuidv4 } = require('uuid');
const sgMail = require('@sendgrid/mail');
const cron = require('node-cron');

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

// Logger
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    new winston.transports.Console({ format: winston.format.simple() })
  ]
});

// Database
const db = new Pool({
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl: { rejectUnauthorized: false }
});

// Redis
const redisClient = redis.createClient({
  url: `redis://:${process.env.REDIS_PASSWORD}@${process.env.REDIS_HOST}:6379`
});

redisClient.on('error', err => logger.error('Redis error:', err));
redisClient.connect();

const app = express();

// Security middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'", "https://js.stripe.com"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "https://api.stripe.com"]
    }
  }
}));

// CORS
app.use(cors({
  origin: ['https://velariq.github.io', 'https://velariq.ai', 'http://localhost:3000'],
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    logger.warn(`Rate limit exceeded for IP: ${req.ip}`);
    res.status(429).json({ error: 'Too many requests' });
  }
});

const strictLimiter = rateLimit({
  windowMs: 60 * 1000,
  max: 10,
  skipSuccessfulRequests: true
});

app.use('/api/', limiter);
app.use('/create-checkout-session', strictLimiter);

// Parsing
app.use(express.json({ 
  limit: '10kb',
  verify: (req, res, buf) => {
    req.rawBody = buf.toString('utf8');
  }
}));

// Kill switch check
app.use(async (req, res, next) => {
  const killSwitch = await redisClient.get('global:killswitch');
  if (killSwitch === 'active') {
    logger.warn('Kill switch activated');
    return res.status(503).json({ error: 'Service temporarily disabled' });
  }
  next();
});

// Request logging
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    logger.info({
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration: Date.now() - start,
      ip: req.ip
    });
  });
  next();
});

// Webhook signature verification
const verifyWebhookSignature = (req, res, next) => {
  const sig = req.headers['stripe-signature'];
  try {
    const event = stripe.webhooks.constructEvent(
      req.rawBody,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
    req.stripeEvent = event;
    next();
  } catch (err) {
    logger.error('Webhook signature verification failed:', err);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }
};

// API Key validation middleware
const validateApiKey = async (req, res, next) => {
  const apiKey = req.headers['x-api-key'] || req.headers.authorization?.replace('Bearer ', '');
  
  if (!apiKey) {
    return res.status(401).json({ error: 'API key required' });
  }

  try {
    // Check Redis cache first
    const cached = await redisClient.get(`apikey:${apiKey}`);
    if (cached) {
      req.user = JSON.parse(cached);
      return next();
    }

    // Check database
    const result = await db.query(`
      SELECT u.*, s.plan_id, s.status, s.current_period_end, s.stripe_customer_id 
      FROM users u
      LEFT JOIN subscriptions s ON u.id = s.user_id
      WHERE u.api_key = $1 AND s.status = 'active'
    `, [apiKey]);

    if (result.rows.length === 0) {
      return res.status(403).json({ 
        error: 'Invalid API key or no active subscription',
        upgrade: 'https://velariq.github.io/agent-instructions/'
      });
    }

    const user = result.rows[0];
    
    // Check token limits
    if (user.tokens_used >= user.tokens_allocated) {
      return res.status(429).json({ 
        error: 'Token limit exceeded',
        used: user.tokens_used,
        limit: user.tokens_allocated,
        resets: user.current_period_end
      });
    }

    // Cache for 5 minutes
    await redisClient.setEx(`apikey:${apiKey}`, 300, JSON.stringify(user));
    
    req.user = user;
    next();
  } catch (error) {
    logger.error('API key validation error:', error);
    res.status(500).json({ error: 'Authentication failed' });
  }
};

// Token tracking
const trackTokenUsage = async (userId, tokens) => {
  try {
    await db.query(
      'UPDATE users SET tokens_used = tokens_used + $1 WHERE id = $2',
      [tokens, userId]
    );
    
    // Update cache
    await redisClient.del(`apikey:*`);
    
    // Log usage
    await db.query(
      'INSERT INTO token_usage_logs (user_id, tokens, timestamp) VALUES ($1, $2, NOW())',
      [userId, tokens]
    );
  } catch (error) {
    logger.error('Token tracking error:', error);
  }
};

// Abuse detection
const detectAbuse = async (req, res, next) => {
  const ip = req.ip;
  const key = `abuse:${ip}`;
  
  const attempts = await redisClient.incr(key);
  await redisClient.expire(key, 3600); // 1 hour
  
  if (attempts > 1000) {
    logger.warn(`Abuse detected from IP: ${ip}`);
    return res.status(403).json({ error: 'Access denied' });
  }
  
  next();
};

// Send welcome email with 100-day journey
async function sendWelcomeEmail(email, apiKey) {
  try {
    await sgMail.send({
      to: email,
      from: 'noreply@velariq.ai',
      subject: 'Welcome to VelarIQ - Your 100 Day Journey Begins',
      html: `
        <h2>Welcome to VelarIQ!</h2>
        <p>Your enterprise workflow automation journey starts now.</p>
        <h3>Your API Key:</h3>
        <code style="background: #f0f0f0; padding: 10px; display: block;">${apiKey}</code>
        <h3>Quick Start:</h3>
        <p>Access N8N: http://167.71.180.39:5678</p>
        <p>Documentation: https://github.com/VelarIQ/agent-instructions</p>
        <p>Day 1 Tip: Create your first webhook workflow today!</p>
      `
    });
    
    await db.query(
      'INSERT INTO email_journey (user_email, current_day) VALUES ($1, 1)',
      [email]
    );
  } catch (error) {
    logger.error('Email error:', error);
  }
}

// Routes

// Health check
app.get('/health', async (req, res) => {
  try {
    await db.query('SELECT 1');
    await redisClient.ping();
    res.json({ status: 'healthy', timestamp: new Date() });
  } catch (error) {
    res.status(503).json({ status: 'unhealthy', error: error.message });
  }
});

// Create checkout session
app.post('/create-checkout-session', detectAbuse, async (req, res) => {
  try {
    const { priceId, successUrl, cancelUrl } = req.body;
    
    if (!priceId || !successUrl || !cancelUrl) {
      return res.status(400).json({ error: 'Missing required parameters' });
    }

    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card', 'link'],
      allow_promotion_codes: true,
      customer_creation: 'always',
      payment_method_collection: 'if_required',
      line_items: [{
        price: priceId,
        quantity: 1,
      }],
      mode: 'subscription',
      success_url: successUrl + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: cancelUrl,
      metadata: {
        priceId: priceId
      }
    });

    res.json({ id: session.id });
  } catch (error) {
    logger.error('Checkout session error:', error);
    res.status(500).json({ error: 'Failed to create checkout session' });
  }
});

// Stripe webhook
app.post('/webhook', express.raw({ type: 'application/json' }), verifyWebhookSignature, async (req, res) => {
  const event = req.stripeEvent;

  try {
    switch (event.type) {
      case 'checkout.session.completed':
        const session = event.data.object;
        
        // Create user
        const email = session.customer_details.email;
        const apiKey = 'viq_' + uuidv4().replace(/-/g, '');
        
        const userResult = await db.query(`
          INSERT INTO users (email, api_key, tokens_allocated, tokens_used)
          VALUES ($1, $2, $3, 0)
          ON CONFLICT (email) DO UPDATE
          SET api_key = $2
          RETURNING id
        `, [email, apiKey, getTokenAllocation(session.metadata.priceId)]);
        
        const userId = userResult.rows[0].id;
        
        // Create subscription
        await db.query(`
          INSERT INTO subscriptions (user_id, stripe_subscription_id, stripe_customer_id, plan_id, status, current_period_end)
          VALUES ($1, $2, $3, $4, 'active', to_timestamp($5))
          ON CONFLICT (stripe_subscription_id) DO UPDATE
          SET status = 'active', plan_id = $4
        `, [userId, session.subscription, session.customer, session.metadata.priceId, session.current_period_end]);
        
        // Send welcome email
        await sendWelcomeEmail(email, apiKey);
        
        // Clear cache
        await redisClient.del(`apikey:*`);
        
        logger.info(`New subscription created for ${email}`);
        break;

      case 'customer.subscription.deleted':
      case 'customer.subscription.updated':
        const subscription = event.data.object;
        await db.query(
          'UPDATE subscriptions SET status = $1 WHERE stripe_subscription_id = $2',
          [subscription.status, subscription.id]
        );
        await redisClient.del(`apikey:*`);
        break;
    }

    res.json({ received: true });
  } catch (error) {
    logger.error('Webhook processing error:', error);
    res.status(500).json({ error: 'Webhook processing failed' });
  }
});

// Dashboard
app.get('/dashboard', validateApiKey, async (req, res) => {
  const user = req.user;
  const planName = getPlanName(user.plan_id);
  
  res.json({
    email: user.email,
    apiKey: user.api_key,
    plan: planName,
    price: getPlanPrice(user.plan_id),
    tokenBalance: user.tokens_allocated - user.tokens_used,
    maxTokens: user.tokens_allocated,
    tokenPercentage: Math.round(((user.tokens_allocated - user.tokens_used) / user.tokens_allocated) * 100),
    currentPeriodEnd: user.current_period_end,
    activeWorkflows: 0, // Implement workflow counting
    workflowLimit: getWorkflowLimit(user.plan_id)
  });
});

// Customer portal
app.post('/api/create-portal-session', validateApiKey, async (req, res) => {
  try {
    const session = await stripe.billingPortal.sessions.create({
      customer: req.user.stripe_customer_id,
      return_url: 'https://velariq.github.io/agent-instructions/dashboard.html',
    });
    
    res.json({ url: session.url });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create portal session' });
  }
});

// GDPR endpoints
app.get('/api/gdpr/export', validateApiKey, async (req, res) => {
  const userData = await db.query('SELECT * FROM users WHERE id = $1', [req.user.id]);
  const workflows = await db.query('SELECT * FROM workflows WHERE user_id = $1', [req.user.id]);
  res.json({
    user: userData.rows[0],
    workflows: workflows.rows,
    exported_at: new Date()
  });
});

app.delete('/api/gdpr/delete', validateApiKey, async (req, res) => {
  if (req.body.confirm !== 'DELETE_MY_ACCOUNT') {
    return res.status(400).json({ error: 'Confirmation required' });
  }
  
  if (req.user.stripe_subscription_id) {
    await stripe.subscriptions.cancel(req.user.stripe_subscription_id);
  }
  
  await db.query('DELETE FROM users WHERE id = $1', [req.user.id]);
  res.json({ message: 'Account deleted' });
});

// Protected workflow endpoints
app.post('/api/workflow/create', validateApiKey, async (req, res) => {
  const tokenCost = 100;
  await trackTokenUsage(req.user.id, tokenCost);
  
  const workflowId = uuidv4();
  await db.query(
    'INSERT INTO workflows (id, user_id, name, config) VALUES ($1, $2, $3, $4)',
    [workflowId, req.user.id, req.body.name, JSON.stringify(req.body.config)]
  );
  
  res.json({ 
    success: true, 
    workflowId,
    tokensConsumed: tokenCost,
    remainingTokens: req.user.tokens_allocated - req.user.tokens_used - tokenCost
  });
});

app.post('/api/workflow/execute', validateApiKey, async (req, res) => {
  const tokenCost = calculateTokenCost(req.body);
  
  if (req.user.tokens_used + tokenCost > req.user.tokens_allocated) {
    return res.status(429).json({ error: 'Insufficient tokens' });
  }
  
  await trackTokenUsage(req.user.id, tokenCost);
  
  // Forward to N8N
  try {
    const n8nResponse = await fetch(`http://167.71.180.39:5678/webhook/${req.body.workflowId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${Buffer.from(`${process.env.N8N_USER}:${process.env.N8N_PASSWORD}`).toString('base64')}`
      },
      body: JSON.stringify(req.body.data)
    });
    
    const result = await n8nResponse.json();
    
    res.json({
      success: true,
      result,
      tokensConsumed: tokenCost,
      remainingTokens: req.user.tokens_allocated - req.user.tokens_used - tokenCost
    });
  } catch (error) {
    logger.error('Workflow execution error:', error);
    res.status(500).json({ error: 'Workflow execution failed' });
  }
});

// Cron jobs
cron.schedule('0 0 1 * *', async () => {
  logger.info('Monthly token reset');
  await db.query('UPDATE users SET tokens_used = 0 WHERE id IN (SELECT user_id FROM subscriptions WHERE status = $1)', ['active']);
  await redisClient.flushDb();
});

// Daily backups
cron.schedule('0 3 * * *', () => {
  const { exec } = require('child_process');
  const date = new Date().toISOString().split('T')[0];
  exec(`PGPASSWORD=${process.env.DB_PASSWORD} pg_dump -h ${process.env.DB_HOST} -U ${process.env.DB_USER} ${process.env.DB_NAME} > /tmp/backup-${date}.sql`);
  logger.info('Backup completed');
});

// Utility functions
function getTokenAllocation(priceId) {
  const allocations = {
    [process.env.PRICE_STARTER]: 100000,
    [process.env.PRICE_PROFESSIONAL]: 500000,
    [process.env.PRICE_ENTERPRISE]: 2000000
  };
  return allocations[priceId] || 100000;
}

function getPlanName(priceId) {
  const plans = {
    [process.env.PRICE_STARTER]: 'Starter',
    [process.env.PRICE_PROFESSIONAL]: 'Professional',
    [process.env.PRICE_ENTERPRISE]: 'Enterprise'
  };
  return plans[priceId] || 'Unknown';
}

function getPlanPrice(priceId) {
  const prices = {
    [process.env.PRICE_STARTER]: 149,
    [process.env.PRICE_PROFESSIONAL]: 399,
    [process.env.PRICE_ENTERPRISE]: 999
  };
  return prices[priceId] || 0;
}

function getWorkflowLimit(priceId) {
  const limits = {
    [process.env.PRICE_STARTER]: '5 workflows',
    [process.env.PRICE_PROFESSIONAL]: 'Unlimited workflows',
    [process.env.PRICE_ENTERPRISE]: 'Unlimited workflows'
  };
  return limits[priceId] || '5 workflows';
}

function calculateTokenCost(workflow) {
  let cost = 50; // Base cost
  
  if (workflow.aiNodes) cost += workflow.aiNodes * 100;
  if (workflow.integrations) cost += workflow.integrations * 50;
  if (workflow.complexity === 'high') cost *= 2;
  
  return cost;
}

// Error handling
app.use((err, req, res, next) => {
  logger.error('Unhandled error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`Server running on port ${PORT}`);
});