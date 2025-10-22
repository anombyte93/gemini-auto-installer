#!/bin/bash

# Instructor SSH Access Setup Script
# Allows instructors to SSH into student machines for troubleshooting
# Version: 1.0

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

clear
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${CYAN}  Instructor SSH Access Setup${NC}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${YELLOW}📋 What this script does:${NC}"
echo "   • Adds instructor's SSH public key for remote access"
echo "   • Optionally creates a dedicated instructor account"
echo "   • Enables SSH if not already running"
echo "   • Shows connection information for instructor"
echo "   • Creates audit log of instructor access"
echo ""
echo -e "${GREEN}✓ Safe and reversible${NC}"
echo -e "${GREEN}✓ Only grants access to specified instructor key${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}⚠️  Don't run this script as root!${NC}"
   echo "Run as your regular user. It will ask for sudo when needed."
   exit 1
fi

# Prompt for student name
echo -e "${CYAN}What is your name?${NC}"
echo "This will help your instructor identify your machine"
echo ""
read -p "Enter your name: " STUDENT_NAME

if [ -z "$STUDENT_NAME" ]; then
    echo -e "${RED}Error: Name cannot be empty${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✓ Student name: $STUDENT_NAME${NC}"

echo ""
echo -e "${CYAN}Choose setup method:${NC}"
echo ""
echo "  ${BOLD}1)${NC} Add instructor key to your account (simpler, recommended)"
echo "       ↳ Instructor connects as: $USER@your-ip"
echo ""
echo "  ${BOLD}2)${NC} Create dedicated 'instructor' account (more isolated)"
echo "       ↳ Instructor connects as: instructor@your-ip"
echo ""
read -p "Enter choice [1-2]: " setup_method

if [[ "$setup_method" == "1" ]]; then
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
    CREATE_USER=false
    echo ""
    echo -e "${GREEN}✓ Using your account: $USER${NC}"
elif [[ "$setup_method" == "2" ]]; then
    TARGET_USER="instructor"
    TARGET_HOME="/home/instructor"
    CREATE_USER=true
    echo ""
    echo -e "${GREEN}✓ Will create dedicated instructor account${NC}"
else
    echo -e "${RED}Invalid choice${NC}"
    exit 1
fi

echo ""
echo -e "${BOLD}${YELLOW}⚠️  INSTRUCTOR: Provide your SSH public key${NC}"
echo ""
echo "Methods to get instructor's public key:"
echo ""
echo "  ${BOLD}Option A: Instructor provides URL${NC}"
echo "    Example: https://pastebin.com/raw/abc123"
echo "    Example: https://gist.githubusercontent.com/.../instructor_key.pub"
echo ""
echo "  ${BOLD}Option B: Paste the key directly${NC}"
echo "    Starts with: ssh-rsa AAAA... or ssh-ed25519 AAAA..."
echo ""
echo "  ${BOLD}Option C: Read from file${NC}"
echo "    Type: file:/path/to/key.pub"
echo ""
read -p "Enter URL, paste key, or file path: " key_input

