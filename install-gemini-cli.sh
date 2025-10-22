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
export GOOGLE_API_KEY="AIzaSyAK9EcQBjNIUz2irGXwG10Hr2u201t66wU"

# Add to bashrc for persistence
if ! grep -q "GOOGLE_API_KEY" ~/.bashrc; then
    echo 'export GOOGLE_API_KEY="AIzaSyAK9EcQBjNIUz2irGXwG10Hr2u201t66wU"' >> ~/.bashrc
fi

echo "[4/4] Testing installation..."
gemini --version

echo ""
echo "✅ Installation complete!"
echo ""
echo "⚠️  WARNING: This API key is publicly exposed and may be revoked."
echo "    Generate your own at: https://aistudio.google.com/app/apikey"
echo ""
echo "Now restart your terminal or run: source ~/.bashrc"
