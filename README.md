# Gemini Auto-Installer for Students

**AI-powered auto-installer that installs and configures software through simple prompts.**

Use Google Gemini AI to automatically install Suricata, Wazuh, Docker, and other tools by just describing what you need.

---

## 📖 For Students: What is This?

This tool installs **Google Gemini CLI** on your Linux system, which acts as your AI installation assistant. Instead of following complex installation guides, you simply tell the AI what you want installed, and it generates the exact commands for you.

**Example:**
- You say: *"Install Suricata on my Ubuntu system with Wazuh integration"*
- AI gives you: Ready-to-run installation commands
- You: Copy, paste, and execute
- Done!

---

## 🚀 Quick Start for Students

### Step 1: Download the Installer Script

Download this repository to your system:

```bash
# Option A: Download as ZIP (if no git)
# Go to: https://github.com/anombyte93/gemini-auto-installer
# Click "Code" → "Download ZIP"
# Extract and open terminal in that folder

# Option B: Clone with git
git clone https://github.com/anombyte93/gemini-auto-installer.git
cd gemini-auto-installer
```

### Step 2: Get Your FREE Google Gemini API Key

Before running the installer, get your API key:

1. Go to: https://aistudio.google.com/app/apikey
2. Sign in with your Google account (it's free!)
3. Click **"Create API key"**
4. Copy the key (starts with "AIza...")
5. Keep it ready - you'll need it in the next step

### Step 3: Run the Installation Script

Make the script executable and run it:

```bash
chmod +x install-gemini-cli.sh
./install-gemini-cli.sh
```

The script will:
- Install Node.js (required for Gemini CLI)
- Install Google Gemini CLI globally
- **Prompt you for your API key** - paste it when asked
- Save your API key securely to ~/.bashrc
- Test the installation

### Step 4: Activate the Installation

Reload your terminal configuration:

```bash
source ~/.bashrc
```

Or simply close and reopen your terminal.

### Step 5: Test It Works

Try this command:

```bash
gemini "Hello, are you working?"
```

If you get a response from Gemini, you're ready to go!

---

## 🎯 How to Use Gemini CLI as Your Auto-Installer

### Example 1: Install Suricata with Wazuh Integration

This is the main use case for cybersecurity students:

```bash
gemini "Install Suricata IDS on this Ubuntu system that has a Wazuh agent already installed. Configure Suricata to log network traffic to /var/log/suricata/ and integrate it with the Wazuh agent by configuring the ossec.conf file to monitor Suricata's eve.json logs. Enable all ET Open rulesets and configure network interface monitoring. Show me the exact commands to run."
```

**What happens:**
1. Gemini analyzes your request
2. Generates installation commands for Ubuntu
3. Provides configuration steps
4. Shows integration commands for Wazuh

**You then:**
1. Read the commands to understand what they do
2. Copy and paste them into your terminal
3. Execute them one by one (or as a script)

### Example 2: Install Docker

```bash
gemini "Install Docker on Ubuntu 22.04 and add my current user to the docker group so I can run docker without sudo. Show me the commands."
```

### Example 3: Configure Suricata Performance

```bash
gemini "Configure Suricata to use 4 CPU threads and enable all protocol analyzers. Show me what to edit in suricata.yaml"
```

### Example 4: Troubleshoot Errors

If something goes wrong:

```bash
gemini "I got this error when starting Suricata: [paste your error here]. How do I fix it?"
```

---

## 💡 Tips for Getting Good Results

### ✅ DO:
- **Be specific** - Mention your OS version (Ubuntu 22.04, etc.)
- **Mention existing software** - "I already have Wazuh agent installed"
- **Ask for commands** - "Show me the exact commands to run"
- **Request explanations** - "Explain what each command does"

### ❌ DON'T:
- Be too vague - "Install security stuff"
- Forget to mention your environment
- Skip reading the commands before running them

---

## 🛠️ Common Tasks for Cybersecurity Students

### Task 1: Installing Suricata IDS

**Prompt:**
```bash
gemini "Install Suricata IDS on Ubuntu 22.04. Configure it to monitor eth0 interface. Enable EVE JSON logging to /var/log/suricata/eve.json. Download and enable Emerging Threats Open ruleset. Start the service and verify it's running. Give me the complete commands."
```

### Task 2: Integrating Suricata with Wazuh

**Prompt:**
```bash
gemini "I have Suricata installed and logging to /var/log/suricata/eve.json. I have Wazuh agent installed. Configure the Wazuh agent to read Suricata logs and send them to the Wazuh manager. Show me what to add to ossec.conf and how to restart the agent."
```

### Task 3: Creating Custom Suricata Rules

**Prompt:**
```bash
gemini "Create a Suricata rule that detects SSH brute force attempts (more than 5 connections per minute from the same IP). Explain the rule syntax and tell me where to save it."
```

### Task 4: Verifying Everything Works

**Prompt:**
```bash
gemini "How do I verify that Suricata is running, capturing traffic, and that Wazuh is receiving the alerts? Give me the commands to check logs and service status."
```

---

## 📚 What's in This Repository?

- **`install-gemini-cli.sh`** - The main installation script
- **`STUDENT-INSTRUCTIONS.md`** - Detailed instructions (this guide)
- **`README.md`** - Overview and documentation
- **`PUSH-TO-GITHUB.sh`** - Helper script for publishing (ignore this)

---

## ⚠️ Important Security Notice

**Keep your API key private!**

### Security Best Practices:

- ✅ **DO** use your own API key (get it free from Google AI Studio)
- ✅ **DO** keep your API key private and secure
- ✅ **DO** use the installer script which saves your key to ~/.bashrc (not visible in git)
- ❌ **DON'T** share your API key with anyone
- ❌ **DON'T** commit your API key to git repositories
- ❌ **DON'T** post your API key in screenshots or chat

### If Your API Key is Compromised:

1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Delete the compromised key
3. Create a new API key
4. Update your ~/.bashrc with the new key:
   ```bash
   # Edit the file
   nano ~/.bashrc

   # Find and replace the GOOGLE_API_KEY line
   export GOOGLE_API_KEY="YOUR_NEW_KEY_HERE"

   # Save and reload
   source ~/.bashrc
   ```

---

## 🐛 Troubleshooting

### Problem: "gemini: command not found"

**Solution:**
```bash
source ~/.bashrc
# Or close and reopen your terminal
```

### Problem: "API key invalid" or "401 Unauthorized"

**Solution:** The public API key was revoked. Get your own key from [Google AI Studio](https://aistudio.google.com/app/apikey) and update the script.

### Problem: "Node.js version too old"

**Solution:**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version  # Should be v20.x or higher
```

### Problem: Script fails with "Permission denied"

**Solution:**
```bash
chmod +x install-gemini-cli.sh
./install-gemini-cli.sh
```

### Problem: "sudo: command not found" or password required

**Solution:** Run the script on a system where you have sudo privileges. The script needs to install Node.js system-wide.

---

## 🎓 Learning Objectives

By using this tool, you will learn:

1. **System Administration** - Understanding what commands do before running them
2. **Security Tool Installation** - Setting up IDS/IPS systems properly
3. **Integration Skills** - Connecting different security tools (Suricata + Wazuh)
4. **Troubleshooting** - Using AI to debug issues
5. **AI-Assisted Development** - Leveraging AI for infrastructure tasks

**Important:** Always read and understand the commands before running them. The AI is a learning assistant, not a replacement for understanding.

---

## 🤝 Need Help?

If you get stuck:

1. **Ask Gemini for help:** `gemini "I'm stuck with [your problem]"`
2. **Check the logs:** Most errors are in `/var/log/`
3. **Ask your instructor:** They can help debug specific issues

---

## 📄 License

MIT License - Free for educational and commercial use.

---

**Made for cybersecurity students learning IDS/IPS, SIEM integration, and security automation.**

---

## 📋 What This Does

This repository provides:

1. **Automated Gemini CLI Installation** - One-command setup for the Google Gemini CLI
2. **Pre-configured API Key** - Ready to use (with security warnings)
3. **Student Instructions** - Simple guide for using AI as an auto-installer
4. **Example Prompts** - Tested prompts for common installation tasks

---

## 🎯 Use Cases

### Install Suricata with Wazuh Integration

```bash
gemini "Install Suricata IDS on this Ubuntu system that has a Wazuh agent already installed. Configure Suricata to log network traffic to /var/log/suricata/ and integrate it with the Wazuh agent by configuring the ossec.conf file to monitor Suricata's eve.json logs. Enable all ET Open rulesets and configure network interface monitoring. Show me the exact commands to run."
```

### Install Docker

```bash
gemini "Install Docker on Ubuntu and add my user to the docker group. Show me the commands."
```

### Configure Services

```bash
gemini "Configure Suricata to use 4 CPU threads and enable all protocol analyzers"
```

### Troubleshoot Issues

```bash
gemini "Suricata service failed to start with error: [paste error]. Fix the configuration."
```

---

## 📚 Files in This Repository

- **`install-gemini-cli.sh`** - Automated installation script for Gemini CLI
- **`STUDENT-INSTRUCTIONS.md`** - Detailed guide for students
- **`README.md`** - This file

---

## ⚠️ Security Warning

**The included API key is publicly exposed and may be revoked at any time.**

### Get Your Own API Key:

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API key"
4. Replace the key in `install-gemini-cli.sh` with your own

### Best Practices:

- ✅ Use environment variables for API keys
- ✅ Never commit API keys to public repositories
- ✅ Rotate keys regularly
- ❌ Don't share API keys in screenshots or documentation

---

## 🛠️ How It Works

1. **Install Script** installs Node.js and Gemini CLI
2. **Configure** sets up the Google API key automatically
3. **Prompt** the AI with natural language descriptions of what you want installed
4. **Execute** the commands the AI generates
5. **Iterate** if errors occur, paste them back to the AI for fixes

---

## 🎓 For Educators

This tool is designed for cybersecurity and IT courses where students need to:

- Install and configure IDS/IPS systems (Suricata, Snort)
- Integrate security tools (Wazuh, OSSEC, Elastic Stack)
- Learn system administration through AI assistance
- Practice infrastructure-as-code concepts

Students learn by:
1. Describing requirements in natural language
2. Reviewing AI-generated commands
3. Understanding what each command does
4. Troubleshooting with AI assistance

---

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

---

## 📄 License

MIT License - Feel free to use in educational and commercial projects.

---

## 🔗 Links

- [Google Gemini CLI Documentation](https://ai.google.dev/gemini-api/docs)
- [Google AI Studio](https://aistudio.google.com/)
- [Suricata Documentation](https://suricata.io/docs/)
- [Wazuh Documentation](https://documentation.wazuh.com/)

---

## ❓ Troubleshooting

### "gemini: command not found"

```bash
source ~/.bashrc
# OR
npm install -g @google/generative-ai-cli
```

### "API key invalid"

The public API key may have been revoked. Get your own at [Google AI Studio](https://aistudio.google.com/app/apikey).

### "Node.js version too old"

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

---

**Made for cybersecurity education and system administration training.**
