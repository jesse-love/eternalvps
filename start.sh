#!/bin/bash
set -e

echo "🌌 Initializing Eternal Services..."

# Define paths
CORE_DIR="core"
COMPOSE_FILE="$CORE_DIR/docker-compose.yml"

# Check for critical configuration files
if [ ! -f "$CORE_DIR/config.yaml" ]; then
    echo "❌ Error: $CORE_DIR/config.yaml not found."
    echo "   Please create it with your Cloudflare Tunnel configuration."
    exit 1
fi

if [ ! -f "$CORE_DIR/credentials.json" ]; then
    echo "❌ Error: $CORE_DIR/credentials.json not found."
    echo "   Please place your Cloudflare Tunnel credentials here."
    exit 1
fi

# Check for .env file (optional but recommended)
if [ ! -f "$CORE_DIR/.env" ]; then
    echo "⚠️  Warning: $CORE_DIR/.env not found. Using default environment variables from compose file."
fi

# Pull latest images
echo "⬇️  Pulling Docker images..."
docker compose -f "$COMPOSE_FILE" pull

# Build custom images (e.g., Hub)
echo "🏗️  Building services..."
docker compose -f "$COMPOSE_FILE" build

# Start the stack
echo "🚀 Launching Eternal Services..."
docker compose -f "$COMPOSE_FILE" up -d

# Output status
echo ""
echo "✅ Stack is up and running!"
echo ""
echo "🌐 Service Endpoints:"
echo "   - Traefik Dashboard: https://traefik.eternalservices.ca/dashboard/"
echo "   - Portainer:         https://portainer.eternalservices.ca"
echo "   - Hub:               https://hub.eternalservices.ca"
echo "   - N8n:               https://n8n.eternalservices.ca"
echo "   - Mattermost:        https://chat.eternalservices.ca"
echo ""
echo "⚠️  Note: Ensure your DNS records in Cloudflare point to your Tunnel."
