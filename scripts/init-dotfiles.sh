#!/bin/bash

################################################################################
# DOTFILES INITIALIZATION SCRIPT
# Sets up the dotfiles repository structure and prepares for Claude Code
################################################################################

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Dotfiles Repository Initialization${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Default location
DOTFILES_DIR="$HOME/Projects/dotfiles"

# Ask for custom location
read -p "Dotfiles directory location [$DOTFILES_DIR]: " CUSTOM_DIR
if [ -n "$CUSTOM_DIR" ]; then
    DOTFILES_DIR="$CUSTOM_DIR"
fi

echo ""
echo -e "${YELLOW}Creating dotfiles repository at: $DOTFILES_DIR${NC}"
echo ""

# Create directory structure
mkdir -p "$DOTFILES_DIR"/{.claude/sessions,scripts,themes,docs,assets/wallpapers}

echo -e "${GREEN}✓${NC} Created directory structure"

# Create .gitignore
cat > "$DOTFILES_DIR/.gitignore" << 'EOF'
# Temporary files
*.swp
*.swo
*~
.DS_Store

# Secrets (never commit these!)
.env
*.key
*.pem
.aws/credentials
.ssh/id_*
.ssh/*.key

# Session-specific
.current-session-goal
.last-packages

# Backup files
*.backup
*.bak
*.old

# Logs
*.log

# OS-specific
Thumbs.db
desktop.ini
EOF

echo -e "${GREEN}✓${NC} Created .gitignore"

# Make scripts executable
chmod +x "$DOTFILES_DIR"/scripts/*.sh
echo -e "${GREEN}✓${NC} Made scripts executable"

# Create README if it doesn't exist
if [ ! -f "$DOTFILES_DIR/README.md" ]; then
    cat > "$DOTFILES_DIR/README.md" << 'EOF'
# Dotfiles - Arch + Hyprland

Personal dotfiles for Arch Linux + Hyprland desktop environment.

**Theme:** Catppuccin Macchiato with Mauve accent

## Quick Start

See `.claude/README.md` for detailed setup instructions.

## Structure

- `.claude/` - Claude Code project files
- `scripts/` - Automation scripts
- `themes/` - Theme configurations
- `docs/` - Documentation

## Installation

Coming soon: `./scripts/install.sh`

## Managed with Claude Code

This repository is designed to work with Claude Code for assisted development and maintenance.
EOF
fi

echo -e "${GREEN}✓${NC} Created project README"

# Initialize git if not already
cd "$DOTFILES_DIR"
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✓${NC} Initialized git repository"
    
    # Create initial commit
    git add .
    git commit -m "Initial commit: Claude Code project setup

- Added comprehensive project documentation
- Set up directory structure
- Included session management scripts
- Ready for Claude Code integration"
    
    echo -e "${GREEN}✓${NC} Created initial commit"
else
    echo -e "${YELLOW}⚠️${NC}  Git repository already exists"
fi

# Create placeholder files for future structure
touch "$DOTFILES_DIR/docs/INSTALLATION.md"
touch "$DOTFILES_DIR/docs/KEYBINDS.md"
touch "$DOTFILES_DIR/docs/PACKAGES.md"
touch "$DOTFILES_DIR/scripts/backup.sh"
touch "$DOTFILES_DIR/scripts/install.sh"
touch "$DOTFILES_DIR/scripts/restore.sh"

echo -e "${GREEN}✓${NC} Created placeholder files"

# Summary
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Initialization Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📁 Dotfiles repository: ${YELLOW}$DOTFILES_DIR${NC}"
echo ""
echo "Next steps:"
echo ""
echo "1. ${YELLOW}cd $DOTFILES_DIR${NC}"
echo "2. ${YELLOW}claude code .${NC}"
echo "3. Tell Claude: ${YELLOW}\"Read .claude/claude.md to understand this project.\"${NC}"
echo ""
echo "Or start your first session:"
echo "${YELLOW}./scripts/session-start.sh${NC}"
echo ""
echo -e "${GREEN}Ready to build amazing dotfiles!${NC} 🚀"
echo ""
