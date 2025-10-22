# Instructor Guide - Remote SSH Access

**Quick and secure SSH access to student machines for troubleshooting.**

---

## 🎯 Overview

This guide helps instructors set up SSH access to student machines for remote troubleshooting and support.

**Benefits:**
- ✅ Simple one-time setup per student
- ✅ Secure key-based authentication
- ✅ Audit logging of instructor access
- ✅ Easy to remove when course ends
- ✅ Works across different networks
- ✅ **NEW:** Web dashboard to view all students at a glance

---

## 🆕 Instructor Dashboard (Recommended)

**NEW FEATURE:** Web-based dashboard for managing student connections!

Instead of manually collecting connection info from each student, use the instructor dashboard:

### Quick Start with Dashboard

**Step 1: Start the Dashboard (Instructor Machine)**

```bash
cd gemini-auto-installer
./start-dashboard.sh
```

The dashboard will start on port 8080 and show your IP address (e.g., `192.168.1.50`)

**Step 2: Students Register Automatically**

When students run `./setup-instructor-access.sh`, they'll be prompted:
```
Enter instructor dashboard IP (or press Enter to skip): 192.168.1.50
```

After entering your IP, they'll automatically appear in your dashboard!

**Step 3: View and Connect**

Open your browser to see all students:
```
http://localhost:8080
```

Features:
- 🟢 Real-time online/offline status
- 📋 Click any SSH command to copy to clipboard
- 🔄 Auto-refresh every 30 seconds
- 📊 Statistics: Total students, online count, offline count
- 🗑️ Clear all students button

### Dashboard Screenshots

**Main View:**
```
┌─────────────────────────────────────────────────────────┐
│         🎓 Instructor Dashboard                         │
│         Monitor and connect to student machines         │
├─────────────────────────────────────────────────────────┤
│  Total Students: 15   Online: 12   Offline: 3          │
├─────────────────────────────────────────────────────────┤
│ # │ Name      │ IP           │ Status   │ SSH Command  │
├───┼───────────┼──────────────┼──────────┼──────────────┤
│ 1 │ John Doe  │ 192.168.1.10 │ 🟢 Online│ ssh john@... │
│ 2 │ Jane Smith│ 192.168.1.11 │ 🟢 Online│ ssh jane@... │
│ 3 │ Bob Wilson│ 192.168.1.12 │ 🔴 Offline│ ssh bob@... │
└─────────────────────────────────────────────────────────┘
```

### Dashboard Requirements

- Node.js v14+ (automatically installed if you followed main install)
- Port 8080 available (configurable via `DASHBOARD_PORT=8081 ./start-dashboard.sh`)
- Same network as students (for automatic registration)

### Troubleshooting Dashboard

**Port already in use:**
```bash
DASHBOARD_PORT=8081 ./start-dashboard.sh
```

**Students can't connect to dashboard:**
- Check firewall allows port 8080: `sudo ufw allow 8080/tcp`
- Verify IP address with: `ip addr show`
- Test from student machine: `curl http://INSTRUCTOR_IP:8080`

**Clear all registered students:**
- Click "Clear All" button in dashboard
- Or delete: `~/.instructor-dashboard/students.json`

---

## 📋 Prerequisites

### For Instructor (You)

1. **Generate SSH key pair** (if you don't have one):

```bash
ssh-keygen -t ed25519 -C "instructor@yourdomain.com"
```

This creates:
- Private key: `~/.ssh/id_ed25519` (keep this SECRET!)
- Public key: `~/.ssh/id_ed25519.pub` (share this with students)

2. **Share your public key with students:**

**Option A: Upload to a URL (Recommended)**
```bash
# Upload to pastebin, gist, or your server
cat ~/.ssh/id_ed25519.pub
# Copy output and upload to: https://pastebin.com/ or https://gist.github.com/
```

**Option B: Email/share the public key file**
- Send students the file: `~/.ssh/id_ed25519.pub`
- Or copy the contents and send via chat/email

### For Students

Students need:
- Ubuntu/Debian/RHEL/Fedora/macOS system
- Internet connection
- sudo access
- This repository cloned

---

## 🚀 Quick Start

### Step 1: Instructor Prepares SSH Key

```bash
# If you don't have an SSH key yet
ssh-keygen -t ed25519 -C "instructor@yourdomain.com"

# Display your PUBLIC key (share this with students)
cat ~/.ssh/id_ed25519.pub
```

**Example output:**
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJqfxyz... instructor@yourdomain.com
```

Upload this to:
- https://pastebin.com/
- https://gist.github.com/
- Your own server
- Or send directly to students

### Step 2: Students Run Setup Script

**Students run this in their terminal:**

```bash
cd gemini-auto-installer
chmod +x setup-instructor-access.sh
./setup-instructor-access.sh
```

The script will ask:
1. **Setup method**: Add to student's account OR create dedicated instructor account
2. **Instructor's SSH key**: Paste the URL, file path, or key directly
3. **Confirmation**: Review and confirm

**Example student session:**
```
Choose setup method:
  1) Add instructor key to your account (simpler, recommended)
  2) Create dedicated 'instructor' account (more isolated)

