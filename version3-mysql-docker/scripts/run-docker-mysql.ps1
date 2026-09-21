# Scenario 2: App Local, MySQL in Docker
Write-Host "Starting Scenario 2: Local App + MySQL in Docker" -ForegroundColor Green

# Get the script directory and project root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$dockerComposeFile = Join-Path $projectRoot "docker/docker-compose/docker-compose.mysql-only.yml"

Write-Host "Project Root: $projectRoot" -ForegroundColor Gray
Write-Host "Docker Compose File: $dockerComposeFile" -ForegroundColor Gray

# Check if Docker is running
$dockerRunning = docker info 2>$null
if (-not $dockerRunning) {
    Write-Host "Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if docker-compose file exists
if (-not (Test-Path $dockerComposeFile)) {
    Write-Host "Docker Compose file not found: $dockerComposeFile" -ForegroundColor Red
    exit 1
}

# Start MySQL container only
Write-Host "Starting MySQL container..." -ForegroundColor Yellow
docker-compose -f $dockerComposeFile up -d

# Wait for MySQL to be ready
Write-Host "Waiting for MySQL to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check if MySQL is healthy
$mysqlHealth = docker inspect --format='{{.State.Health.Status}}' taskmanager-mysql 2>$null
if ($mysqlHealth -ne "healthy") {
    Write-Host "MySQL is not healthy. Waiting additional 5 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
}

# Run the Spring Boot app with docker-mysql profile
Write-Host "Starting Spring Boot application..." -ForegroundColor Yellow
Write-Host "App will run at: http://localhost:8082/api/tasks" -ForegroundColor Cyan
Write-Host "phpMyAdmin at: http://localhost:8083" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the application" -ForegroundColor Cyan
Write-Host ""

# Navigate to project root and run Maven
Set-Location $projectRoot
mvn spring-boot:run "-Dspring-boot.run.profiles=docker-mysql"