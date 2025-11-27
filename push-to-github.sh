#!/bin/bash

# SwiftFirebaseStarter - GitHub Push Helper Script
#
# Usage:
#   1. Create a new repository on GitHub.com named "SwiftFirebaseStarter"
#   2. Replace YOUR-USERNAME below with your GitHub username
#   3. Run: chmod +x push-to-github.sh
#   4. Run: ./push-to-github.sh

# Configuration
GITHUB_USERNAME="YOUR-USERNAME"  # ← CHANGE THIS to your GitHub username
REPO_NAME="SwiftFirebaseStarter"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}SwiftFirebaseStarter - GitHub Push Helper${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Check if username was changed
if [ "$GITHUB_USERNAME" = "YOUR-USERNAME" ]; then
    echo -e "${YELLOW}⚠️  Please edit this script and replace YOUR-USERNAME with your GitHub username${NC}"
    echo ""
    echo "Edit line 11 in push-to-github.sh:"
    echo "  GITHUB_USERNAME=\"your-actual-username\""
    echo ""
    exit 1
fi

# Check if git is initialized
if [ ! -d .git ]; then
    echo -e "${YELLOW}Initializing git repository...${NC}"
    git init
    git add .
    git commit -m "Initial commit: SwiftFirebaseStarter iOS Boilerplate"
fi

# Check if remote already exists
if git remote get-url origin &> /dev/null; then
    echo -e "${YELLOW}Remote 'origin' already exists. Removing it...${NC}"
    git remote remove origin
fi

# Add remote
echo -e "${GREEN}✓ Adding GitHub remote${NC}"
git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

# Ensure we're on main branch
echo -e "${GREEN}✓ Setting main branch${NC}"
git branch -M main

# Push to GitHub
echo ""
echo -e "${BLUE}Pushing to GitHub...${NC}"
echo -e "${YELLOW}You may be prompted for your GitHub credentials${NC}"
echo ""

git push -u origin main

# Check if push was successful
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}✅ Successfully pushed to GitHub!${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo -e "${BLUE}Your repository is now available at:${NC}"
    echo -e "${GREEN}https://github.com/${GITHUB_USERNAME}/${REPO_NAME}${NC}"
    echo ""
    echo -e "${BLUE}Next steps:${NC}"
    echo "  1. Visit your repository on GitHub"
    echo "  2. Add topics: ios, swift, swiftui, firebase, mvvm, boilerplate"
    echo "  3. Enable 'Use this template' in repository settings"
    echo "  4. Star the repository ⭐"
    echo ""
else
    echo ""
    echo -e "${YELLOW}⚠️  Push failed. Common issues:${NC}"
    echo ""
    echo "1. Repository doesn't exist on GitHub"
    echo "   → Create it at: https://github.com/new"
    echo ""
    echo "2. Authentication failed"
    echo "   → Use GitHub personal access token instead of password"
    echo "   → Generate at: https://github.com/settings/tokens"
    echo ""
    echo "3. Repository name mismatch"
    echo "   → Ensure repository is named: ${REPO_NAME}"
    echo ""
fi
