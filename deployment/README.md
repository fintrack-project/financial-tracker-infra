# FinTrack Deployment Documentation

This document provides an overview of the deployment setup for the FinTrack application, including instructions for deploying the backend, frontend, and ETL pipeline using Kubernetes and AWS services.

## Deployment Overview

FinTrack is designed to be deployed in a cloud environment using Kubernetes for orchestration and AWS for hosting. The deployment consists of the following components:

1. **Backend**: A Spring Boot application that provides RESTful APIs for asset management.
2. **Frontend**: A React application that serves as the user interface for interacting with the backend.
3. **ETL Pipeline**: A set of Python scripts that fetch, process, and store financial data.
4. **PostgreSQL Database**: A relational database for storing user and asset data.

## Kubernetes Deployment

The deployment configurations for Kubernetes are located in the `k8s` directory. Each component has its own deployment YAML file:

- **Backend**: `backend-deployment.yaml`
- **Frontend**: `frontend-deployment.yaml`
- **ETL**: `etl-deployment.yaml`
- **PostgreSQL**: `postgres-deployment.yaml`

To deploy the application on a Kubernetes cluster, follow these steps:

1. Ensure you have access to a Kubernetes cluster.
2. Apply the deployment configurations using the following command:

   ```
   kubectl apply -f k8s/
   ```

3. Monitor the deployment status:

   ```
   kubectl get pods
   ```

## AWS Deployment

The AWS deployment configurations are located in the `aws` directory. The following configurations are available:

- **ECS Configuration**: `ecs-config.json` for deploying the backend on AWS ECS.
- **EKS Configuration**: `eks-config.json` for deploying the backend on AWS EKS.
- **S3 and CloudFront Configuration**: `s3-cloudfront-config.json` for serving the frontend application.

### Deploying on AWS ECS

1. Configure your AWS CLI with the necessary credentials.
2. Use the `ecs-config.json` to set up your ECS cluster and services.
3. Deploy the backend service using the AWS Management Console or CLI.

### Deploying on AWS EKS

1. Ensure your EKS cluster is set up and configured.
2. Use the `eks-config.json` to deploy the backend service on EKS.

### Serving Frontend with S3 and CloudFront

1. Upload the built frontend application to an S3 bucket.
2. Configure CloudFront to serve the content from the S3 bucket using the `s3-cloudfront-config.json`.

## Conclusion

This document serves as a guide for deploying the FinTrack application. Ensure that all configurations are properly set before proceeding with the deployment. For further assistance, refer to the individual component documentation or seek help from the development team.