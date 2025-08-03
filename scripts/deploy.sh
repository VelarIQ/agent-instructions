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
