#!/bin/bash

# Function to display usage
usage() {
    echo "Usage:"
    echo "  ./start.sh [dev|prod]                    # Start all services in specified environment"
    echo "  ./start.sh [dev|prod] [service1 service2] # Start specific services in specified environment"
    echo ""
    echo "Examples:"
    echo "  ./start.sh dev                           # Start all services in development"
    echo "  ./start.sh prod                          # Start all services in production"
    echo "  ./start.sh dev frontend backend          # Start only frontend and backend in development"
    echo "  ./start.sh prod db mailhog              # Start only db and mailhog in production"
}

# Check if environment is specified
if [ $# -lt 1 ]; then
    echo "Error: Environment not specified"
    usage
    exit 1
fi

# Default to dev if no environment is specified
ENV=$1
shift

# Check if the environment file exists
if [ ! -f ".env.$ENV" ]; then
    echo "Error: .env.$ENV file not found"
    exit 1
fi

# Check if environment is valid
if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ]; then
    echo "Error: Invalid environment. Use 'dev' or 'prod'"
    usage
    exit 1
fi

# Create network if it doesn't exist
if ! docker network ls | grep -q fintrack-network; then
    echo "Creating fintrack-network..."
    docker network create fintrack-network
fi

# Build the docker-compose command
COMPOSE_CMD="docker compose --env-file .env.$ENV -f docker-compose.yml"

if [ "$ENV" = "dev" ]; then
    COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.dev.yml"
elif [ "$ENV" = "prod" ]; then
    COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.prod.yml"
fi

# Add services if specified
if [ $# -gt 0 ]; then
    echo "Starting services in $ENV environment: $@"
    COMPOSE_CMD="$COMPOSE_CMD up --build $@"
else
    echo "Starting all services in $ENV environment"
    COMPOSE_CMD="$COMPOSE_CMD up --build"
fi

# Execute the command
echo "Running: $COMPOSE_CMD"
eval $COMPOSE_CMD 