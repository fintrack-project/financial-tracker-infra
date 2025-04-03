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