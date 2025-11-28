#!/bin/bash

################################################################################
# SESSION START SCRIPT
# Displays project status and prepares for work session
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$PROJECT_ROOT/.claude"

clear

echo -e "${MAGENTA}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║        🚀  ARCH + HYPRLAND DOTFILES PROJECT  🚀              ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}📅 $(date '+%A, %B %d, %Y - %H:%M')${NC}"
echo ""

# Check git status
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
    UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l)
    
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}📦 Git Status${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "Branch: ${GREEN}$BRANCH${NC}"
    
    if [ "$UNCOMMITTED" -gt 0 ]; then
        echo -e "Uncommitted changes: ${YELLOW}$UNCOMMITTED files${NC}"
        echo ""
        git status --short
    else
        echo -e "Status: ${GREEN}✓ Clean working tree${NC}"
    fi
    echo ""
else
    echo -e "${YELLOW}⚠️  Not in a git repository${NC}"
    echo ""
fi

# Display last session summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📝 Last Session${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

SESSIONS_DIR="$CLAUDE_DIR/sessions"
if [ -d "$SESSIONS_DIR" ]; then
    LAST_SESSION=$(ls -t "$SESSIONS_DIR"/*.md 2>/dev/null | head -1)
    if [ -n "$LAST_SESSION" ]; then
        SESSION_DATE=$(basename "$LAST_SESSION" | cut -d'-' -f1-3)
        SESSION_GOAL=$(grep "^\*\*Goal:\*\*" "$LAST_SESSION" | sed 's/\*\*Goal:\*\* //')
        
        echo -e "Date: ${CYAN}$SESSION_DATE${NC}"
        echo -e "Goal: ${CYAN}$SESSION_GOAL${NC}"
        echo ""
        echo "Next session goals from last time:"
        grep "^- \[ \]" "$LAST_SESSION" 2>/dev/null | head -5 | sed 's/^/  /' || echo "  (none specified)"
    else
        echo "No previous sessions found."
    fi
else
    echo "No session history yet."
fi
echo ""

# System status
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🖥️  System Status${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if on Arch
if [ -f /etc/arch-release ]; then
    KERNEL=$(uname -r)
    UPTIME=$(uptime -p | sed 's/up //')
    PACKAGES=$(pacman -Qq | wc -l)
    
    echo -e "OS: ${GREEN}Arch Linux${NC}"
    echo -e "Kernel: ${GREEN}$KERNEL${NC}"
    echo -e "Uptime: ${GREEN}$UPTIME${NC}"
    echo -e "Packages: ${GREEN}$PACKAGES${NC}"
    
    # Check if Hyprland is running
    if pgrep -x Hyprland > /dev/null; then
        HYPRLAND_VERSION=$(hyprland --version 2>/dev/null | head -1 || echo "unknown")
        echo -e "Hyprland: ${GREEN}✓ Running${NC} ($HYPRLAND_VERSION)"
    else
        echo -e "Hyprland: ${YELLOW}Not running${NC}"
    fi
else
    echo -e "${YELLOW}Not running on Arch Linux${NC}"
fi
echo ""

# Quick health checks
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔍 Quick Health Checks${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check audio
if pactl list sinks short 2>/dev/null | grep -v "auto_null" > /dev/null; then
    echo -e "Audio: ${GREEN}✓ Working${NC}"
else
    echo -e "Audio: ${RED}✗ Issue detected${NC}"
fi

# Check network
if ping -c 1 archlinux.org > /dev/null 2>&1; then
    echo -e "Network: ${GREEN}✓ Connected${NC}"
else
    echo -e "Network: ${YELLOW}⚠ Check connection${NC}"
fi

# Check configs exist
ESSENTIAL_CONFIGS=(
    "$HOME/.config/hypr/hyprland.conf"
    "$HOME/.config/waybar/config"
    "$HOME/.config/kitty/kitty.conf"
)

MISSING_CONFIGS=0
for config in "${ESSENTIAL_CONFIGS[@]}"; do
    if [ ! -f "$config" ]; then
        ((MISSING_CONFIGS++))
    fi
done

if [ $MISSING_CONFIGS -eq 0 ]; then
    echo -e "Configs: ${GREEN}✓ All present${NC}"
else
    echo -e "Configs: ${YELLOW}⚠ $MISSING_CONFIGS missing${NC}"
fi

echo ""

# Display current project priorities
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🎯 Current Priorities${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ -f "$CLAUDE_DIR/claude.md" ]; then
    echo "From project documentation:"
    echo ""
    sed -n '/## Next Steps & Priorities/,/###/p' "$CLAUDE_DIR/claude.md" | \
        grep "^1\. " | head -3 | sed 's/^/  /'
else
    echo "  (See .claude/claude.md for full priorities)"
fi

echo ""

# Prompt for session goal
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Ready to start working!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
read -p "What's your goal for this session? " SESSION_GOAL

if [ -n "$SESSION_GOAL" ]; then
    echo "$SESSION_GOAL" > "$CLAUDE_DIR/.current-session-goal"
    echo ""
    echo -e "${GREEN}✓ Session goal set: $SESSION_GOAL${NC}"
    echo ""
    echo -e "Remember to run ${YELLOW}./scripts/session-finish.sh${NC} when done!"
fi

echo ""
