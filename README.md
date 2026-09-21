# Task Manager REST API - Multi-Module Spring Boot Project

A comprehensive Task Manager API built with Spring Boot, demonstrating three different persistence strategies - from simple in-memory storage
to production-ready Docker deployment.

## 🎯 Project Overview

This project showcases three progressive versions of the same Task Manager API, each adding more complexity and production-ready features:

- **Version 1**: Simple in-memory storage - Perfect for understanding REST API basics
- **Version 2**: H2 database with JPA - Database integration with automatic schema generation
- **Version 3**: MySQL with Docker - Three deployment scenarios (local, mixed, fully containerized)

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [📁 Project Structure](#-project-structure)
- [📊 Versions Comparison](#-versions-comparison)
- [🚀 Version 1: In-Memory](#-version-1-in-memory)
- [💾 Version 2: H2 Database](#-version-2-h2-database)
- [🐳 Version 3: MySQL with Docker](#-version-3-mysql-with-docker)
- [🔧 API Endpoints (All Versions)](#-api-endpoints-all-versions)
- [🧪 Testing](#-testing)
- [💻 System Requirements](#-system-requirements)
- [🔧 Troubleshooting](#-troubleshooting)


## 🚀 Quick Start

### Clone and Build All Versions
```bash
git clone <your-repo-url>
cd java-multimodule-springboot-taskmanager-lab

# Build all modules
mvn clean install
```

### Run Individual Versions

| Version | Command | Port | Access URL |
|---------|---------|------|-------------|
| **v1 (In-Memory)** | `cd version1-inmemory && mvn spring-boot:run` | 8080 | http://localhost:8080/api/tasks |
| **v2 (H2)** | `cd version2-h2 && mvn spring-boot:run` | 8081 | http://localhost:8081/api/tasks |
| **v3 (MySQL/Docker)** | See [Version 3 section](#version-3-mysql-with-docker) | 8082 | http://localhost:8082/api/tasks |


## 📁 Project Structure

```
java-multimodule-springboot-taskmanager-lab/
│
├── pom.xml                          # Parent POM configuration
│
├── version1-inmemory/               # 🚀 Simplest version
│   ├── src/main/java/...           # Controller, Service, Repository
│   └── pom.xml                      # Spring Web only
│
├── version2-h2/                     # 💾 Database version
│   ├── src/main/java/...           # JPA Entities
│   ├── src/main/resources/
│   │   └── application.properties  # H2 configuration
│   └── pom.xml                      # Added Spring Data JPA + H2
│
├── version3-mysql-docker/           # 🐳 Production-ready
│   ├── Dockerfile                   # Container definition
│   ├── docker/                      # Docker Compose files
│   ├── scripts/                     # One-click deployment scripts
│   ├── src/main/resources/          # Multiple profiles
│   └── README.md                    # Detailed Docker documentation
│
└── README.md                        # This file
```

## 📊 Versions Comparison

| Feature | Version 1 | Version 2 | Version 3 |
|---------|-----------|-----------|-----------|
| **Port** | 8080 | 8081 | 8082 |
| **Persistence** | RAM only | Disk (file) | Persistent |
| **Data Survival** | ❌ Lost on restart | ❌ Lost on restart | ✅ Survives restarts |
| **SQL Support** | ❌ No | ✅ Yes (H2) | ✅ Yes (MySQL) |
| **External Database** | ❌ No | ❌ No | ✅ Yes |
| **Docker Support** | Optional | Optional | ✅ Full support |
| **JPA/Hibernate** | ❌ No | ✅ Yes | ✅ Yes |
| **Connection Pool** | ❌ No | ✅ HikariCP | ✅ HikariCP |
| **Multiple Profiles** | ❌ No | ❌ No | ✅ Yes (3 scenarios) |
| **Production Ready** | ⚠️ Dev only | ⚠️ Dev/Test | ✅ Production |
| **Learning Focus** | REST basics | JPA & ORM | Docker & DevOps |

### When to Use Each Version

- **Version 1**: Learning REST APIs, quick prototyping, no data persistence needed
- **Version 2**: Learning JPA/Hibernate, testing with embedded database
- **Version 3**: Production applications, team development, containerized deployment

## 🚀 Version 1: In-Memory

**Simplest implementation - perfect for learning REST API basics.**

### Features
- No database required
- ConcurrentHashMap for thread-safe storage
- Automatic ID generation
- Full CRUD operations

### Tech Stack
- Java 17+
- Spring Boot 3.5.0
- Spring Web
- Maven

### Run
```bash
cd version1-inmemory
mvn spring-boot:run
# App runs at: http://localhost:8080/api/tasks
```

### Data Persistence
⚠️ **Warning**: All data is lost when the application stops!

## 💾 Version 2: H2 Database

**Adds database persistence with JPA/Hibernate.**

### Features
- Embedded H2 database
- JPA entity mapping
- Automatic schema generation
- H2 Console for database management

### Tech Stack
- Java 17+
- Spring Boot 3.5.0
- Spring Web + Spring Data JPA
- H2 Database
- HikariCP Connection Pool

### Run
```bash
cd version2-h2
mvn spring-boot:run
# App runs at: http://localhost:8081/api/tasks
# H2 Console: http://localhost:8081/h2-console
```

### H2 Console Access
- JDBC URL: `jdbc:h2:mem:taskdb`
- Username: `sa`
- Password: (empty)

## 🐳 Version 3: MySQL with Docker

**Production-ready version with three deployment scenarios.**

### Three Deployment Scenarios

| Scenario | App Location | MySQL Location | Command | Best For |
|----------|-------------|----------------|---------|----------|
| **1. Local** | Your machine | Your machine | `.\scripts\run-local.ps1` | Fast development |
| **2. Docker MySQL** | Your machine | Docker container | `.\scripts\run-docker-mysql.ps1` | Isolated DB testing |
| **3. Full Docker** | Docker container | Docker container | `.\scripts\run-docker-both.ps1` | Production-like |

### Features
- MySQL 8.0 database
- Multiple configuration profiles
- Docker containerization
- phpMyAdmin for DB management
- Health checks and container orchestration
- Data persistence across restarts

### Tech Stack
- Java 17+
- Spring Boot 3.5.0
- Spring Web + Spring Data JPA
- MySQL 8.0
- Docker & Docker Compose
- phpMyAdmin

### Quick Start for Version 3
```bash
cd version3-mysql-docker

# For full Docker experience (recommended)
cd scripts
.\run-docker-both.ps1

# Access the API
curl http://localhost:8082/api/tasks

# Access phpMyAdmin
# Open browser: http://localhost:8083
# Server: mysql, Username: taskuser, Password: taskpass
```

📖 **Detailed documentation**: See `version3-mysql-docker/README.md`

## 🔧 API Endpoints (All Versions)

All versions share the same API contract:

| Method | Endpoint | Description | Request Body | Response |
|--------|----------|-------------|--------------|----------|
| GET | `/api/tasks` | Get all tasks | - | `200 OK` + Array |
| GET | `/api/tasks?completed=true/false` | Filter by status | - | `200 OK` + Array |
| GET | `/api/tasks/{id}` | Get task by ID | - | `200 OK` or `404 Not Found` |
| POST | `/api/tasks` | Create new task | `{"title":"...", "description":"...", "completed":false}` | `201 Created` + Task |
| PUT | `/api/tasks/{id}` | Update task | `{"title":"...", "description":"...", "completed":true}` | `200 OK` or `404 Not Found` |
| DELETE | `/api/tasks/{id}` | Delete task | - | `204 No Content` |

### Example Request/Response

**Create a task:**
```bash
curl -X POST http://localhost:8080/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn Spring Boot","description":"Complete the tutorial","completed":false}'
```

**Response:**
```json
{
  "id": 1,
  "title": "Learn Spring Boot",
  "description": "Complete the tutorial",
  "completed": false
}
```

## 🧪 Testing

### Test All Versions
```bash
# Test Version 1 (Port 8080)
curl http://localhost:8080/api/tasks

# Test Version 2 (Port 8081)
curl http://localhost:8081/api/tasks

# Test Version 3 (Port 8082)
curl http://localhost:8082/api/tasks
```

### Sample Test Script
```bash
#!/bin/bash
# test-api.sh - Test all endpoints

BASE_URL="http://localhost:8080"  # Change port for different versions

# 1. Create task
TASK=$(curl -s -X POST $BASE_URL/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Task","description":"Testing API","completed":false}')

echo "Created: $TASK"

# 2. Get all tasks
echo "All tasks: $(curl -s $BASE_URL/api/tasks)"

# 3. Get task by ID
echo "Task ID 1: $(curl -s $BASE_URL/api/tasks/1)"

# 4. Update task
curl -s -X PUT $BASE_URL/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Task","description":"Updated","completed":true}'

# 5. Delete task
curl -s -X DELETE $BASE_URL/api/tasks/1
```

## 💻 System Requirements

### Minimum Requirements
- **Java**: JDK 17 or later
- **Maven**: 3.6+ (or use included mvnw wrapper)
- **Memory**: 512MB RAM (1GB recommended)
- **Disk**: 500MB free space

### For Docker Scenarios (Version 3)
- **Docker Desktop** 4.0+
- **Memory**: 2GB RAM allocated to Docker
- **Ports**: 8082, 3307, 8083 must be available

### For Local MySQL (Version 3, Scenario 1)
- **MySQL Server** 8.0+
- **Port**: 3306 available

## 🔧 Troubleshooting

### Common Issues Across All Versions

#### Port Already in Use
```bash
# Check what's using the port (Windows)
netstat -ano | findstr :8080

# Check what's using the port (Linux/Mac)
lsof -i :8080

# Kill the process (replace PID)
kill -9 <PID>
```

#### Maven Build Fails
```bash
# Clean and rebuild
mvn clean install -U

# Skip tests if needed
mvn clean install -DskipTests
```

### Version-Specific Issues

**Version 2 - H2 Console not accessible:**
- Check `application.properties` has `spring.h2.console.enabled=true`
- Access at: http://localhost:8081/h2-console

**Version 3 - Docker issues:**
```bash
# Check Docker is running
docker ps

# Reset Docker environment
docker system prune -a --volumes

# See detailed logs
docker-compose -f docker/docker-compose/docker-compose.both.yml logs
```

---

**Built with Spring Boot 3.5.0, Java 17, and Docker** 🚀

