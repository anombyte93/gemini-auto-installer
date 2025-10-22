#!/bin/bash

# Instructor Dashboard Launcher
# Starts the web-based dashboard for viewing student SSH connections

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${CYAN}  🎓 Instructor Dashboard Launcher${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo ""
    echo "The dashboard requires Node.js to run."
    echo ""
    echo "Install Node.js:"
    echo "  • Ubuntu/Debian: sudo apt-get install nodejs"
    echo "  • macOS: brew install node"
    echo "  • Or download from: https://nodejs.org/"
    echo ""
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 14 ]; then
    echo -e "${YELLOW}⚠️  Node.js v14+ recommended (you have v$(node -v | cut -d'v' -f2))${NC}"
    echo "Dashboard may not work correctly with older Node.js versions"
    echo ""
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DASHBOARD_SCRIPT="$SCRIPT_DIR/instructor-dashboard.js"

# Check if dashboard script exists
if [ ! -f "$DASHBOARD_SCRIPT" ]; then
    echo -e "${RED}❌ Dashboard script not found: $DASHBOARD_SCRIPT${NC}"
    echo ""
    echo "Make sure you have cloned the complete repository"
    exit 1
fi

# Make dashboard script executable
chmod +x "$DASHBOARD_SCRIPT"

echo -e "${GREEN}✓ Node.js installed: $(node -v)${NC}"
echo -e "${GREEN}✓ Dashboard script found${NC}"
echo ""

# Get local IP
if command -v ip &> /dev/null; then
    LOCAL_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1)
elif command -v ifconfig &> /dev/null; then
    LOCAL_IP=$(ifconfig | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1)
else
    LOCAL_IP="localhost"
fi

DASHBOARD_PORT=${DASHBOARD_PORT:-8080}

echo -e "${CYAN}📊 Dashboard Information:${NC}"
echo ""
echo "  Dashboard will be accessible at:"
echo -e "    ${BOLD}http://$LOCAL_IP:$DASHBOARD_PORT${NC}"
echo -e "    ${BOLD}http://localhost:$DASHBOARD_PORT${NC} (local access)"
echo ""
echo "  Students should use this IP when running setup-instructor-access.sh:"
echo -e "    ${BOLD}$LOCAL_IP${NC}"
echo ""

echo -e "${YELLOW}📋 Instructions for Students:${NC}"
echo ""
echo "  1. Students run: ./setup-instructor-access.sh"
echo "  2. When prompted for dashboard IP, they enter: $LOCAL_IP"
echo "  3. Students will automatically appear in your dashboard"
echo ""

echo -e "${CYAN}⚙️  Dashboard Features:${NC}"
echo ""
echo "  • Real-time student status (online/offline)"
echo "  • Click-to-copy SSH commands"
echo "  • Auto-refresh every 30 seconds"
echo "  • Clean, modern interface"
echo ""

read -p "Press Enter to start the dashboard (or Ctrl+C to cancel)..."

echo ""
echo -e "${GREEN}🚀 Starting dashboard...${NC}"
echo ""

# Check if port is already in use
if command -v lsof &> /dev/null; then
    if lsof -Pi :$DASHBOARD_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  Port $DASHBOARD_PORT is already in use${NC}"
        echo ""
        read -p "Try a different port? (default: 8081): " NEW_PORT
        DASHBOARD_PORT=${NEW_PORT:-8081}
        echo ""
    fi
fi

# Start the dashboard
export DASHBOARD_PORT
exec node "$DASHBOARD_SCRIPT"
