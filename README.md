# FinTrack Infrastructure & DevOps 🚀

> **Complete infrastructure automation and deployment solutions for the FinTrack financial portfolio management platform.**

This repository contains **Infrastructure as Code (IaC)**, **CI/CD pipelines**, and **deployment configurations** that demonstrate enterprise-grade DevOps practices and containerized architecture design.

## 🎯 **What This Repository Showcases**

- **Container Orchestration**: Docker Compose configurations for local development and production
- **CI/CD Automation**: Jenkins pipelines with automated testing, building, and deployment
- **Docker Orchestration**: Multi-container orchestration with Docker Compose
- **Environment Management**: Multi-environment configurations (dev, staging, production)
- **Security Best Practices**: Secure Docker configurations and environment variable management

---

## 🏗️ **Architecture Overview**

```
┌─────────────────────────────────────────────────────────────────┐
│                    FinTrack Infrastructure                      │
├─────────────────────────────────────────────────────────────────┤
│  Local Development  │  CI/CD Pipeline  │  Container Deployment │
│  ┌─────────────┐   │  ┌─────────────┐  │  ┌─────────────┐    │
│  │   Docker    │   │  │   Jenkins   │  │  │   Docker    │    │
│  │  Compose    │   │  │   Pipeline  │  │  │  Compose    │    │
│  └─────────────┘   │  └─────────────┘  │  └─────────────┘    │
│  ┌─────────────┐   │  ┌─────────────┐  │  ┌─────────────┐    │
│  │ PostgreSQL  │   │  │   Quay.io   │  │  │   Kafka     │    │
│  │   Database  │   │  │  Registry   │  │  │   & Redis   │    │
│  └─────────────┘   │  └─────────────┘  │  └─────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 **Quick Start - Local Development**

### **Prerequisites**
- **Docker Desktop** (v20.10+) with Docker Compose
- **Git** for cloning the repository
- **Environment Variables** configured (see setup below)

### **One-Command Setup** ⚡

```bash
# Clone the project
git clone https://github.com/fintrack-project/fintrack-project.git
cd fintrack-project/financial-tracker-infra

# Start all services (development mode)
./start.sh

# Access your application:
# 🌐 Frontend: http://localhost:3000
# 🔌 Backend API: http://localhost:8080
# 🗄️ Database: localhost:5433
# 📊 Swagger API Docs: http://localhost:8080/swagger-ui.html
```

### **Stop All Services**
```bash
./stop.sh
```

---

## 🔧 **Environment Configuration**

### **1. Create Environment File**
Create a `.env.local` file in the `financial-tracker-infra` directory:

```bash
# Database Configuration
POSTGRES_USER=admin
POSTGRES_PASSWORD=secure_password_123
POSTGRES_DB=financial_tracker
DATABASE_HOST_PORT=5433
DATABASE_INTERNAL_PORT=5432
DATABASE_NETWORK_NAME=fintrack-network

# Backend Configuration
SPRING_PROFILES_ACTIVE=local
SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/financial_tracker
SPRING_DATASOURCE_USERNAME=admin
SPRING_DATASOURCE_PASSWORD=secure_password_123

# ETL Configuration
DB_HOST=db
DB_PORT=5432
DB_NAME=financial_tracker
DB_USER=admin
DB_PASSWORD=secure_password_123

# Frontend Configuration
REACT_APP_API_BASE_URL=http://localhost:8080
REACT_APP_ENVIRONMENT=local
```

### **2. Network Setup**
Create the required Docker network:
```bash
docker network create fintrack-network
```

---

## 🐳 **Docker Compose Configurations**

### **Available Configurations**

| Configuration | Purpose | Use Case |
|---------------|---------|----------|
| `docker-compose.yml` | Base configuration | Common services and networks |
| `docker-compose.local.yml` | Local development | Development environment with hot reload |
| `docker-compose.dev.yml` | Development testing | Staging-like environment |
| `docker-compose.prod.yml` | Production ready | Production deployment configuration |

### **Local Development Setup**
```bash
# Start with local development configuration
docker-compose -f docker-compose.yml -f docker-compose.local.yml up -d

# View logs
docker-compose -f docker-compose.yml -f docker-compose.local.yml logs -f

# Stop services
docker-compose -f docker-compose.yml -f docker-compose.local.yml down
```

### **Development Testing Setup**
```bash
# Start with development configuration
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

# Run tests
docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec backend ./mvnw test
docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec frontend npm test
docker-compose -f docker-compose.yml -f docker-compose.dev.yml exec etl python -m pytest
```

---

## 🔄 **CI/CD Pipeline Architecture**

### **Jenkins Pipeline Overview**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Git Push      │───►│   Jenkins       │───►│   Build & Test  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                        ┌─────────────────┐    ┌─────────────────┐
                        │   Docker Build  │───►│   Quay.io       │
                        └─────────────────┘    └─────────────────┘
                                │                       │
                        ┌─────────────────┐    ┌─────────────────┐
                        │   Deploy to     │───►│   Docker        │
                        │   Containers    │    │   Compose      │
                        └─────────────────┘    └─────────────────┘
```

