# Open Codex Auto-Installer for Students

**AI-powered code CLI that helps you install and configure software through simple prompts.**

Use Open Codex with Google Gemini AI to automatically install Suricata, Wazuh, Docker, and other tools by just describing what you need.

**✅ Supports:** Linux (Ubuntu/Debian/RHEL/Fedora), macOS, WSL
**⚙️ Requires:** Node.js v22+

---

## 📖 For Students: What is This?

This tool installs **Open Codex CLI** with **Google Gemini** on your system, which acts as your AI-powered coding assistant. Instead of following complex installation guides, you simply tell the AI what you want installed, and it generates the exact commands for you, with the ability to execute them interactively.

### 🎓 Student Mode (NEW!)

**Perfect for students who don't understand AI or feel lost using command-line tools!**

Student Mode provides:
- **📖 Documentation-First Approach** - MANDATORY checks for official docs before using AI
- **📚 Interactive Tutorials** - Learn how to use AI assistants step-by-step
- **🎯 Guided Prompts** - Pre-built templates that teach good prompting
- **💡 Educational Explanations** - Understand WHAT you're doing and WHY
- **🔒 Safety Warnings** - Learn which commands are safe and which need caution
- **🛠️ Common Tasks Menu** - Quick access to frequent operations with explanations
- **✅ Verification Prompts** - Ensures you check official docs before proceeding
- **📖 Plain Language** - No confusing jargon, everything explained simply

**Example with Student Mode:**
- You: Run `student-codex` and select "Install Software"
- System: **"Have you checked the official documentation? (y/n)"** ← MANDATORY CHECK
- You: Check docs first, then confirm
- System: Asks you step-by-step questions (What? Which OS? Any special needs?)
- System: Shows you the AI prompt it will create and explains WHY it's good
- System: Warns you what to look out for in the AI response
- AI: Gives you commands with explanations
- You: Verify against docs, learn and understand before executing
- Done (and you learned something safely!)

---

## 🚀 Quick Start for Students

### Step 1: Download the Installer Script

Download this repository to your system:

**For Linux/macOS:**
```bash
# Clone with git
git clone https://github.com/anombyte93/gemini-auto-installer.git
cd gemini-auto-installer
```

**For Windows users:**
```bash
# Use WSL (Windows Subsystem for Linux)
# Open Ubuntu/Debian WSL terminal and run:
git clone https://github.com/anombyte93/gemini-auto-installer.git
cd gemini-auto-installer
```

**No git installed?**
- Go to: https://github.com/anombyte93/gemini-auto-installer
- Click "Code" → "Download ZIP"
- Extract and open terminal in that folder

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
- **Detect your operating system** (Linux/macOS)
- **Check Node.js version** (requires v22+):
  - If Node.js is not installed or too old, it will automatically install/upgrade to v22
  - **Linux:** via apt (Ubuntu/Debian) or yum (RHEL/Fedora)
  - **macOS:** via Homebrew (installs Homebrew first if needed)
- Install **Open Codex CLI** globally
- **Prompt you for your Gemini API key** - paste it when asked
- Save your API key securely as `GOOGLE_GENERATIVE_AI_API_KEY`:
  - **Linux/WSL:** ~/.bashrc
  - **macOS:** ~/.zshrc or ~/.bash_profile
- Create Open Codex configuration at `~/.codex/config.json`
- Test the installation

### Step 4: Activate the Installation

Reload your terminal configuration:

**Linux/WSL:**
```bash
source ~/.bashrc
```

**macOS:**
```bash
source ~/.zshrc
# OR if using bash:
source ~/.bash_profile
```

Or simply close and reopen your terminal.

### Step 5: Test It Works

**For Students (Recommended):**
```bash
student-codex
```
This launches Student Mode with guided menus and tutorials.

**For Advanced Users:**
```bash
open-codex "Hello, are you working?"
```

If you get a response from Gemini, you're ready to go!

---

## 🎓 Using Student Mode

### First Time? Start Here!

1. **Launch Student Mode:**
   ```bash
   student-codex
   ```

2. **Complete the Tutorial (Highly Recommended):**
   - Select option `1` from the menu
   - Learn how to write good prompts
   - Understand how to evaluate AI responses
   - **Learn the mandatory documentation-first rule**
   - Practice safe learning habits

3. **Try a Guided Task:**
   - Select option `2` for guided software installation
   - The system will check if you've read the docs FIRST
   - It will help you build a good AI prompt step-by-step
   - You'll learn WHY each part of the prompt matters

