#!/bin/bash

# Auto-installer for Google Gemini CLI
# This script installs Node.js and Gemini CLI, then configures the API key

set -e

echo "=== Google Gemini CLI Auto-Installer ==="
echo ""

# Check if running on WSL/Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "[1/4] Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "[1/4] Installing Node.js via Homebrew..."
    brew install node
else
    echo "Please install Node.js manually from https://nodejs.org/"
    exit 1
fi

echo "[2/4] Installing Gemini CLI globally..."
npm install -g @google/generative-ai-cli

echo "[3/4] Setting up API key..."
echo ""
echo "You need a Google Gemini API key to use this tool."
echo "Get one FREE at: https://aistudio.google.com/app/apikey"
echo ""
read -p "Enter your Google Gemini API key: " GOOGLE_API_KEY

if [ -z "$GOOGLE_API_KEY" ]; then
    echo "❌ Error: API key cannot be empty"
    exit 1
fi

# Validate API key format (basic check)
if [[ ! "$GOOGLE_API_KEY" =~ ^AIza ]]; then
    echo "⚠️  Warning: API key doesn't look valid (should start with 'AIza')"
    read -p "Continue anyway? (y/n): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Add to bashrc for persistence
if grep -q "GOOGLE_API_KEY" ~/.bashrc; then
    # Remove old key
    sed -i '/GOOGLE_API_KEY/d' ~/.bashrc
fi
echo "export GOOGLE_API_KEY=\"$GOOGLE_API_KEY\"" >> ~/.bashrc

# Export for current session
export GOOGLE_API_KEY="$GOOGLE_API_KEY"

echo ""
echo "[4/4] Testing installation..."
gemini --version

echo ""
echo "✅ Installation complete!"
echo ""
echo "🔑 Your API key has been saved to ~/.bashrc"
echo "🔒 Keep your API key private - don't share it or commit it to git"
echo ""
echo "Now restart your terminal or run: source ~/.bashrc"