### **Pipeline Stages**
1. **Code Quality Check**: Linting, security scanning, dependency analysis
2. **Build & Test**: Compile, unit tests, integration tests, coverage reports
3. **Docker Image Build**: Multi-stage builds, security scanning, optimization
4. **Registry Push**: Push to Quay.io container registry with versioning
5. **Deployment**: Automated deployment using Docker Compose
6. **Health Check**: Post-deployment verification and monitoring

---

## 🐳 **Container Deployment**

### **Docker Compose Production**
```bash
# Deploy to production environment
cd financial-tracker-infra

# Start production services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Check service status
docker-compose -f docker-compose.yml -f docker-compose.prod.yml ps

# View production logs
docker-compose -f docker-compose.yml -f docker-compose.prod.yml logs -f
```

### **Service Management**
```bash
# Scale services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --scale backend=3

# Update services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Rollback services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

## 🔐 **Security & Best Practices**

### **Docker Security**
- **Multi-stage builds** to minimize attack surface
- **Non-root user** execution in containers
- **Secrets management** via environment variables
- **Image scanning** for vulnerabilities
- **Resource limits** to prevent DoS attacks

### **Environment Security**
- **Environment-specific** configuration files
- **Secrets rotation** and management
- **Network isolation** with Docker networks
- **SSL/TLS** termination at load balancer
- **Access control** and least privilege access

### **CI/CD Security**
- **Signed commits** and branch protection
- **Automated security scanning** in pipeline
- **Dependency vulnerability** checking
- **Container image** security scanning
- **Secrets management** in CI/CD

---

## 📊 **Monitoring & Observability**

### **Health Checks**
```bash
# Backend health check
curl http://localhost:8080/actuator/health

# Frontend health check
curl http://localhost:3000/health

# Database connectivity
docker exec financial-tracker-db pg_isready -U admin
```

### **Logging & Debugging**
```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f etl
docker-compose logs -f db

# Access container shell
docker-compose exec backend /bin/bash
docker-compose exec frontend /bin/bash
docker-compose exec etl /bin/bash
```

---

## 🚨 **Troubleshooting Guide**

### **Common Issues & Solutions**

#### **1. Port Conflicts**
```bash
# Check what's using the ports
lsof -i :3000  # Frontend port
lsof -i :8080  # Backend port
lsof -i :5433  # Database port

# Kill conflicting processes
kill -9 <PID>
```

#### **2. Database Connection Issues**
```bash
# Check database status
docker-compose exec db pg_isready -U admin

# Reset database
docker-compose down -v
docker-compose up -d db
```

#### **3. Frontend Build Issues**
```bash
# Clear node modules and reinstall
cd financial-tracker-frontend
rm -rf node_modules package-lock.json
npm install
```

#### **4. Backend Build Issues**
```bash
# Clear Maven cache
cd financial-tracker-backend
./mvnw clean
./mvnw install
```

---

## 🛠️ **Development Workflow**

### **Daily Development Process**
```bash
# 1. Start services
./start.sh

# 2. Make code changes
# 3. Test changes
docker-compose exec backend ./mvnw test
docker-compose exec frontend npm test

# 4. Commit and push
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature

# 5. Stop services when done
./stop.sh
```

### **Adding New Services**
1. **Create Dockerfile** in service directory
2. **Add service** to docker-compose.yml
3. **Configure environment** variables
4. **Update start.sh/stop.sh** scripts
5. **Test integration** with existing services

---

## 📈 **Performance Optimization**

### **Docker Optimizations**
- **Multi-stage builds** for smaller images
- **Layer caching** for faster builds
- **Resource limits** for optimal performance
- **Health checks** for better orchestration

### **Database Optimizations**
- **Connection pooling** configuration
- **Query optimization** and indexing
- **Read replicas** for scaling
- **Backup and recovery** strategies

---

## 🔮 **Future Enhancements**

### **Planned Infrastructure Improvements**
- **Service Mesh** (Istio/Linkerd) for advanced networking
- **Observability Stack** (Prometheus, Grafana, Jaeger)
- **GitOps** workflow with ArgoCD or Flux
- **Multi-cloud** deployment support
- **Disaster Recovery** and backup automation

---

## 📚 **Additional Resources**

### **Documentation**
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [CI/CD Best Practices](https://www.jenkins.io/doc/book/pipeline/best-practices/)

### **Scripts & Tools**
- `start.sh` - Start all services
- `stop.sh` - Stop all services
- `setup-dev.sh` - Development environment setup
- `test-email-config.sh` - Email configuration testing

---

## 🤝 **Contributing to Infrastructure**

### **How to Contribute**
1. **Fork** the repository
2. **Create** a feature branch
3. **Make** your infrastructure changes
4. **Test** locally with Docker Compose
5. **Submit** a pull request
6. **Review** and iterate based on feedback

### **Infrastructure Standards**
- **Infrastructure as Code** principles
- **Security first** approach
- **Automation** over manual processes
- **Documentation** for all changes
- **Testing** infrastructure changes

---

## 📞 **Support & Community**

- **GitHub Issues**: Report bugs and request features
- **Discussions**: Community forum for questions
- **Documentation**: Comprehensive guides and examples
- **Contributing**: Guidelines for contributors

---

*This infrastructure demonstrates **enterprise-grade DevOps practices** with containerization, automation, and modern deployment strategies.*