#!/bin/bash

# Function to display usage
usage() {
    echo "Usage:"
    echo "  ./start.sh [dev|prod|local]                    # Start all services in specified environment"
    echo "  ./start.sh [dev|prod|local] [service1 service2] # Start specific services in specified environment"
    echo "  ./start.sh [dev|prod|local] infrastructure      # Start only infrastructure services (DB, Kafka, Zookeeper, MailHog, ETL)"
    echo ""
    echo "Examples:"
    echo "  ./start.sh dev                           # Start all services in development"
    echo "  ./start.sh prod                          # Start all services in production"
    echo "  ./start.sh local                         # Start infrastructure + frontend, backend runs locally"
    echo "  ./start.sh dev frontend backend          # Start only frontend and backend in development"
    echo "  ./start.sh prod db mailhog              # Start only db and mailhog in production"
    echo "  ./start.sh dev infrastructure            # Start infrastructure services for local development"
    echo "  ./start.sh local infrastructure          # Start infrastructure services for local backend development"
    echo ""
    echo "Local Development Setup:"
    echo "  1. ./start.sh local infrastructure       # Start infrastructure services"
    echo "  2. cd ../financial-tracker-backend && ./mvnw spring-boot:run  # Run backend locally"
    echo "  3. ./start.sh local frontend             # Start frontend (optional)"
}

# Function to start infrastructure services only
start_infrastructure() {
    local ENV=$1
    
    echo "=== Starting Infrastructure Services Only ==="
    echo "Environment: $ENV"
    
    # Check if the environment file exists
    if [ ! -f ".env.$ENV" ]; then
        echo "Error: .env.$ENV file not found"
        exit 1
    fi
    
    # Create network if it doesn't exist
    echo "Creating Docker network..."
    docker network create fintrack-network 2>/dev/null || echo "Network already exists"
    
    # Build the docker-compose command
    COMPOSE_CMD="docker compose --env-file .env.$ENV -f docker-compose.yml"
    
    if [ "$ENV" = "dev" ]; then
        COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.dev.yml"
    elif [ "$ENV" = "prod" ]; then
        COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.prod.yml"
    elif [ "$ENV" = "local" ]; then
        COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.local.yml"
    fi
    
    # Start infrastructure services
    echo "Starting infrastructure services..."
    $COMPOSE_CMD up -d db kafka zookeeper mailhog etl
    
    echo ""
    echo "=== Infrastructure Services Started ==="
    echo "Database: localhost:5432"
    echo "Kafka: localhost:9092"
    echo "Zookeeper: localhost:2181"
    echo "MailHog SMTP: localhost:1025"
    echo "MailHog Web UI: http://localhost:8025"
    echo ""
    echo "You can now run:"
    echo "- Frontend: cd ../financial-tracker-frontend && npm start"
    echo "- Backend: cd ../financial-tracker-backend && ./mvnw spring-boot:run"
    echo ""
    echo "To stop infrastructure services:"
    echo "$COMPOSE_CMD down db kafka zookeeper mailhog etl"
}

# Check if infrastructure mode is requested
if [ "$2" = "infrastructure" ]; then
    if [ $# -lt 2 ]; then
        echo "Error: Environment not specified for infrastructure mode"
        echo "Usage: ./start.sh [dev|prod|local] infrastructure"
        exit 1
    fi
    
    ENV=$1
    
    # Check if environment is valid
    if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ] && [ "$ENV" != "local" ]; then
        echo "Error: Invalid environment. Use 'dev', 'prod', or 'local'"
        echo "Usage: ./start.sh [dev|prod|local] infrastructure"
        exit 1
    fi
    
    start_infrastructure $ENV
    exit 0
fi

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
if [ "$ENV" != "dev" ] && [ "$ENV" != "prod" ] && [ "$ENV" != "local" ]; then
    echo "Error: Invalid environment. Use 'dev', 'prod', or 'local'"
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
elif [ "$ENV" = "local" ]; then
    COMPOSE_CMD="$COMPOSE_CMD -f docker-compose.local.yml"
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