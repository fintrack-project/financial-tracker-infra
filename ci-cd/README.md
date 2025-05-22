# FinTrack CI/CD Documentation

This document provides an overview of the Continuous Integration and Continuous Deployment (CI/CD) setup for the FinTrack project.

## Overview

The CI/CD pipeline is designed to automate the process of building, testing, and deploying the FinTrack application. It ensures that code changes are integrated smoothly and deployed to production with minimal manual intervention.

## Configuration Files

### Local Development (application.properties)
For local development setup:
1. Copy `application.properties.template` to `application.properties`
2. Update the following values:
   - Database credentials
   - AWS credentials
   - Quay.io credentials
   - Kafka configuration (if running locally)

### CI/CD Environment (application-ci.properties)
For CI/CD environment setup:
1. Copy `application-ci.properties.template` to `application-ci.properties`
2. Configure the following environment variables in Jenkins:
   - Database:
     - `DATABASE_HOST`
     - `DATABASE_PORT`
     - `DATABASE_NAME`
     - `POSTGRES_USER`
     - `POSTGRES_PASSWORD`
   - AWS:
     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - `AWS_REGION`
   - Quay.io:
     - `QUAY_USERNAME`
     - `QUAY_PASSWORD`

## CI/CD Tools

- **Jenkins**: The primary tool used for automating the CI/CD pipeline. Jenkins is configured to monitor the repository for changes and trigger builds accordingly.

## Pipeline Stages

1. **Build**: 
   - The application is built using Maven for the backend and npm for the frontend.
   - Docker images are created for the backend, frontend, and ETL pipeline.

2. **Test**: 
   - Unit tests and integration tests are executed to ensure code quality and functionality.
   - Test reports are generated for review.

3. **Deploy**: 
   - The application is deployed to AWS using ECS for the backend and S3 for the frontend.
   - Kubernetes is used for orchestrating the deployment of the backend, frontend, and ETL services.

## Jenkins Setup

1. Install required plugins:
   - Pipeline
   - Git
   - Docker
   - Credentials

2. Configure credentials:
   - Database credentials
   - AWS credentials
   - Quay.io credentials

3. Configure tools:
   - JDK 18
   - Maven 3.9.9
   - NodeJS 18.16.0

## Running the Pipeline

1. Start the CI environment:
```bash
docker-compose -f docker-compose.ci.yml up -d
```

2. Access Jenkins:
   - URL: http://localhost:8080
   - Get initial admin password:
     ```bash
     docker exec jenkins cat /run/secrets/additional_jenkins_admin_password
     ```

3. Create a new pipeline job:
   - Name: financial-tracker-pipeline
   - Type: Pipeline
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: Your repository URL
   - Script Path: ci-cd/Jenkinsfile

## Best Practices

- Never commit `application.properties` or `application-ci.properties` to git
- Use templates as a guide for setting up configurations
- Keep sensitive information in environment variables or secure credential storage
- Regularly update dependencies to avoid security vulnerabilities
- Monitor the CI/CD pipeline for failures and address issues promptly

## Conclusion

The CI/CD setup for FinTrack aims to streamline the development process, enhance code quality, and facilitate rapid deployment of new features and fixes.