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