Enter choice [1-2]: 1

Enter URL, paste key, or file path: https://pastebin.com/raw/abc123

✓ Valid SSH key received
Continue? (y/n): y

[Setup proceeds...]

✓ Setup Complete!

Connection Command:
  ssh student-username@192.168.1.100
```

### Step 3: Instructor Connects

Students will provide you with:
- Their IP address (e.g., `192.168.1.100`)
- Username (their username or `instructor`)
- SSH port (usually `22`)

**Connect:**
```bash
ssh student-username@192.168.1.100
```

Or if they're using a non-standard port:
```bash
ssh -p 2222 student-username@192.168.1.100
```

**First-time connection:**
```bash
The authenticity of host '192.168.1.100' can't be established.
ED25519 key fingerprint is SHA256:xxxxx...
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

Type `yes` and press Enter.

---

## 🔧 Setup Methods

### Method 1: Add to Student's Account (Recommended)

**Pros:**
- Simpler setup
- Access student's files directly
- No extra user management

**Cons:**
- Full access to student's account

**Student runs:**
```bash
./setup-instructor-access.sh
# Choose option 1
```

**Instructor connects as:**
```bash
ssh student-username@student-ip
```

### Method 2: Dedicated Instructor Account

**Pros:**
- Isolated access
- Cleaner separation
- Can grant/revoke sudo separately

**Cons:**
- Slightly more complex
- Need to switch users to access student files

**Student runs:**
```bash
./setup-instructor-access.sh
# Choose option 2
# Optionally grant sudo access
```

**Instructor connects as:**
```bash
ssh instructor@student-ip
```

**To access student files:**
```bash
# After SSH'd in as instructor
sudo su - student-username
```

---

## 🌐 Network Scenarios

### Scenario 1: Same Local Network (Classroom/Lab)

**Student checks IP:**
```bash
ip addr show | grep "inet " | grep -v 127.0.0.1
```

**Instructor connects:**
```bash
ssh student@192.168.1.100
```

✅ Works directly, no additional setup needed.

### Scenario 2: Different Networks (Remote Students)

Students need to:

**Option A: Port Forwarding (Home Router)**
1. Find public IP: https://whatismyipaddress.com/
2. Setup port forwarding on router:
   - External port: 2222
   - Internal IP: Student's local IP (192.168.x.x)
   - Internal port: 22
3. Share public IP with instructor

**Instructor connects:**
```bash
ssh -p 2222 student@public-ip-address
```

**Option B: Use SSH Tunnel Service**
- ngrok: https://ngrok.com/
- localtunnel: https://localtunnel.me/
- Telebit: https://telebit.cloud/

**Example with ngrok:**
```bash
# Student runs
ngrok tcp 22

# Shows: Forwarding tcp://0.tcp.ngrok.io:12345 -> localhost:22
# Student shares: 0.tcp.ngrok.io:12345 with instructor

# Instructor connects
ssh -p 12345 student@0.tcp.ngrok.io
```

### Scenario 3: Cloud VMs (AWS/Azure/GCP)

Students need to:
1. Get VM's public IP from cloud console
2. Update security group/firewall rules to allow SSH from instructor's IP
3. Share public IP with instructor

**Instructor connects:**
```bash
ssh student@cloud-vm-public-ip
```

---

## 🔒 Security Best Practices

### For Instructors

✅ **DO:**
- Use key-based authentication (never passwords)
- Keep your private key secure (`chmod 600 ~/.ssh/id_ed25519`)
- Use strong passphrase for private key
- Limit access to specific student IPs if possible
- Delete student entries from `~/.ssh/known_hosts` after course ends

❌ **DON'T:**
- Share your private key with anyone
- Use the same key for everything
- Leave access configured after course ends