### Student Mode Features

#### 📖 Tutorial Mode (Option 1)
Interactive lessons covering:
- What is Open Codex and how does it work?
- How to write effective prompts
- **Why you MUST check documentation first** ⚠️
- How to evaluate AI responses safely
- Safe learning practices

#### 🔧 Guided Install (Option 2)
**Documentation check required!**
- Ensures you've read official docs first
- Asks step-by-step questions
- Builds optimal prompts with explanations
- Shows safety warnings
- Teaches you good prompting habits

#### ⚙️ Guided Configure (Option 3)
**Documentation check required!**
- Ensures you understand configuration options
- Guides you through building configuration prompts
- Explains config file safety (backups, syntax, etc.)
- Helps you verify changes worked

#### 🐛 Guided Troubleshooting (Option 4)
Step-by-step error resolution:
- Helps you describe the problem clearly
- Teaches you how to read error messages
- Shows you how to ask AI for help
- Emphasizes understanding the root cause

#### 📝 Custom Prompt Builder (Option 5)
Interactive prompt enhancement:
- Helps you build better prompts
- Adds explanations, safety checks, verification steps
- Teaches you what makes a good prompt
- Shows before/after comparison

#### 🎯 Quick Tasks (Option 6)
Common operations with explanations:
- Check service status
- View logs
- Monitor resources
- Update packages
- Each with educational context

### Documentation-First Rule ⚠️

Student Mode **enforces** checking official documentation before using AI:

**Why This Matters:**
- Official docs are the source of truth
- AI can make mistakes or provide outdated info
- You learn the recommended/official way first
- You can verify AI suggestions against docs
- You understand the context better

**How It Works:**
1. Choose a task (Install, Configure, etc.)
2. System asks: "Have you checked the official documentation?"
3. If NO → System explains why docs are important and sends you back
4. If YES → System helps you build an AI prompt to complement the docs

**Example:**
```
You: Select "Install Software" → Choose "Docker"
System: "Have you checked Docker's official installation docs? (y/n)"
You: n
System: "Please check https://docs.docker.com/engine/install/ first!
        This ensures you understand Docker's requirements and
        recommended installation method. Come back after reading!"
        [Returns to menu]

You: [Reads docs, comes back]
You: Select "Install Software" → Choose "Docker"
System: "Have you checked Docker's official installation docs? (y/n)"
You: y
System: "Great! Now let's use AI to help with the installation..."
```

---

## 🎯 How to Use Open Codex as Your Auto-Installer

### Usage Modes

**Interactive Mode:**
```bash
open-codex
```
Starts an interactive session where you can have a conversation with the AI.

**Direct Prompting:**
```bash
open-codex "Your prompt here"
```
Send a one-off prompt and get a response.

**With Specific Provider:**
```bash
open-codex --provider gemini "Your prompt here"
```

### Example 1: Install Suricata with Wazuh Integration

This is the main use case for cybersecurity students:

```bash
open-codex "Install Suricata IDS on this Ubuntu system that has a Wazuh agent already installed. Configure Suricata to log network traffic to /var/log/suricata/ and integrate it with the Wazuh agent by configuring the ossec.conf file to monitor Suricata's eve.json logs. Enable all ET Open rulesets and configure network interface monitoring. Show me the exact commands to run."
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
open-codex "Install Docker on Ubuntu 22.04 and add my current user to the docker group so I can run docker without sudo. Show me the commands."
```

### Example 3: Configure Suricata Performance

```bash
open-codex "Configure Suricata to use 4 CPU threads and enable all protocol analyzers. Show me what to edit in suricata.yaml"
```

### Example 4: Troubleshoot Errors

If something goes wrong:

```bash
open-codex "I got this error when starting Suricata: [paste your error here]. How do I fix it?"
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
open-codex "Install Suricata IDS on Ubuntu 22.04. Configure it to monitor eth0 interface. Enable EVE JSON logging to /var/log/suricata/eve.json. Download and enable Emerging Threats Open ruleset. Start the service and verify it's running. Give me the complete commands."
```

### Task 2: Integrating Suricata with Wazuh

**Prompt:**
```bash
open-codex "I have Suricata installed and logging to /var/log/suricata/eve.json. I have Wazuh agent installed. Configure the Wazuh agent to read Suricata logs and send them to the Wazuh manager. Show me what to add to ossec.conf and how to restart the agent."
```

### Task 3: Creating Custom Suricata Rules

