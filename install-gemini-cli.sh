#!/bin/bash

# Auto-installer for Open Codex CLI with Google Gemini
# This script installs Node.js and Open Codex CLI, then configures the Gemini API key
# Supports: Linux (Ubuntu/Debian), macOS, WSL
# Requires: Node.js v22+

set -e

# Colors for better readability
BOLD='\033[1m'
NC='\033[0m' # No Color

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
echo "[2/5] Checking Open Codex CLI installation..."

# Check if open-codex is already installed
if command -v open-codex &> /dev/null; then
    echo "✅ Open Codex CLI already installed"
    CODEX_VERSION=$(open-codex --version 2>/dev/null || echo "unknown")
    echo "   Version: $CODEX_VERSION"
    echo ""
    read -p "Reinstall/update Open Codex? (y/n): " reinstall_codex
    if [[ "$reinstall_codex" =~ ^[Yy]$ ]]; then
        echo "Updating Open Codex CLI..."
        npm install -g open-codex
    else
        echo "Skipping Open Codex installation."
    fi
else
    echo "Installing Open Codex CLI globally..."
    npm install -g open-codex
fi

echo ""
echo "[3/5] Setting up Gemini API key..."

# Check if API key is already configured
if [ ! -z "$GOOGLE_GENERATIVE_AI_API_KEY" ]; then
    echo "✅ API key already configured in environment"
    echo "   Key: ${GOOGLE_GENERATIVE_AI_API_KEY:0:20}..."
    echo ""
    read -p "Replace with a new API key? (y/n): " replace_key
    if [[ ! "$replace_key" =~ ^[Yy]$ ]]; then
        echo "Keeping existing API key."
        GOOGLE_API_KEY="$GOOGLE_GENERATIVE_AI_API_KEY"
        SKIP_KEY_SETUP=true
    else
        SKIP_KEY_SETUP=false
    fi
else
    SKIP_KEY_SETUP=false
fi

if [ "$SKIP_KEY_SETUP" = false ]; then
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
fi  # End of SKIP_KEY_SETUP check

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
echo "[5/6] Testing installation..."
open-codex --version 2>/dev/null || echo "✅ Open Codex CLI installed"

echo ""
echo "[6/6] Setting up Student Mode (optional)..."
echo ""
echo "Student Mode provides:"
echo "  • Guided prompts with educational explanations"
echo "  • Pre-built templates for common tasks"
echo "  • Step-by-step learning tutorials"
echo "  • Safety tips and best practices"
echo ""
read -p "Install Student Mode for beginner-friendly experience? (y/n): " install_student

if [[ "$install_student" =~ ^[Yy]$ ]]; then
    # Determine installation directory
    if [[ -d "$HOME/.local/bin" ]]; then
        INSTALL_DIR="$HOME/.local/bin"
    elif [[ -d "$HOME/bin" ]]; then
        INSTALL_DIR="$HOME/bin"
    else
        mkdir -p "$HOME/.local/bin"
        INSTALL_DIR="$HOME/.local/bin"
    fi

    # Get script directory
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Copy and setup student-codex
    if [[ -f "$SCRIPT_DIR/student-codex" ]]; then
        cp "$SCRIPT_DIR/student-codex" "$INSTALL_DIR/student-codex"
        chmod +x "$INSTALL_DIR/student-codex"

        # Add to PATH if not already there
        if [[ "$INSTALL_DIR" == "$HOME/.local/bin" ]]; then
            if ! grep -q ".local/bin" "$SHELL_CONFIG"; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
            fi
        elif [[ "$INSTALL_DIR" == "$HOME/bin" ]]; then
            if ! grep -q "HOME/bin" "$SHELL_CONFIG"; then
                echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_CONFIG"
            fi
        fi

        echo "✅ Student Mode installed to $INSTALL_DIR/student-codex"
        STUDENT_MODE_INSTALLED=true
    else
        echo "⚠️  student-codex script not found. Skipping."
        STUDENT_MODE_INSTALLED=false
    fi
else
    echo "Skipping Student Mode installation."
    STUDENT_MODE_INSTALLED=false
fi

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
if [[ "$STUDENT_MODE_INSTALLED" == true ]]; then
    echo -e "   ${BOLD}For Students (Recommended):${NC}"
    echo "     student-codex"
    echo "     ↳ Guided prompts, tutorials, safety tips"
    echo ""
    echo -e "   ${BOLD}Advanced Mode:${NC}"
    echo "     open-codex"
    echo "     ↳ Direct AI access (requires good prompting skills)"
    echo ""
else
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
fi
echo "⚙️  Next steps:"
if [[ "$OS" == "macos" ]]; then
    echo "   1. Restart your terminal or run: source ~/.zshrc"
else
    echo "   1. Restart your terminal or run: source ~/.bashrc"
fi
if [[ "$STUDENT_MODE_INSTALLED" == true ]]; then
    echo "   2. Run: student-codex"
    echo "   3. Start with the Tutorial (option 1)"
else
    echo "   2. Test it: open-codex \"Hello, are you working?\""
fi
echo ""

# Optional: Instructor SSH access setup
echo "═══════════════════════════════════════════════════════"
echo ""
echo "🎓 For Instructors: Enable Remote SSH Access?"
echo ""
echo "This allows instructors to SSH into this machine for troubleshooting."
echo "See INSTRUCTOR-GUIDE.md for details."
echo ""
read -p "Setup instructor SSH access now? (y/n): " setup_instructor_access

if [[ "$setup_instructor_access" =~ ^[Yy]$ ]]; then
    if [[ -f "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/setup-instructor-access.sh" ]]; then
        echo ""
        echo "Launching instructor access setup..."
        echo ""
        bash "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/setup-instructor-access.sh"
    else
        echo "⚠️  setup-instructor-access.sh not found."
        echo "   You can run it manually later if needed."
    fi
else
    echo ""
    echo "Skipped. You can run './setup-instructor-access.sh' anytime."
fi

echo ""