# Fetch or read the key
if [[ "$key_input" =~ ^https?:// ]]; then
    echo ""
    echo -e "${CYAN}Fetching key from URL...${NC}"
    INSTRUCTOR_KEY=$(curl -fsSL "$key_input")
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to fetch key from URL${NC}"
        exit 1
    fi
elif [[ "$key_input" =~ ^file: ]]; then
    KEY_FILE="${key_input#file:}"
    if [ ! -f "$KEY_FILE" ]; then
        echo -e "${RED}File not found: $KEY_FILE${NC}"
        exit 1
    fi
    INSTRUCTOR_KEY=$(cat "$KEY_FILE")
elif [[ "$key_input" =~ ^ssh- ]]; then
    INSTRUCTOR_KEY="$key_input"
else
    echo -e "${RED}Invalid input. Key should start with 'ssh-' or be a URL${NC}"
    exit 1
fi

# Validate the key format
if [[ ! "$INSTRUCTOR_KEY" =~ ^ssh-(rsa|ed25519|ecdsa|dss) ]]; then
    echo -e "${RED}Invalid SSH key format${NC}"
    echo "Key should start with: ssh-rsa, ssh-ed25519, ssh-ecdsa, or ssh-dss"
    exit 1
fi

echo -e "${GREEN}✓ Valid SSH key received${NC}"
echo ""

# Extract key comment (usually contains email or identifier)
KEY_COMMENT=$(echo "$INSTRUCTOR_KEY" | awk '{print $3}')
if [ ! -z "$KEY_COMMENT" ]; then
    echo -e "${CYAN}Key identifier: $KEY_COMMENT${NC}"
    echo ""
fi

# Confirm setup
echo -e "${YELLOW}Ready to configure instructor access:${NC}"
echo ""
if [ "$CREATE_USER" = true ]; then
    echo "  • Create user: $TARGET_USER"
fi
echo "  • Add instructor SSH key"
echo "  • Enable SSH service"
echo "  • Setup audit logging"
echo ""
read -p "Continue? (y/n): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo -e "${CYAN}[1/5] Installing OpenSSH server (if needed)...${NC}"

# Detect OS and install SSH
if command -v apt-get &> /dev/null; then
    # Debian/Ubuntu
    if ! dpkg -l | grep -q openssh-server; then
        echo "Installing openssh-server..."
        sudo apt-get update -qq
        sudo apt-get install -y openssh-server
    else
        echo "✓ SSH server already installed"
    fi
elif command -v yum &> /dev/null; then
    # RHEL/CentOS/Fedora
    if ! rpm -q openssh-server &> /dev/null; then
        echo "Installing openssh-server..."
        sudo yum install -y openssh-server
    else
        echo "✓ SSH server already installed"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "✓ macOS has SSH built-in"
else
    echo -e "${YELLOW}⚠️  Unknown OS, assuming SSH is installed${NC}"
fi

echo ""
echo -e "${CYAN}[2/5] Creating user account (if needed)...${NC}"

if [ "$CREATE_USER" = true ]; then
    if id "$TARGET_USER" &>/dev/null; then
        echo "✓ User '$TARGET_USER' already exists"
    else
        echo "Creating user '$TARGET_USER'..."
        sudo useradd -m -s /bin/bash "$TARGET_USER"
        echo "✓ User created"

        # Add to sudo group (optional, ask first)
        echo ""
        read -p "Give instructor sudo privileges? (y/n): " grant_sudo
        if [[ "$grant_sudo" =~ ^[Yy]$ ]]; then
            if command -v usermod &> /dev/null; then
                # Try common sudo group names
                if getent group sudo &> /dev/null; then
                    sudo usermod -aG sudo "$TARGET_USER"
                elif getent group wheel &> /dev/null; then
                    sudo usermod -aG wheel "$TARGET_USER"
                fi
                echo "✓ Sudo access granted"
            fi
        fi
    fi

    # Update target home
    TARGET_HOME=$(eval echo ~$TARGET_USER)
fi

echo ""
echo -e "${CYAN}[3/5] Setting up SSH key...${NC}"

# Create .ssh directory
SSH_DIR="$TARGET_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

if [ "$CREATE_USER" = true ]; then
    sudo mkdir -p "$SSH_DIR"
    sudo chmod 700 "$SSH_DIR"
else
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Add the key with identifier
KEY_LABEL="# Instructor access - Added $(date '+%Y-%m-%d %H:%M')"

if [ "$CREATE_USER" = true ]; then
    echo "$KEY_LABEL" | sudo tee -a "$AUTHORIZED_KEYS" > /dev/null
    echo "$INSTRUCTOR_KEY" | sudo tee -a "$AUTHORIZED_KEYS" > /dev/null
    sudo chmod 600 "$AUTHORIZED_KEYS"
    sudo chown -R "$TARGET_USER:$TARGET_USER" "$SSH_DIR"
else
    echo "$KEY_LABEL" >> "$AUTHORIZED_KEYS"
    echo "$INSTRUCTOR_KEY" >> "$AUTHORIZED_KEYS"
    chmod 600 "$AUTHORIZED_KEYS"
fi

echo "✓ SSH key added to $AUTHORIZED_KEYS"

echo ""
echo -e "${CYAN}[4/5] Configuring SSH service...${NC}"

# Enable and start SSH service
if command -v systemctl &> /dev/null; then
    # systemd systems
    sudo systemctl enable ssh 2>/dev/null || sudo systemctl enable sshd 2>/dev/null || true
    sudo systemctl start ssh 2>/dev/null || sudo systemctl start sshd 2>/dev/null || true
    echo "✓ SSH service enabled and started"
elif command -v service &> /dev/null; then
    # SysV init
    sudo service ssh start 2>/dev/null || sudo service sshd start 2>/dev/null || true
    echo "✓ SSH service started"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sudo systemsetup -setremotelogin on &> /dev/null
    echo "✓ Remote Login enabled"
fi

# Check SSH configuration
SSHD_CONFIG="/etc/ssh/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
    # Check if password authentication is disabled (common hardening)
    if sudo grep -q "^PasswordAuthentication no" "$SSHD_CONFIG"; then
        echo "✓ Password auth disabled (key-only access - more secure)"
    fi

    # Check if PubkeyAuthentication is enabled
    if sudo grep -q "^PubkeyAuthentication no" "$SSHD_CONFIG"; then
        echo -e "${YELLOW}⚠️  PubkeyAuthentication is disabled in sshd_config${NC}"
        echo "   You may need to enable it for key-based access"
    fi
fi

echo ""
echo -e "${CYAN}[5/5] Setting up audit logging...${NC}"

# Create audit log directory
AUDIT_DIR="$TARGET_HOME/.instructor-access"
AUDIT_LOG="$AUDIT_DIR/access.log"

if [ "$CREATE_USER" = true ]; then
    sudo mkdir -p "$AUDIT_DIR"
    echo "Instructor access configured on $(date)" | sudo tee "$AUDIT_LOG" > /dev/null
    sudo chown -R "$TARGET_USER:$TARGET_USER" "$AUDIT_DIR"
else
    mkdir -p "$AUDIT_DIR"
    echo "Instructor access configured on $(date)" > "$AUDIT_LOG"
fi

# Add login notification to bashrc
BASHRC="$TARGET_HOME/.bashrc"
LOGIN_NOTIFY="echo \"[$(date)] Instructor logged in\" >> $AUDIT_LOG"

if [ "$CREATE_USER" = true ]; then
    if ! sudo grep -q "Instructor logged in" "$BASHRC" 2>/dev/null; then
        echo "$LOGIN_NOTIFY" | sudo tee -a "$BASHRC" > /dev/null
    fi
else
    if ! grep -q "Instructor logged in" "$BASHRC" 2>/dev/null; then
        echo "$LOGIN_NOTIFY" >> "$BASHRC"
    fi
fi

echo "✓ Audit logging configured: $AUDIT_LOG"

# Get connection information
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  ✓ Setup Complete!${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${BOLD}📋 Connection Information (share with instructor):${NC}"
echo ""

# Get IP addresses
echo -e "${CYAN}IP Address(es):${NC}"
if command -v ip &> /dev/null; then
    ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | while read ip; do
        echo "  • $ip"
    done
elif command -v ifconfig &> /dev/null; then
    ifconfig | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | while read ip; do
        echo "  • $ip"
    done
fi

# Get hostname
HOSTNAME=$(hostname)
echo ""
echo -e "${CYAN}Hostname:${NC}"
echo "  • $HOSTNAME"

# SSH Port
SSH_PORT=$(sudo grep -E "^Port " /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
if [ -z "$SSH_PORT" ]; then
    SSH_PORT="22"
fi

echo ""
echo -e "${CYAN}SSH Port:${NC}"
echo "  • $SSH_PORT"

echo ""
echo -e "${CYAN}Username:${NC}"
echo "  • $TARGET_USER"

echo ""
echo -e "${BOLD}${YELLOW}📝 Instructor Connection Command:${NC}"
echo ""
echo -e "  ${BOLD}ssh $TARGET_USER@<STUDENT_IP>${NC}"
echo ""
echo "  Or with specific port:"
echo -e "  ${BOLD}ssh -p $SSH_PORT $TARGET_USER@<STUDENT_IP>${NC}"
echo ""

if [[ "$SSH_PORT" != "22" ]]; then
    echo -e "${YELLOW}Note: Non-standard SSH port detected ($SSH_PORT)${NC}"
    echo ""
fi

# Firewall warnings
echo -e "${YELLOW}⚠️  Firewall Check:${NC}"
if command -v ufw &> /dev/null; then
    if sudo ufw status | grep -q "Status: active"; then
        if ! sudo ufw status | grep -q "$SSH_PORT.*ALLOW"; then
            echo "  UFW firewall is active but SSH may not be allowed!"
            echo ""
            echo -e "  ${BOLD}Allow SSH through firewall:${NC}"
            echo "    sudo ufw allow $SSH_PORT/tcp"
            echo ""
        else
            echo "  ✓ UFW allows SSH traffic"
            echo ""
        fi
    fi
elif command -v firewall-cmd &> /dev/null; then
    if sudo firewall-cmd --state 2>/dev/null | grep -q running; then
        if ! sudo firewall-cmd --list-services | grep -q ssh; then
            echo "  Firewalld is active but SSH may not be allowed!"
            echo ""
            echo -e "  ${BOLD}Allow SSH through firewall:${NC}"
            echo "    sudo firewall-cmd --permanent --add-service=ssh"
            echo "    sudo firewall-cmd --reload"
            echo ""
        else
            echo "  ✓ Firewalld allows SSH traffic"
            echo ""
        fi
    fi
fi

# Network info
echo -e "${CYAN}💡 Tips:${NC}"
echo "  • If on different networks, you may need port forwarding"
echo "  • For cloud VMs, check security group settings"
echo "  • Test connection: instructor should run 'ssh $TARGET_USER@<IP>'"
echo "  • View access log: cat $AUDIT_LOG"
echo ""

# Removal instructions
echo -e "${CYAN}🗑️  To remove instructor access later:${NC}"
echo ""
if [ "$CREATE_USER" = true ]; then
    echo "  ${BOLD}Remove instructor user:${NC}"
    echo "    sudo userdel -r instructor"
else
    echo "  ${BOLD}Remove instructor SSH key:${NC}"
    echo "    sed -i '/Instructor access/,+1d' ~/.ssh/authorized_keys"
fi
echo ""

# Save connection info to file
INFO_FILE="$TARGET_HOME/instructor-connection-info.txt"
if [ "$CREATE_USER" = true ]; then
    sudo bash -c "cat > $INFO_FILE" <<EOF
Instructor SSH Access Information
Generated: $(date)

Username: $TARGET_USER
Port: $SSH_PORT
Key added: $(date '+%Y-%m-%d %H:%M')

Connection command:
  ssh $TARGET_USER@<STUDENT_IP>

To remove access:
  sudo userdel -r instructor
EOF
    sudo chown "$USER:$USER" "$INFO_FILE"
else
    cat > "$INFO_FILE" <<EOF
Instructor SSH Access Information
Generated: $(date)

Username: $TARGET_USER
Port: $SSH_PORT
Key added: $(date '+%Y-%m-%d %H:%M')

Connection command:
  ssh $TARGET_USER@<STUDENT_IP>

To remove access:
  sed -i '/Instructor access/,+1d' ~/.ssh/authorized_keys
EOF
fi

echo -e "${GREEN}✓ Connection info saved to: $INFO_FILE${NC}"
echo ""

# Register with instructor dashboard
echo ""
echo -e "${CYAN}🎓 Registering with instructor dashboard...${NC}"
echo ""
read -p "Enter instructor dashboard IP (or press Enter to skip): " DASHBOARD_IP

if [ ! -z "$DASHBOARD_IP" ]; then
    # Get primary IP address
    if command -v ip &> /dev/null; then
        PRIMARY_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1)
    elif command -v ifconfig &> /dev/null; then
        PRIMARY_IP=$(ifconfig | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1)
    else
        PRIMARY_IP="unknown"
    fi

    # Register with dashboard
    REGISTRATION_DATA=$(cat <<EOF
{
    "name": "$STUDENT_NAME",
    "ip": "$PRIMARY_IP",
    "port": "$SSH_PORT",
    "username": "$TARGET_USER"
}
EOF
)

    if command -v curl &> /dev/null; then
        RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" \
            -d "$REGISTRATION_DATA" \
            "http://$DASHBOARD_IP:8080/api/register" 2>/dev/null)

        if echo "$RESPONSE" | grep -q "success"; then
            echo -e "${GREEN}✓ Successfully registered with instructor dashboard${NC}"
            echo "  Your instructor can now see your machine at: http://$DASHBOARD_IP:8080"
        else
            echo -e "${YELLOW}⚠️  Could not register with dashboard${NC}"
            echo "  Dashboard might not be running at $DASHBOARD_IP:8080"
            echo "  You can manually provide connection info to your instructor"
        fi
    else
        echo -e "${YELLOW}⚠️  curl not installed, skipping dashboard registration${NC}"
        echo "  Install curl to enable automatic registration: sudo apt-get install curl"
    fi
else
    echo "Skipped dashboard registration"
    echo "You can manually provide connection info to your instructor"
fi

echo ""
