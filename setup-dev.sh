#!/bin/bash

# Load environment variables from .env.dev
if [ -f .env.dev ]; then
    echo "Loading environment variables from .env.dev..."
    export $(cat .env.dev | grep -v '^#' | xargs)
else
    echo "Error: .env.dev file not found"
    exit 1
fi

# Create network if it doesn't exist
echo "Checking for network fintrack-network..."
if ! docker network ls | grep -q fintrack-network; then
    echo "Creating network fintrack-network..."
    docker network create fintrack-network
    echo "Network created successfully"
else
    echo "Network fintrack-network already exists"
fi

# Verify network exists
echo "Verifying network exists..."
docker network ls | grep fintrack-network

# Start services
echo "Starting services..."
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml up --build 