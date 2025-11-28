#!/bin/bash

################################################################################
# SESSION FINISH SCRIPT
# Automates end-of-session tasks: summary generation, status updates, git commit
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$PROJECT_ROOT/.claude"
SESSIONS_DIR="$CLAUDE_DIR/sessions"

# Ensure sessions directory exists
mkdir -p "$SESSIONS_DIR"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  SESSION FINISH - Dotfiles Project${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Generate session filename
SESSION_DATE=$(date +%Y-%m-%d)
SESSION_TIME=$(date +%H-%M)
SESSION_FILE="$SESSIONS_DIR/$SESSION_DATE-session-$SESSION_TIME.md"

echo -e "${YELLOW}Creating session summary: $(basename "$SESSION_FILE")${NC}"
echo ""

# Prompt for session details
read -p "Session goal (what did you work on?): " SESSION_GOAL
read -p "Session duration (e.g., 2 hours): " SESSION_DURATION

echo ""
echo -e "${GREEN}Gathering session information...${NC}"

# Get list of modified files
MODIFIED_FILES=$(git status --porcelain 2>/dev/null || echo "Not in git repo")

# Get list of new packages (if tracking)
if [ -f "$CLAUDE_DIR/.last-packages" ]; then
    NEW_PACKAGES=$(comm -13 <(sort "$CLAUDE_DIR/.last-packages") <(pacman -Qe | awk '{print $1}' | sort) 2>/dev/null || echo "")
else
    NEW_PACKAGES=""
fi

# Save current package list for next session
pacman -Qe | awk '{print $1}' > "$CLAUDE_DIR/.last-packages" 2>/dev/null || true

# Create session summary from template
cat > "$SESSION_FILE" << EOF
# Session Summary

**Date:** $SESSION_DATE
**Time:** $SESSION_TIME
**Duration:** $SESSION_DURATION
**Goal:** $SESSION_GOAL

---

## What Was Done

### Major Changes
EOF

echo ""
echo -e "${YELLOW}Describe major changes (one per line, empty line to finish):${NC}"
while IFS= read -r line; do
    [ -z "$line" ] && break
    echo "- $line" >> "$SESSION_FILE"
done

cat >> "$SESSION_FILE" << EOF

### Files Modified
\`\`\`
$MODIFIED_FILES
\`\`\`

EOF

if [ -n "$NEW_PACKAGES" ]; then
    cat >> "$SESSION_FILE" << EOF
### Packages Installed
\`\`\`bash
$NEW_PACKAGES
\`\`\`

EOF
fi

cat >> "$SESSION_FILE" << EOF
---

## Issues Encountered

EOF

echo ""
read -p "Were there any issues? (y/n): " HAD_ISSUES
if [[ $HAD_ISSUES == "y" || $HAD_ISSUES == "Y" ]]; then
    echo -e "${YELLOW}Describe each issue (title then enter, description, empty line when done):${NC}"
    ISSUE_NUM=1
    while true; do
        read -p "Issue $ISSUE_NUM title (or empty to finish): " ISSUE_TITLE
        [ -z "$ISSUE_TITLE" ] && break
        
        echo "### Issue $ISSUE_NUM: $ISSUE_TITLE" >> "$SESSION_FILE"
        echo "**Symptoms:** " >> "$SESSION_FILE"
        read -p "Symptoms: " ISSUE_SYMPTOMS
        echo "$ISSUE_SYMPTOMS" >> "$SESSION_FILE"
        echo "" >> "$SESSION_FILE"
        
        echo "**Solution:** " >> "$SESSION_FILE"
        read -p "Solution: " ISSUE_SOLUTION
        echo "$ISSUE_SOLUTION" >> "$SESSION_FILE"
        echo "" >> "$SESSION_FILE"
        
        ISSUE_NUM=$((ISSUE_NUM + 1))
    done
else
    echo "No major issues encountered." >> "$SESSION_FILE"
fi

cat >> "$SESSION_FILE" << EOF

---

## Decisions Made

EOF

read -p "Were any technical decisions made? (y/n): " HAD_DECISIONS
if [[ $HAD_DECISIONS == "y" || $HAD_DECISIONS == "Y" ]]; then
    echo -e "${YELLOW}Describe decisions:${NC}"
    DECISION_NUM=1
    while true; do
        read -p "Decision $DECISION_NUM topic (or empty to finish): " DECISION_TOPIC
        [ -z "$DECISION_TOPIC" ] && break
        
        echo "### Decision $DECISION_NUM: $DECISION_TOPIC" >> "$SESSION_FILE"
        read -p "What was chosen: " DECISION_CHOSEN
        echo "**Chosen:** $DECISION_CHOSEN" >> "$SESSION_FILE"
        read -p "Rationale: " DECISION_RATIONALE
        echo "**Rationale:** $DECISION_RATIONALE" >> "$SESSION_FILE"
        echo "" >> "$SESSION_FILE"
        
        DECISION_NUM=$((DECISION_NUM + 1))
    done
else
    echo "No major decisions made." >> "$SESSION_FILE"
fi

cat >> "$SESSION_FILE" << EOF

---

## Next Session Goals

EOF

echo ""
echo -e "${YELLOW}What should be done next session? (one per line, empty to finish):${NC}"
while IFS= read -r line; do
    [ -z "$line" ] && break
    echo "- [ ] $line" >> "$SESSION_FILE"
done

cat >> "$SESSION_FILE" << EOF

---

## Notes & Observations

EOF

read -p "Any additional notes? (y/n): " HAS_NOTES
if [[ $HAS_NOTES == "y" || $HAS_NOTES == "Y" ]]; then
    echo "Enter notes (Ctrl+D when done):"
    NOTES=$(cat)
    echo "$NOTES" >> "$SESSION_FILE"
else
    echo "None." >> "$SESSION_FILE"
fi

echo ""
echo -e "${GREEN}✓ Session summary created: $SESSION_FILE${NC}"

# Offer to commit changes
echo ""
read -p "Would you like to commit all changes? (y/n): " DO_COMMIT
if [[ $DO_COMMIT == "y" || $DO_COMMIT == "Y" ]]; then
    echo ""
    read -p "Commit message: " COMMIT_MSG
    
    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="Session $SESSION_DATE: $SESSION_GOAL"
    fi
    
    cd "$PROJECT_ROOT"
    git add .
    git commit -m "$COMMIT_MSG"
    
    echo -e "${GREEN}✓ Changes committed${NC}"
    
    read -p "Push to remote? (y/n): " DO_PUSH
    if [[ $DO_PUSH == "y" || $DO_PUSH == "Y" ]]; then
        git push
        echo -e "${GREEN}✓ Pushed to remote${NC}"
    fi
fi

# Update claude.md with current date
sed -i "s/\*\*Last Updated:\*\* .*/\*\*Last Updated:\*\* $SESSION_DATE/" "$CLAUDE_DIR/claude.md"

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Session finished! Summary saved.${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📄 Summary: ${YELLOW}$SESSION_FILE${NC}"
echo -e "📝 Review with: ${YELLOW}cat $SESSION_FILE${NC}"
echo ""
