#!/bin/bash

# Auto-installer for Google Gemini CLI
# This script installs Node.js and Gemini CLI, then configures the API key
# Supports: Linux (Ubuntu/Debian), macOS, WSL

set -e

echo "=== Google Gemini CLI Auto-Installer ==="
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux" ]]; then
    OS="linux"
    echo "🐧 Detected: Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo "🍎 Detected: macOS"
else
    echo "❌ Unsupported OS: $OSTYPE"
    echo "Please install Node.js manually from https://nodejs.org/"
    exit 1
fi

# Install Node.js
echo ""
echo "[1/4] Installing Node.js..."

if [[ "$OS" == "linux" ]]; then
    # Check if running on Debian/Ubuntu
    if command -v apt-get &> /dev/null; then
        echo "Installing Node.js via apt (Debian/Ubuntu)..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif command -v yum &> /dev/null; then
        echo "Installing Node.js via yum (RHEL/CentOS/Fedora)..."
        curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
        sudo yum install -y nodejs
    else
        echo "⚠️  Could not detect package manager (apt or yum)"
        echo "Please install Node.js manually from https://nodejs.org/"
        exit 1
    fi

elif [[ "$OS" == "macos" ]]; then
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Check if Node.js is already installed
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v)
        echo "Node.js already installed: $NODE_VERSION"
        echo "Updating to latest version..."
        brew upgrade node || brew install node
    else
        echo "Installing Node.js via Homebrew..."
        brew install node
    fi
fi

# Verify Node.js installation
echo ""
echo "Verifying Node.js installation..."
node --version
npm --version

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

# Detect shell config file
if [[ "$OS" == "macos" ]]; then
    # macOS typically uses zsh
    if [[ -f ~/.zshrc ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [[ -f ~/.bash_profile ]]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    else
        SHELL_CONFIG="$HOME/.zshrc"
        touch "$SHELL_CONFIG"
    fi
else
    # Linux typically uses bash
    SHELL_CONFIG="$HOME/.bashrc"
fi

# Add to shell config for persistence
if grep -q "GOOGLE_API_KEY" "$SHELL_CONFIG"; then
    # Remove old key (different sed syntax for macOS vs Linux)
    if [[ "$OS" == "macos" ]]; then
        sed -i '' '/GOOGLE_API_KEY/d' "$SHELL_CONFIG"
    else
        sed -i '/GOOGLE_API_KEY/d' "$SHELL_CONFIG"
    fi
fi
echo "export GOOGLE_API_KEY=\"$GOOGLE_API_KEY\"" >> "$SHELL_CONFIG"

# Export for current session
export GOOGLE_API_KEY="$GOOGLE_API_KEY"

echo ""
echo "[4/4] Testing installation..."
gemini --version

echo ""
echo "✅ Installation complete!"
echo ""
echo "🔑 Your API key has been saved to $SHELL_CONFIG"
echo "🔒 Keep your API key private - don't share it or commit it to git"
echo ""

if [[ "$OS" == "macos" ]]; then
    echo "Now restart your terminal or run: source ~/.zshrc"
else
    echo "Now restart your terminal or run: source ~/.bashrc"
fi