**Prompt:**
```bash
open-codex "Create a Suricata rule that detects SSH brute force attempts (more than 5 connections per minute from the same IP). Explain the rule syntax and tell me where to save it."
```

### Task 4: Verifying Everything Works

**Prompt:**
```bash
open-codex "How do I verify that Suricata is running, capturing traffic, and that Wazuh is receiving the alerts? Give me the commands to check logs and service status."
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

### Problem: "open-codex: command not found"

**Solution:**
```bash
source ~/.bashrc
# Or close and reopen your terminal
```

### Problem: "API key invalid" or "401 Unauthorized"

**Solution:** Get your own key from [Google AI Studio](https://aistudio.google.com/app/apikey) and update your `~/.bashrc`:
```bash
nano ~/.bashrc
# Find and update the line:
export GOOGLE_GENERATIVE_AI_API_KEY="YOUR_NEW_KEY_HERE"
# Save and reload:
source ~/.bashrc
```

### Problem: "Node.js version too old" or "Requires Node.js v22+"

**Solution:**
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version  # Should be v22.x or higher
```

### Problem: Script fails with "Permission denied"

**Solution:**
```bash
chmod +x install-gemini-cli.sh
./install-gemini-cli.sh
```

### Problem: "sudo: command not found" or password required

**Solution:**
- **Linux:** Run the script on a system where you have sudo privileges. The script needs to install Node.js system-wide.
- **macOS:** You'll be prompted for your password when Homebrew needs admin access.

### Problem: "brew: command not found" (macOS only)

**Solution:** The script will install Homebrew automatically. Just follow the prompts and enter your password when asked.

### Problem: Installation hangs on macOS

**Solution:** Press Enter if the Homebrew installation is waiting for confirmation. The script may pause for user input during Homebrew installation.

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

1. **Ask Open Codex for help:** `open-codex "I'm stuck with [your problem]"`
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

1. **Automated Open Codex Installation** - One-command setup for Open Codex CLI with Google Gemini
2. **Node.js v22+ Auto-Install** - Automatically installs or upgrades Node.js to meet requirements
3. **API Key Configuration** - Prompts for and securely stores your Gemini API key
4. **Student Instructions** - Simple guide for using AI as a coding assistant and auto-installer
5. **Example Prompts** - Tested prompts for common installation and configuration tasks

---

## 🎯 Use Cases

### Install Suricata with Wazuh Integration

```bash
open-codex "Install Suricata IDS on this Ubuntu system that has a Wazuh agent already installed. Configure Suricata to log network traffic to /var/log/suricata/ and integrate it with the Wazuh agent by configuring the ossec.conf file to monitor Suricata's eve.json logs. Enable all ET Open rulesets and configure network interface monitoring. Show me the exact commands to run."
```

### Install Docker

```bash
open-codex "Install Docker on Ubuntu and add my user to the docker group. Show me the commands."
```

### Configure Services

```bash
open-codex "Configure Suricata to use 4 CPU threads and enable all protocol analyzers"
```

### Troubleshoot Issues

```bash
open-codex "Suricata service failed to start with error: [paste error]. Fix the configuration."
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

1. **Install Script** checks/installs Node.js v22+ and Open Codex CLI
2. **Configure** prompts for and saves your Gemini API key
3. **Create Config** sets up `~/.codex/config.json` with Gemini as the provider
4. **Prompt** the AI with natural language descriptions of what you want
5. **Interactive Execution** Open Codex can execute commands with your approval
6. **Iterate** if errors occur, paste them back to the AI for fixes

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

- [Open Codex Documentation](https://github.com/google-gemini/open-codex)
- [Google Gemini API Documentation](https://ai.google.dev/gemini-api/docs)
- [Google AI Studio](https://aistudio.google.com/)
- [Node.js Downloads](https://nodejs.org/)
- [Suricata Documentation](https://suricata.io/docs/)
- [Wazuh Documentation](https://documentation.wazuh.com/)

---

## ❓ Troubleshooting

### "open-codex: command not found"

```bash
source ~/.bashrc
# OR
npm install -g open-codex
```

### "API key invalid"

Get your own at [Google AI Studio](https://aistudio.google.com/app/apikey) and update `~/.bashrc`:
```bash
export GOOGLE_GENERATIVE_AI_API_KEY="YOUR_KEY_HERE"
```

### "Node.js version too old" or "Requires v22+"

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

---

**Made for cybersecurity education and system administration training.**