### For Students

✅ **DO:**
- Only add instructor's public key (provided by instructor)
- Review the key before adding
- Remove access after course/troubleshooting ends
- Check audit logs periodically

❌ **DON'T:**
- Add unknown public keys
- Share your own private keys
- Disable SSH logging

---

## 📊 Monitoring Access

### Student: Check Audit Log

```bash
cat ~/.instructor-access/access.log
```

**Example output:**
```
Instructor access configured on 2025-10-22 14:30:00
[2025-10-22 14:35:12] Instructor logged in
[2025-10-22 15:20:45] Instructor logged in
```

### Student: View Active SSH Sessions

```bash
who
```

**Example output:**
```
student-name pts/0  2025-10-22 14:35 (192.168.1.50)  <- Instructor
student-name pts/1  2025-10-22 14:30 (192.168.1.100) <- Student
```

### Student: Monitor Real-Time Logins

```bash
tail -f ~/.instructor-access/access.log
```

---

## 🗑️ Removing Access

### Method 1: Remove Instructor Key (Keep Student Account)

**Student runs:**
```bash
# Edit authorized_keys and remove instructor's key
nano ~/.ssh/authorized_keys

# Or use sed to remove lines with "Instructor access" comment
sed -i '/Instructor access/,+1d' ~/.ssh/authorized_keys
```

### Method 2: Delete Dedicated Instructor Account

**Student runs:**
```bash
sudo userdel -r instructor
```

This removes:
- Instructor user account
- Instructor's home directory
- All instructor access

---

## 🐛 Troubleshooting

### Problem: "Connection refused"

**Possible causes:**
1. SSH service not running on student machine
2. Firewall blocking SSH
3. Wrong IP address
4. Wrong port

**Student checks:**
```bash
# Check SSH service status
sudo systemctl status ssh  # or sshd

# Check if SSH is listening
sudo ss -tlnp | grep ssh

# Check firewall (Ubuntu)
sudo ufw status

# Check firewall (RHEL/Fedora)
sudo firewall-cmd --list-all
```

**Student fixes:**
```bash
# Start SSH service
sudo systemctl start ssh

# Allow SSH through firewall (Ubuntu)
sudo ufw allow 22/tcp

# Allow SSH through firewall (RHEL/Fedora)
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

### Problem: "Permission denied (publickey)"

**Possible causes:**
1. Instructor's key not properly added
2. Wrong permissions on .ssh directory
3. SSH configured to reject key auth

**Student checks:**
```bash
# Verify key is in authorized_keys
cat ~/.ssh/authorized_keys | grep instructor

# Check permissions
ls -la ~/.ssh/
# Should be: drwx------ (700) for directory
#            -rw------- (600) for authorized_keys

# Fix permissions if needed
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

**Check SSH config:**
```bash
# Ensure PubkeyAuthentication is enabled
sudo grep PubkeyAuthentication /etc/ssh/sshd_config
# Should be: PubkeyAuthentication yes

# If disabled, enable it
sudo sed -i 's/^PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

### Problem: "No route to host"

**Possible causes:**
1. Network firewall blocking connection
2. Wrong network configuration
3. VPN required

**Student checks:**
```bash
# Check if SSH port is open from student side
sudo ss -tlnp | grep :22

# Try to connect to yourself (should work)
ssh localhost
```

**Instructor checks:**
```bash
# Test if port is reachable
nc -zv student-ip 22

# Or using telnet
telnet student-ip 22
```

### Problem: Can't access student files (Method 2)

**If instructor account was created:**

```bash
# SSH in as instructor
ssh instructor@student-ip

# Switch to student user
sudo su - student-username

# Or access student home directly
cd /home/student-username
```

---

## 📝 Batch Setup (Multiple Students)

### For Instructors Teaching a Class

**1. Create a setup guide for students:**

```bash
# Create a file: student-setup-instructions.txt

SSH Setup Instructions
======================

1. Clone the repository:
   git clone https://github.com/anombyte93/gemini-auto-installer.git
   cd gemini-auto-installer

2. Run the setup script:
   chmod +x setup-instructor-access.sh
   ./setup-instructor-access.sh

3. When prompted:
   - Choose option 1 (use your account)
   - Enter this URL: https://pastebin.com/raw/YOUR_KEY_ID
   - Type 'y' to confirm

4. Share this info with instructor:
   - Your IP address (run: curl ifconfig.me)
   - Your username (run: whoami)

