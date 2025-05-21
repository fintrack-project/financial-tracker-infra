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
if ! docker network ls | grep -q ${DATABASE_NETWORK_NAME}; then
    echo "Creating ${DATABASE_NETWORK_NAME}..."
    docker network create ${DATABASE_NETWORK_NAME}
else
    echo "${DATABASE_NETWORK_NAME} already exists"
fi

# Start the services
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up 