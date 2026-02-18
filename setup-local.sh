#!/bin/bash
# Quick Start: Nanobot Local Setup (macOS/Linux)
# This script helps you configure Nanobot for local development with Telegram/Slack

set -e

echo "=== Nanobot Local Setup ==="
echo ""

# Check Python
echo "Checking Python..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 not found. Please install Python 3.11+"
    exit 1
fi
PYTHON_VERSION=$(python3 --version)
echo "✓ Python: $PYTHON_VERSION"

# Check if in nanobot repo
echo ""
echo "Checking repository..."
if [ ! -d "nanobot" ]; then
    echo "ERROR: nanobot directory not found. Run this script from the repo root."
    exit 1
fi
echo "✓ In nanobot repository"

# Install/check nanobot
echo ""
echo "Installing/checking Nanobot..."
pip install -e . > /dev/null 2>&1
echo "✓ Nanobot installed"

# Check config
CONFIG_PATH="$HOME/.nanobot/config.json"
echo ""
echo "Config file: $CONFIG_PATH"
if [ ! -f "$CONFIG_PATH" ]; then
    echo "⚠ Config not found. Creating from template..."
    if [ -f "config.template.json" ]; then
        mkdir -p "$(dirname "$CONFIG_PATH")"
        cp "config.template.json" "$CONFIG_PATH"
        echo "✓ Config created from template"
    else
        echo "⚠ config.template.json not found. Skipping..."
    fi
else
    echo "✓ Config exists"
fi

# Show next steps
echo ""
echo "=== Next Steps ==="
echo ""
echo "1. Get Telegram Bot Token (optional but recommended):"
echo "   - Open Telegram, search @BotFather"
echo "   - Send /newbot, follow prompts"
echo "   - Copy bot token"
echo ""
echo "2. Get Your Telegram User ID:"
echo "   - Search @userinfobot"
echo "   - Send any message"
echo "   - Copy your user ID"
echo ""
echo "3. Edit config file:"
echo "   nano \"$CONFIG_PATH\""
echo "   - Set LLM API key (openrouter, anthropic, openai, etc.)"
echo "   - Set telegram.token and allowFrom[0]"
echo ""
echo "4. Start the gateway:"
echo "   nanobot gateway"
echo ""
echo "5. Send a message via Telegram to your bot"
echo ""
echo "For full instructions, see: LOCAL_SETUP.md"
echo ""
echo "More info:"
echo "  - Status: nanobot status"
echo "  - CLI mode: nanobot agent -m 'Your question'"
echo "  - Interactive: nanobot agent"
echo ""
