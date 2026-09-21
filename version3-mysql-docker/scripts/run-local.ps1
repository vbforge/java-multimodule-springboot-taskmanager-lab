# Scenario 1: Everything Local (No Docker)
Write-Host "Starting Scenario 1: Local App + Local MySQL" -ForegroundColor Green

# Get the script directory and project root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir

Write-Host "Project Root: $projectRoot" -ForegroundColor Gray

# Check if MySQL is running
$mysqlService = Get-Service -Name "MySQL80" -ErrorAction SilentlyContinue
if ($mysqlService -and $mysqlService.Status -ne 'Running') {
    Write-Host "Starting MySQL service..." -ForegroundColor Yellow
    Start-Service MySQL80
    Start-Sleep -Seconds 5
} elseif (-not $mysqlService) {
    Write-Host "Warning: MySQL80 service not found. Make sure MySQL is installed and running." -ForegroundColor Red
    Write-Host "Continue anyway? (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -ne 'Y') { exit }
}

# Run the Spring Boot app with local profile
Write-Host "Starting Spring Boot application..." -ForegroundColor Yellow
Write-Host "App will run at: http://localhost:8082/api/tasks" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the application" -ForegroundColor Cyan
Write-Host ""

# Navigate to project root and run Maven
Set-Location $projectRoot
mvn spring-boot:run "-Dspring-boot.run.profiles=local"