Done!
```

**2. Create a connection spreadsheet:**

| Student Name | Username | IP Address | Port | Status | Notes |
|--------------|----------|------------|------|--------|-------|
| Student 1    | student1 | 192.168.1.101 | 22 | ✅ Works | |
| Student 2    | student2 | 192.168.1.102 | 22 | ⚠️ Firewall | |
| Student 3    | student3 | 10.0.0.50 | 2222 | ✅ Works | Port forwarded |

**3. Create SSH config for easy access:**

```bash
# ~/.ssh/config

Host student1
    HostName 192.168.1.101
    User student1
    Port 22

Host student2
    HostName 192.168.1.102
    User student2
    Port 22

Host student3
    HostName 10.0.0.50
    User student3
    Port 2222
```

**Now connect with:**
```bash
ssh student1
ssh student2
ssh student3
```

---

## 🎓 Educational Use Cases

### Use Case 1: Real-Time Troubleshooting

**Student:** "I'm getting an error when running Suricata"

**Instructor:**
```bash
# SSH into student's machine
ssh student@192.168.1.100

# Check the service
sudo systemctl status suricata

# View logs
sudo journalctl -u suricata -n 50

# Fix the issue together (student watches)
sudo nano /etc/suricata/suricata.yaml

# Restart and verify
sudo systemctl restart suricata
```

### Use Case 2: Configuration Review

**Student:** "Can you check if my Wazuh integration is correct?"

**Instructor:**
```bash
ssh student@192.168.1.100

# Review configuration
cat /var/ossec/etc/ossec.conf

# Check logs
tail -f /var/log/suricata/eve.json

# Verify integration
sudo /var/ossec/bin/agent_control -i
```

### Use Case 3: Guided Lab Session

**Instructor can:**
- SSH into multiple students
- Check their progress in real-time
- Help those who are stuck
- Verify lab completion

```bash
# Quick check script
for student in student1 student2 student3; do
    echo "Checking $student..."
    ssh $student "systemctl status suricata" | grep Active
done
```

---

## 🔐 Advanced: Jump Host Setup

For managing many students, set up a jump host:

```bash
# ~/.ssh/config

Host jump-server
    HostName your-jump-server.com
    User instructor

Host student*
    ProxyJump jump-server
    User student

Host student1
    HostName 192.168.1.101

Host student2
    HostName 192.168.1.102
```

**Connect through jump host:**
```bash
ssh student1  # Automatically routes through jump-server
```

---

## 📚 Additional Resources

- **SSH Documentation:** https://man.openbsd.org/ssh
- **SSH Hardening Guide:** https://www.ssh.com/academy/ssh/sshd_config
- **ngrok Documentation:** https://ngrok.com/docs
- **Port Forwarding Guide:** https://portforward.com/

---

## ❓ FAQ

### Q: Is this secure?

**A:** Yes, when done properly:
- Key-based auth is more secure than passwords
- Only instructor's specific key is added
- Audit logging tracks access
- Can be easily revoked

### Q: Can students see what I'm doing?

**A:**
- If using SSH: They can see you're connected (via `who`)
- They can't see commands in real-time unless watching over your shoulder
- All commands are logged in their shell history

**Best practice:** Explain what you're doing as you troubleshoot (educational!)

### Q: What if a student's IP changes?

**A:**
- Student needs to provide new IP
- Update your SSH config or spreadsheet
- Connection method remains the same

### Q: Can I use this for grading?

**A:** Yes! You can:
- SSH in and check lab completion
- Review configuration files
- Test running services
- Collect logs or screenshots

### Q: What about Windows students?

**A:**
- Students should use WSL (Windows Subsystem for Linux)
- Or install OpenSSH Server on Windows
- Script works in WSL environment

### Q: How do I rotate my SSH key?

**A:**
1. Generate new key: `ssh-keygen -t ed25519`
2. Share new public key with students
3. Students re-run setup script with new key
4. Delete old private key

---

## 📞 Support

If students have issues with the setup script:
1. Check the troubleshooting section
2. Verify they have sudo access
3. Confirm SSH service is installed
4. Check firewall settings

For instructor access issues:
1. Verify student provided correct IP
2. Test network connectivity: `ping student-ip`
3. Test port access: `nc -zv student-ip 22`
4. Check your private key permissions: `chmod 600 ~/.ssh/id_ed25519`

---

**Made for instructors teaching cybersecurity, system administration, and Linux courses.**
