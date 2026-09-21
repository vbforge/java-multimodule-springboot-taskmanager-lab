# Version 3: MySQL Database with Docker Support

A Spring Boot Task Manager API supporting three different deployment scenarios - from fully local to completely containerized.

## 📋 Table of Contents

  * [🏗 Architecture Overview](#-architecture-overview)
  * [📦 Prerequisites](#-prerequisites)
  * [🚀 Quick Start](#-quick-start)
  * [📖 Deployment Scenarios](#-deployment-scenarios)
    * [Scenario 1: Local Everything (No Docker)](#scenario-1-local-everything-no-docker)
    * [Scenario 2: Local App + MySQL in Docker](#scenario-2-local-app--mysql-in-docker)
    * [Scenario 3: Everything in Docker](#scenario-3-everything-in-docker)
  * [📁 Project Structure](#-project-structure)
  * [⚙️ Configuration Files](#-configuration-files)
  * [🧪 Testing the API](#-testing-the-api)
  * [🔧 Troubleshooting](#-troubleshooting)
  * [🧹 Cleanup](#-cleanup)
  * [📊 Quick Reference](#-quick-reference)
  * [🎯 Success Indicators](#-success-indicators)


## 🏗 Architecture Overview

This module provides a flexible Task Manager API that can run in three different configurations:

| Scenario | App Location | Database Location | Ports | Best For |
|----------|-------------|-------------------|-------|----------|
| **Local** | Your machine | Your machine (MySQL) | App:8082, MySQL:3306 | Fast development without Docker |
| **Docker MySQL** | Your machine | Docker container | App:8082, MySQL:3307, phpMyAdmin:8083 | Development with isolated database |
| **Full Docker** | Docker container | Docker container | App:8082, MySQL:3307, phpMyAdmin:8083 | Production-like environment |

## 📦 Prerequisites

### For All Scenarios:
- **Java 17+** - [Download](https://adoptium.net/)
- **Maven** - Included via mvnw wrapper

### For Docker Scenarios (2 & 3):
- **Docker Desktop** - [Download](https://www.docker.com/products/docker-desktop/)
- Docker must be running before executing scripts

### For Local MySQL (Scenario 1):
- **MySQL Server 8.0+** installed locally
- MySQL service running

## 🚀 Quick Start

Choose your scenario and run the corresponding script:

```powershell
# Windows PowerShell (run from scripts folder)
cd scripts

# Scenario 1: Everything local
.\run-local.ps1

# Scenario 2: Local app with Docker MySQL
.\run-docker-mysql.ps1

# Scenario 3: Everything in Docker
.\run-docker-both.ps1

# Stop all running services
.\stop-all.ps1
```

## 📖 Deployment Scenarios

### Scenario 1: Local Everything (No Docker)

**When to use:** Fastest development, no Docker overhead, full debugging capabilities.

**Architecture:**
- Spring Boot runs directly on your machine via Maven
- MySQL runs as Windows/Linux service
- Direct database connection on port 3306

**Setup Requirements:**
```sql
-- MySQL must be installed locally with these credentials:
CREATE DATABASE IF NOT EXISTS taskdb;
CREATE USER IF NOT EXISTS 'taskuser'@'localhost' IDENTIFIED BY 'taskpass';
GRANT ALL PRIVILEGES ON taskdb.* TO 'taskuser'@'localhost';
FLUSH PRIVILEGES;
```

**Start:**
```powershell
cd scripts
.\run-local.ps1
```

**Configuration used:** `application-local.yml`

### Scenario 2: Local App + MySQL in Docker

**When to use:** Development with isolated database, testing Docker integration, no local MySQL installation needed.

**Architecture:**
- Spring Boot runs on your machine via Maven
- MySQL runs in Docker container (port 3307)
- phpMyAdmin for database management (port 8083)

**Start:**
```powershell
cd scripts
.\run-docker-mysql.ps1
```

**What happens:**
1. Starts MySQL container with phpMyAdmin
2. Waits for MySQL to be healthy
3. Launches Spring Boot with `docker-mysql` profile
4. App connects to MySQL at `localhost:3307`

**Configuration used:** `application-docker-mysql.yml`

### Scenario 3: Everything in Docker

**When to use:** Production-like environment, complete isolation, easy distribution.

**Architecture:**
- Both Spring Boot and MySQL run in Docker containers
- Internal Docker network communication
- Complete container orchestration

**Start:**
```powershell
cd scripts
.\run-docker-both.ps1
```

**What happens:**
1. Builds JAR file with Maven
2. Builds Docker image from Dockerfile
3. Starts MySQL, phpMyAdmin, and App containers
4. App connects to MySQL using service name `mysql`

**Configuration used:** `application-docker-both.yml`

## 📁 Project Structure

```
version3-mysql-docker/
│
├── 📄 Dockerfile                    # Docker image definition
├── 📄 pom.xml                       # Maven dependencies
├── 📄 mvnw, mvnw.cmd               # Maven wrapper scripts
│
├── 📁 .mvn/                         # Maven configuration
│
├── 📁 docker/
│   └── 📁 docker-compose/
│       ├── 📄 docker-compose.both.yml       # Full Docker setup
│       └── 📄 docker-compose.mysql-only.yml # MySQL only setup
│
├── 📁 scripts/
│   ├── 📄 run-local.ps1             # Start Scenario 1
│   ├── 📄 run-docker-mysql.ps1      # Start Scenario 2
│   ├── 📄 run-docker-both.ps1       # Start Scenario 3
│   └── 📄 stop-all.ps1              # Stop all services
│
├── 📁 src/
│   ├── 📁 main/
│   │   ├── 📁 java/com/vbforge/mysql_docker/
│   │   │   ├── 📄 MysqlDockerApp.java
│   │   │   ├── 📁 controller/
│   │   │   ├── 📁 model/
│   │   │   ├── 📁 repository/
│   │   │   └── 📁 service/
│   │   └── 📁 resources/
│   │       ├── 📄 application.properties
│   │       ├── 📄 application-local.yml
│   │       ├── 📄 application-docker-mysql.yml
│   │       └── 📄 application-docker-both.yml
│   └── 📁 test/                     # Unit tests
│
└── 📁 target/                       # Built JAR files
```

## ⚙️ Configuration Files

### Profile Configuration Matrix

| File | Profile | Database Host | Port | Docker Required |
|------|---------|--------------|------|-----------------|
| `application-local.yml` | `local` | localhost | 3306 | No |
| `application-docker-mysql.yml` | `docker-mysql` | localhost | 3307 | Yes (MySQL only) |
| `application-docker-both.yml` | `docker-both` | mysql | 3306 | Yes (all) |

### Active Profile Selection

Edit `application.properties` to change default profile:
```properties
# Choose your profile (uncomment one):
# spring.profiles.active=local
# spring.profiles.active=docker-mysql
# spring.profiles.active=docker-both
```

Or specify via command line:
```bash
mvn spring-boot:run "-Dspring-boot.run.profiles=docker-mysql"
```

## 🧪 Testing the API

Once running, test the endpoints:

### Basic CRUD Operations

```powershell
# 1. GET all tasks (initially empty)
curl http://localhost:8082/api/tasks

# 2. POST - Create a task
curl -X POST http://localhost:8082/api/tasks `
  -H "Content-Type: application/json" `
  -d '{"title":"Learn Docker","description":"Master containers","completed":false}'

# 3. GET task by ID
curl http://localhost:8082/api/tasks/1

# 4. PUT - Update task
curl -X PUT http://localhost:8082/api/tasks/1 `
  -H "Content-Type: application/json" `
  -d '{"title":"Learn Docker Advanced","description":"Multi-container apps","completed":true}'

# 5. Filter by status
curl "http://localhost:8082/api/tasks?completed=false"
curl "http://localhost:8082/api/tasks?completed=true"

# 6. DELETE - Remove task
curl -X DELETE http://localhost:8082/api/tasks/1
```

### Access phpMyAdmin (Scenarios 2 & 3)

Open browser: **http://localhost:8083**
- Server: `mysql`
- Username: `taskuser`
- Password: `taskpass`
- Database: `taskdb`

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Port Already in Use
```powershell
# Check what's using port 8082
netstat -ano | findstr :8082

# Check MySQL ports
netstat -ano | findstr :3306
netstat -ano | findstr :3307

# Kill process using specific port (replace PID)
taskkill /PID <PID> /F
```

#### Docker Not Running
```powershell
# Error: "Docker is not running"
# Solution: Start Docker Desktop from Start Menu
```

#### MySQL Connection Failed
```powershell
# Test Scenario 1 (local MySQL)
mysql -u taskuser -ptaskpass -h localhost -P 3306 -e "SELECT 1"

# Test Scenario 2 & 3 (Docker MySQL)
docker exec -it taskmanager-mysql mysql -u taskuser -ptaskpass -e "SELECT 1"
```

#### JAR Not Found
```powershell
# Manually build JAR
cd version3-mysql-docker
mvn clean package -DskipTests
```

#### Container Health Check Failed
```powershell
# View detailed logs
docker logs taskmanager-mysql
docker logs taskmanager-app

# Restart with fresh state
docker-compose -f docker/docker-compose/docker-compose.both.yml down -v
docker-compose -f docker/docker-compose/docker-compose.both.yml up -d
```

## 🧹 Cleanup

### Stop Everything
```powershell
cd scripts
.\stop-all.ps1
```

### Complete Clean (Remove All)
```powershell
# Stop all containers
docker-compose -f docker/docker-compose/docker-compose.both.yml down -v
docker-compose -f docker/docker-compose/docker-compose.mysql-only.yml down -v

# Remove Docker images
docker rmi docker-compose-taskmanager-app

# Clean Maven
mvn clean

# Remove Maven local cache (if needed)
rm -rf ~/.m2/repository/com/vbforge
```

## 📊 Quick Reference

### Scripts Summary

| Script | Scenario | What it does |
|--------|----------|--------------|
| `run-local.ps1` | 1 | Starts local MySQL, runs Spring Boot |
| `run-docker-mysql.ps1` | 2 | Starts MySQL in Docker, runs Spring Boot locally |
| `run-docker-both.ps1` | 3 | Builds JAR, starts all containers |
| `stop-all.ps1` | All | Stops all running services |

### Docker Commands Quick Reference

```powershell
# View running containers
docker ps

# View logs
docker logs taskmanager-app
docker logs taskmanager-mysql

# Execute in container
docker exec -it taskmanager-app sh
docker exec -it taskmanager-mysql bash

# Access MySQL CLI
docker exec -it taskmanager-mysql mysql -u taskuser -ptaskpass
```

## 🎯 Success Indicators

Your setup is working when you see:

1. **All containers healthy:**
   ```
   taskmanager-app      Up (healthy)
   taskmanager-mysql    Up (healthy)
   taskmanager-phpmyadmin Up
   ```

2. **Spring Boot started:**
   ```
   Started MysqlDockerApp in X seconds
   Access at: http://localhost:8082/api/tasks
   ```

3. **API returns valid response:**
   ```json
   []  // Empty array means connected to DB!
   ```

---

**Built with Spring Boot 3.5.0, MySQL 8.0, and Docker Desktop** 🚀


This README provides:
- Clear overview of all three scenarios
- Easy-to-follow quick start guide
- Detailed explanation of each deployment option
- Complete project structure documentation
- Troubleshooting guide for common issues
- Quick reference commands

>The documentation is structured so anyone (even after years) can quickly understand what each scenario does and how to use it!