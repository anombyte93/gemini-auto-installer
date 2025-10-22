# Student Instructions: Installing Suricata with AI Auto-Installer

## Step 1: Install Gemini CLI

Run this command:
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_REPO/install-gemini-cli.sh | bash
source ~/.bashrc
```

**OR manually:**
```bash
chmod +x install-gemini-cli.sh
./install-gemini-cli.sh
source ~/.bashrc
```

---

## Step 2: Use Gemini CLI as Your Auto-Installer

Now that Gemini CLI is installed, simply prompt it to install and configure software for you.

### For Suricata Installation on Systems with Wazuh Agents:

Run this command:
```bash
gemini "Install Suricata IDS on this Ubuntu system that has a Wazuh agent already installed. Configure Suricata to log network traffic to /var/log/suricata/ and integrate it with the Wazuh agent by configuring the ossec.conf file to monitor Suricata's eve.json logs. Enable all ET Open rulesets and configure network interface monitoring. Show me the exact commands to run."
```

### Alternative Prompt (More Detailed):

```bash
gemini "I need you to act as a system installer. My system has Wazuh agent installed. Please provide the complete bash script to: 1) Install Suricata IDS, 2) Configure it to monitor network interface eth0 or the default interface, 3) Enable network logging to eve.json format, 4) Update Wazuh agent's ossec.conf to monitor /var/log/suricata/eve.json, 5) Download and enable Emerging Threats rules, 6) Restart both Suricata and Wazuh agent services. Make it copy-paste ready."
```

---

## Step 3: Execute the Generated Commands

Gemini will provide you with commands. Review them, then execute:

```bash
# Gemini will give you commands like these (example):
sudo apt-get update
sudo apt-get install -y suricata
sudo systemctl enable suricata
# ... etc
```

---

## Common Prompts for Auto-Installation Tasks

### Install Software:
```bash
gemini "Install Docker on Ubuntu and add my user to the docker group"
```

### Configure Services:
```bash
gemini "Configure Suricata to use 4 CPU threads and enable all protocol analyzers"
```

### Integrate Tools:
```bash
gemini "Configure Wazuh agent to send Suricata alerts to the Wazuh manager at IP 192.168.1.100"
```

### Troubleshoot:
```bash
gemini "Suricata service failed to start. Check logs and fix the configuration issue"
```

### Generate Config Files:
```bash
gemini "Create a Suricata rule to detect SQL injection attempts on port 80 and 443"
```

---

## What Makes This an "Auto-Installer"?

The Gemini CLI acts as your AI-powered auto-installer by:
- Generating installation commands specific to your system
- Creating configuration files
- Providing integration steps
- Troubleshooting errors
- Explaining what each step does

Instead of following manual documentation, you simply **describe what you want installed and configured**, and the AI generates the exact commands.

---

## Tips for Best Results

1. **Be specific** - Mention your OS, existing software, and desired configuration
2. **Ask for scripts** - Request "bash script" or "commands" for copy-paste execution
3. **Request verification** - Ask it to include verification steps
4. **Iterate** - If something fails, copy the error and ask Gemini to fix it

---

## Example Workflow

```bash
# 1. Ask for installation
gemini "Install Suricata on Ubuntu with Wazuh integration"

# 2. Copy and run the commands it provides

# 3. If errors occur:
gemini "I got this error: [paste error]. How do I fix it?"

# 4. Verify:
gemini "How do I verify Suricata is running and logging properly?"
```

---

**Note:** The anombyte93/auto-installer repository mentioned was not found on GitHub. This approach uses Gemini CLI as a conversational auto-installer instead, which provides similar functionality through AI-guided installation and configuration.
