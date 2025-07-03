#!/bin/bash

# Function to display usage
usage() {
    echo "Usage:"
    echo "  ./stop.sh [dev|prod|local]                    # Stop all services in specified environment"
    echo "  ./stop.sh [dev|prod|local] [service1 service2] # Stop specific services in specified environment"
    echo "  ./stop.sh [dev|prod|local] infrastructure      # Stop only infrastructure services (DB, Kafka, Zookeeper, MailHog, Valkey, ETL)"
    echo ""
    echo "Examples:"
    echo "  ./stop.sh dev                           # Stop all services in development"
    echo "  ./stop.sh prod                          # Stop all services in production"
    echo "  ./stop.sh local                         # Stop all services in local environment"
    echo "  ./stop.sh dev frontend backend          # Stop only frontend and backend in development"
    echo "  ./stop.sh prod db mailhog              # Stop only db and mailhog in production"
    echo "  ./stop.sh local infrastructure          # Stop only infrastructure services in local environment"
}

# Function to stop infrastructure services only
stop_infrastructure() {
    local ENV=$1
    
    echo "=== Stopping Infrastructure Services Only ==="
    echo "Environment: $ENV"
    
    # Check if the environment file exists
    if [ ! -f ".env.$ENV" ]; then
        echo "Error: .env.$ENV file not found"
        exit 1
    fi
    
    # Build the docker-compose command
    COMPOSE_CMD="docker compose --env-file .env.$ENV -f docker-compose.yml"
    
    if [ "$ENV" = "dev" ]; then
        COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.dev.yml"
    elif [ "$ENV" = "prod" ]; then
        COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.prod.yml"
    elif [ "$ENV" = "local" ]; then
        COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.local.yml"
    fi
    
    # Stop infrastructure services
    echo "Stopping infrastructure services..."
    $COMPOSE_CMD stop db kafka zookeeper mailhog valkey etl
    
    echo ""
    echo "=== Infrastructure Services Stopped ==="
}

# Check if infrastructure mode is requested
if [ "$2" = "infrastructure" ]; then
    if [ $# -lt 2 ]; then
        echo "Error: Environment not specified for infrastructure mode"
        echo "Usage: ./stop.sh [dev|prod|local] infrastructure"
        exit 1
    fi
    
    ENV=$1
    
    # Check if environment is valid
    if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ] && [ "$ENV" != "local" ]; then
        echo "Error: Invalid environment. Use 'dev', 'prod', or 'local'"
        echo "Usage: ./stop.sh [dev|prod|local] infrastructure"
        exit 1
    fi
    
    stop_infrastructure $ENV
    exit 0
fi

# Check if environment is specified
if [ $# -lt 1 ]; then
    echo "Error: Environment not specified"
    usage
    exit 1
fi

# Get environment
ENV=$1
shift

# Check if the environment file exists
if [ ! -f ".env.$ENV" ]; then
    echo "Error: .env.$ENV file not found"
    exit 1
fi

# Check if environment is valid
if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ] && [ "$ENV" != "local" ]; then
    echo "Error: Invalid environment. Use 'dev', 'prod', or 'local'"
    usage
    exit 1
fi

# Build the docker-compose command
COMPOSE_CMD="docker compose --env-file .env.$ENV -f docker-compose.yml"

if [ "$ENV" = "dev" ]; then
    COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.dev.yml"
elif [ "$ENV" = "prod" ]; then
    COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.prod.yml"
elif [ "$ENV" = "local" ]; then
    COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.local.yml"
fi

# Add services if specified
if [ $# -gt 0 ]; then
    echo "Stopping services in $ENV environment: $@"
    COMPOSE_CMD="$COMPOSE_CMD stop $@"
else
    echo "Stopping all services in $ENV environment"
    COMPOSE_CMD="$COMPOSE_CMD down -v --remove-orphans"
fi

# Execute the command
echo "Running: $COMPOSE_CMD"
eval $COMPOSE_CMD 