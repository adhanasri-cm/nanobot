# Quick Start: Nanobot Local Setup (Windows)
# This script helps you configure Nanobot for local development with Telegram/Slack

$ErrorActionPreference = "Stop"

Write-Host "=== Nanobot Local Setup ===" -ForegroundColor Green
Write-Host ""

# Check Python
Write-Host "Checking Python..." -ForegroundColor Cyan
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Python not found. Please install Python 3.11+" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Python: $pythonVersion"

# Check if in nanobot repo
Write-Host ""
Write-Host "Checking repository..." -ForegroundColor Cyan
if (-not (Test-Path "nanobot")) {
    Write-Host "ERROR: nanobot directory not found. Run this script from the repo root." -ForegroundColor Red
    exit 1
}
Write-Host "✓ In nanobot repository"

# Install/check nanobot
Write-Host ""
Write-Host "Installing/checking Nanobot..." -ForegroundColor Cyan
pip install -e . | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install nanobot" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Nanobot installed"

# Check config
$configPath = "$env:USERPROFILE\.nanobot\config.json"
Write-Host ""
Write-Host "Config file: $configPath" -ForegroundColor Cyan
if (-not (Test-Path $configPath)) {
    Write-Host "⚠ Config not found. Creating from template..." -ForegroundColor Yellow
    if (Test-Path "config.template.json") {
        Copy-Item "config.template.json" $configPath
        Write-Host "✓ Config created from template"
    } else {
        Write-Host "⚠ config.template.json not found. Skipping..." -ForegroundColor Yellow
    }
} else {
    Write-Host "✓ Config exists"
}

# Show next steps
Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Green
Write-Host ""
Write-Host "1. Get Telegram Bot Token (optional but recommended):"
Write-Host "   - Open Telegram, search @BotFather"
Write-Host "   - Send /newbot, follow prompts"
Write-Host "   - Copy bot token"
Write-Host ""
Write-Host "2. Get Your Telegram User ID:"
Write-Host "   - Search @userinfobot"
Write-Host "   - Send any message"
Write-Host "   - Copy your user ID"
Write-Host ""
Write-Host "3. Edit config file:"
Write-Host "   notepad `"$configPath`""
Write-Host "   - Set LLM API key (openrouter, anthropic, openai, etc.)"
Write-Host "   - Set telegram.token and allowFrom[0]"
Write-Host ""
Write-Host "4. Start the gateway:"
Write-Host "   nanobot gateway"
Write-Host ""
Write-Host "5. Send a message via Telegram to your bot"
Write-Host ""
Write-Host "For full instructions, see: LOCAL_SETUP.md"
Write-Host ""
Write-Host "More info:"
Write-Host "  - Status: nanobot status"
Write-Host "  - CLI mode: nanobot agent -m 'Your question'"
Write-Host "  - Interactive: nanobot agent"
Write-Host ""
