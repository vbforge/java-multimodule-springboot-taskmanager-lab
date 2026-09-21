# Scenario 3: Everything in Docker
Write-Host "Starting Scenario 3: Everything in Docker" -ForegroundColor Green

# Get the script directory and project root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$dockerComposeFile = Join-Path $projectRoot "docker/docker-compose/docker-compose.both.yml"

Write-Host "Project Root: $projectRoot" -ForegroundColor Gray
Write-Host "Docker Compose File: $dockerComposeFile" -ForegroundColor Gray

# Check if Docker is running
$dockerRunning = docker info 2>$null
if (-not $dockerRunning) {
    Write-Host "Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Navigate to project root
Set-Location $projectRoot

# Build the JAR first
Write-Host "Building JAR file..." -ForegroundColor Yellow
mvn clean package -DskipTests

# Check if build was successful
if ($LASTEXITCODE -ne 0) {
    Write-Host "Maven build failed. Please check the errors above." -ForegroundColor Red
    exit 1
}

# Check if JAR was created
$jarFile = Join-Path $projectRoot "target/version3-mysql-docker-1.0.0.jar"
if (-not (Test-Path $jarFile)) {
    Write-Host "JAR file not found: $jarFile" -ForegroundColor Red
    exit 1
}

Write-Host "JAR file created successfully: $jarFile" -ForegroundColor Green

# Stop any existing containers
Write-Host "Stopping any existing containers..." -ForegroundColor Yellow
docker-compose -f $dockerComposeFile down -v 2>$null

# Start containers (no build needed since we're using pre-built JAR)
Write-Host "Starting Docker containers..." -ForegroundColor Yellow
docker-compose -f $dockerComposeFile up -d

# Check if docker-compose was successful
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker Compose failed. Check the errors above." -ForegroundColor Red
    exit 1
}

# Wait for containers to be ready
Write-Host "Waiting for containers to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

# Check status
Write-Host "Container status:" -ForegroundColor Cyan
docker-compose -f $dockerComposeFile ps

Write-Host ""
Write-Host "Application started at: http://localhost:8082/api/tasks" -ForegroundColor Green
Write-Host "phpMyAdmin at: http://localhost:8083" -ForegroundColor Green
Write-Host ""
Write-Host "Testing the API..." -ForegroundColor Yellow

# Test the API
Start-Sleep -Seconds 5
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8082/api/tasks" -UseBasicParsing -ErrorAction Stop
    Write-Host "API Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "API not ready yet. Check logs below." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Showing logs (Ctrl+C to exit logs, containers keep running):" -ForegroundColor Yellow
docker-compose -f $dockerComposeFile logs -f