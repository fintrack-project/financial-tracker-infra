# Financial Tracker Infrastructure

This repository contains the CI/CD pipelines and deployment configurations for the FinTrack project. It is designed to automate the build, test, and deployment processes and manage the infrastructure for the application.

## Directory Structure

- **ci-cd/**: Contains CI/CD pipeline configurations.
  - **Jenkinsfile**: Defines the Jenkins pipeline for automating testing, building, and deployment.
  - **README.md**: Documentation for setting up and using the CI/CD pipeline.
- **deployment/**: Contains deployment configurations for Kubernetes and AWS.
  - **k8s/**: Kubernetes manifests for deploying the backend, frontend, ETL pipeline, and PostgreSQL database.
  - **aws/**: AWS configurations for ECS, EKS, and S3/CloudFront.

## CI/CD Pipeline

The CI/CD pipeline is implemented using Jenkins. It automates the following tasks:
1. Build and test the application.
2. Build Docker images for the frontend, backend, and ETL pipeline.
3. Push Docker images to a container registry (e.g., AWS ECR).
4. Deploy the application to the Kubernetes cluster or AWS ECS.

### Setting Up Jenkins

1. Install Jenkins on your local machine or server.
2. Install the required plugins (e.g., Docker, Kubernetes, AWS CLI).
3. Add the `Jenkinsfile` to your Jenkins pipeline configuration.

## Deployment

### Kubernetes Deployment

The `k8s/` directory contains YAML manifests for deploying the application to a Kubernetes cluster. It includes:
- **backend-deployment.yaml**: Deployment and service for the backend API.
- **frontend-deployment.yaml**: Deployment and service for the frontend application.
- **etl-deployment.yaml**: Deployment for the ETL pipeline.
- **postgres-deployment.yaml**: Deployment and service for the PostgreSQL database.

To deploy to Kubernetes:
1. Ensure `kubectl` is configured to connect to your cluster.
2. Apply the manifests:
   ```bash
   kubectl apply -f deployment/k8s/
```

## Running Docker Images from Quay.io

### Option 1: Using Docker Compose (Recommended)

The easiest way to run all services is using Docker Compose. This ensures proper service orchestration and environment configuration.

1. Create a `.env.dev` file in the project root with your environment variables:
```bash
# Database
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin
POSTGRES_DB=financial_tracker

# Backend
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/financial_tracker
SPRING_DATASOURCE_USERNAME=admin
SPRING_DATASOURCE_PASSWORD=admin

# ETL
DB_HOST=db
DB_PORT=5432
DB_NAME=financial_tracker
DB_USER=admin
DB_PASSWORD=admin
```

2. Start all services:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml up --build
```

3. Stop and remove all containers:
```bash
docker compose --env-file .env.dev -f docker-compose.yml -f docker-compose.dev.yml down -v --remove-orphans
```

The services will be available at:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- Database: localhost:5433 (PostgreSQL)

### Option 2: Running Individual Containers

If you prefer to run containers individually, follow these steps:

### 1. Login to Quay.io
```bash
docker login quay.io
```
Enter your Quay.io username and password when prompted.

### 2. Pull the Images
Pull all required images from Quay.io:
```bash
docker pull quay.io/johnkim1/financial-tracker-backend:latest
docker pull quay.io/johnkim1/financial-tracker-frontend:latest
docker pull quay.io/johnkim1/financial-tracker-etl:latest
docker pull quay.io/johnkim1/financial-tracker-db:latest
```

### 3. Run the Containers
Run each container individually:

```bash
# Run database
docker run -d \
  --name financial-tracker-db \
  -p 5433:5432 \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin \
  -e POSTGRES_DB=financial_tracker \
  quay.io/johnkim1/financial-tracker-db:latest

# Run backend
docker run -d \
  --name financial-tracker-backend \
  -p 8080:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5433/financial_tracker \
  -e SPRING_DATASOURCE_USERNAME=admin \
  -e SPRING_DATASOURCE_PASSWORD=admin \
  quay.io/johnkim1/financial-tracker-backend:latest

# Run frontend
docker run -d \
  --name financial-tracker-frontend \
  -p 3000:80 \
  quay.io/johnkim1/financial-tracker-frontend:latest

# Run ETL
docker run -d \
  --name financial-tracker-etl \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=5433 \
  -e DB_NAME=financial_tracker \
  -e DB_USER=admin \
  -e DB_PASSWORD=admin \
  quay.io/johnkim1/financial-tracker-etl:latest
```

Note: The `host.docker.internal` hostname is used to allow containers to communicate with each other when running individually. This works on macOS and Windows. On Linux, you might need to use the host machine's IP address.

### 4. Verify the Services
Check if containers are running:
```bash
docker ps
```

View container logs:
```bash
docker logs <container-name>
```

The services will be available at:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- Database: localhost:5433 (PostgreSQL)

### 5. Stop and Remove Containers
When you're done, you can stop and remove the containers:
```bash
docker stop financial-tracker-db financial-tracker-backend financial-tracker-frontend financial-tracker-etl
docker rm financial-tracker-db financial-tracker-backend financial-tracker-frontend financial-tracker-etl
```