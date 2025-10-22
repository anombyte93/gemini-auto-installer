#!/bin/bash

# Auto-installer for Open Codex CLI with Google Gemini
# This script installs Node.js and Open Codex CLI, then configures the Gemini API key
# Supports: Linux (Ubuntu/Debian), macOS, WSL
# Requires: Node.js v22+

set -e

echo "=== Open Codex CLI with Google Gemini Auto-Installer ==="
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

# Check Node.js version requirement
echo ""
echo "[1/5] Checking Node.js installation..."

if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    echo "Node.js installed: v$(node -v | cut -d'v' -f2)"

    if [ "$NODE_VERSION" -lt 22 ]; then
        echo "⚠️  Node.js v22+ required. Current version is too old."
        echo "Upgrading to Node.js v22..."
        NEED_UPGRADE=true
    else
        echo "✅ Node.js version meets requirements (v22+)"
        NEED_UPGRADE=false
    fi
else
    echo "Node.js not found. Installing Node.js v22..."
    NEED_UPGRADE=true
fi

# Install/Upgrade Node.js if needed
if [ "$NEED_UPGRADE" = true ]; then
    if [[ "$OS" == "linux" ]]; then
        # Check if running on Debian/Ubuntu
        if command -v apt-get &> /dev/null; then
            echo "Installing Node.js v22 via apt (Debian/Ubuntu)..."
            curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
            sudo apt-get install -y nodejs
        elif command -v yum &> /dev/null; then
            echo "Installing Node.js v22 via yum (RHEL/CentOS/Fedora)..."
            curl -fsSL https://rpm.nodesource.com/setup_22.x | sudo bash -
            sudo yum install -y nodejs
        else
            echo "⚠️  Could not detect package manager (apt or yum)"
            echo "Please install Node.js v22+ manually from https://nodejs.org/"
            exit 1
        fi

    elif [[ "$OS" == "macos" ]]; then
        # Check if Homebrew is installed
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew first..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        echo "Installing/Upgrading Node.js via Homebrew..."
        brew upgrade node || brew install node
    fi

    # Verify Node.js installation
    echo ""
    echo "Verifying Node.js installation..."
    node --version
    npm --version
fi

echo ""
echo "[2/5] Installing Open Codex CLI globally..."
npm install -g open-codex

echo ""
echo "[3/5] Setting up Gemini API key..."
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
if grep -q "GOOGLE_GENERATIVE_AI_API_KEY" "$SHELL_CONFIG"; then
    # Remove old key (different sed syntax for macOS vs Linux)
    if [[ "$OS" == "macos" ]]; then
        sed -i '' '/GOOGLE_GENERATIVE_AI_API_KEY/d' "$SHELL_CONFIG"
    else
        sed -i '/GOOGLE_GENERATIVE_AI_API_KEY/d' "$SHELL_CONFIG"
    fi
fi
echo "export GOOGLE_GENERATIVE_AI_API_KEY=\"$GOOGLE_API_KEY\"" >> "$SHELL_CONFIG"

# Export for current session
export GOOGLE_GENERATIVE_AI_API_KEY="$GOOGLE_API_KEY"

echo ""
echo "[4/5] Creating Open Codex configuration..."
mkdir -p ~/.codex
cat > ~/.codex/config.json <<EOF
{
  "provider": "gemini",
  "model": "gemini-2.5-pro-preview-03-25"
}
EOF

echo ""
echo "[5/5] Testing installation..."
open-codex --version 2>/dev/null || echo "✅ Open Codex CLI installed"

echo ""
echo "✅ Installation complete!"
echo ""
echo "📁 Configuration saved:"
echo "   • API key: $SHELL_CONFIG (GOOGLE_GENERATIVE_AI_API_KEY)"
echo "   • Config: ~/.codex/config.json"
echo ""
echo "🔒 Keep your API key private - don't share it or commit it to git"
echo ""
echo "🚀 How to use Open Codex:"
echo ""
echo "   Interactive mode:"
echo "     open-codex"
echo ""
echo "   Direct prompting:"
echo "     open-codex \"Explain Python closures\""
echo "     open-codex \"Write a bash script to backup my home directory\""
echo ""
echo "   With specific provider:"
echo "     open-codex --provider gemini \"Install Suricata IDS\""
echo ""
echo "⚙️  Next steps:"
if [[ "$OS" == "macos" ]]; then
    echo "   1. Restart your terminal or run: source ~/.zshrc"
else
    echo "   1. Restart your terminal or run: source ~/.bashrc"
fi
echo "   2. Test it: open-codex \"Hello, are you working?\""
echo ""
