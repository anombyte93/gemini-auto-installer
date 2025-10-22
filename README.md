# Gemini Auto-Installer

AI-powered auto-installer using Google Gemini CLI for automated software installation and configuration.

## 🚀 Quick Start

### 1. Install Gemini CLI

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/gemini-auto-installer/main/install-gemini-cli.sh | bash
source ~/.bashrc
```

**OR clone and run locally:**

```bash
git clone https://github.com/YOUR_USERNAME/gemini-auto-installer.git
cd gemini-auto-installer
chmod +x install-gemini-cli.sh
./install-gemini-cli.sh
source ~/.bashrc
```

### 2. Use AI to Install Software

Simply describe what you want installed:

```bash
gemini "Install Suricata IDS on this Ubuntu system that has a Wazuh agent already installed. Configure Suricata to log network traffic to /var/log/suricata/ and integrate it with the Wazuh agent by configuring the ossec.conf file to monitor Suricata's eve.json logs. Enable all ET Open rulesets and configure network interface monitoring. Show me the exact commands to run."
```

The AI generates installation commands → You copy-paste and execute → Done!

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
