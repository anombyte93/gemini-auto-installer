#!/bin/bash

# Instructions to push this repository to GitHub

echo "=== GitHub Repository Setup ==="
echo ""
echo "Step 1: Create the repository on GitHub"
echo "  - Go to: https://github.com/new"
echo "  - Repository name: gemini-auto-installer"
echo "  - Description: AI-powered auto-installer using Google Gemini CLI"
echo "  - Visibility: PUBLIC"
echo "  - Do NOT initialize with README, .gitignore, or license"
echo "  - Click 'Create repository'"
echo ""
echo "Step 2: After creating, run ONE of these commands:"
echo ""
echo "=== OPTION A: HTTPS (recommended) ==="
read -p "Enter your GitHub username: " USERNAME
echo ""
echo "Run these commands:"
echo "git remote add origin https://github.com/$USERNAME/gemini-auto-installer.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
echo "=== OPTION B: SSH (if you have SSH keys set up) ==="
echo "git remote add origin git@github.com:$USERNAME/gemini-auto-installer.git"
echo "git branch -M main"
echo "git push -u origin main"
echo ""
echo "=== Quick command (paste your username below) ==="
echo ""

if [ -n "$USERNAME" ]; then
    echo "Copy and run this:"
    echo ""
    echo "git remote add origin https://github.com/$USERNAME/gemini-auto-installer.git && git branch -M main && git push -u origin main"
fi
