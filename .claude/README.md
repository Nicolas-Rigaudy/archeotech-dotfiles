# Claude Code Project Setup - Quick Start Guide

This directory contains everything Claude Code needs to maintain context and work effectively on your Arch + Hyprland dotfiles project.

---

## 📁 Directory Structure

```
.claude/
├── claude.md                    # Main project knowledge base (START HERE)
├── DECISIONS.md                 # Log of all technical decisions
├── TROUBLESHOOTING.md          # Known issues and solutions
├── session-summary-template.md # Template for session summaries
└── sessions/                    # Past session summaries
    └── 2025-11-28-initial-installation.md

scripts/
├── session-start.sh            # Run at start of each session
└── session-finish.sh           # Run at end of each session
```

---

## 🚀 Quick Start

### 1. Set Up Dotfiles Repository

```bash
# Create dotfiles directory
mkdir -p ~/Projects/dotfiles

# Copy these files to it
cp -r .claude ~/Projects/dotfiles/
cp -r scripts ~/Projects/dotfiles/

# Initialize git
cd ~/Projects/dotfiles
git init
git add .
git commit -m "Initial commit: Claude Code project setup"

# Make scripts executable
chmod +x scripts/*.sh
```

### 2. Open in Claude Code

```bash
cd ~/Projects/dotfiles
claude code .
```

### 3. Tell Claude Code

On first open, tell Claude:

> "Read `.claude/claude.md` to understand this project. This is an Arch + Hyprland dotfiles project. The system is already fully installed and working. Review the current status and help me with [what you want to do]."

---

## 📖 How to Use This Setup

### Starting a Work Session

**Option 1: Manual**
```bash
./scripts/session-start.sh
```
This displays:
- Git status
- Last session summary
- System health checks
- Current priorities

**Option 2: Just tell Claude Code**
> "Start a new session. My goal today is [goal]."

Claude will review the project status and prepare to work.

---

### During Your Session

**Claude Code will:**
- Remember all project context from `claude.md`
- Reference past decisions from `DECISIONS.md`
- Check troubleshooting guide when issues arise
- Update files as it makes changes
- Keep track of what's been done

**You should:**
- Tell Claude your specific goal for the session
- Let Claude explore and make changes
- Review changes before committing
- Update `claude.md` status sections when completing major tasks

---

### Ending a Work Session

**Option 1: Automated**
```bash
./scripts/session-finish.sh
```

This will:
- Prompt you for session details
- List changed files
- Document issues and decisions
- Create session summary
- Offer to commit changes
- Update `claude.md` timestamp

**Option 2: Tell Claude Code**
> "End session. Create a summary of what we did."

Claude will create a session summary in `.claude/sessions/`.

---

## 📝 Important Files Explained

### `claude.md` (Main Knowledge Base)
- **Purpose:** Single source of truth for project
- **Contains:**
  - System specifications
  - Current status (what's done, what's not)
  - All technical decisions
  - Workflow context
  - Common tasks
  - Known issues
- **When to update:** After completing major features or making significant changes
- **How to update:** Edit the "Current Implementation Status" section, move tasks from "Not Done" to "Done"

### `DECISIONS.md` (Decision Log)
- **Purpose:** Track why technical choices were made
- **When to update:** When making any significant technical decision
- **Format:** Context → Options → Decision → Rationale
- **Why it matters:** Future you (or others) will thank you for documenting the "why"

### `TROUBLESHOOTING.md` (Issue Database)
- **Purpose:** Document solutions to problems
- **When to update:** After solving any issue that took more than 10 minutes
- **Format:** Symptoms → Cause → Solution → Prevention
- **Why it matters:** Don't solve the same problem twice

### `sessions/` (Session Summaries)
- **Purpose:** Track progress over time
- **When to create:** End of each work session
- **Format:** Follow the template in `session-summary-template.md`
- **Why it matters:** See project evolution, remember what you did

---

## 🎯 Common Tasks with Claude Code

### Task: Add New Feature
```
You: "I want to add a custom rofi script for switching AWS profiles."

Claude: [Reads claude.md for context]
Claude: [Checks if similar script exists]
Claude: [Creates script with proper structure]
Claude: [Tests script]
Claude: [Updates documentation]
Claude: [Prompts you to test]
```

### Task: Fix an Issue
```
You: "My audio stopped working after an update."

Claude: [Checks TROUBLESHOOTING.md for known audio issues]
Claude: [If found, provides solution]
Claude: [If not found, debugs and documents new solution]
Claude: [Updates TROUBLESHOOTING.md with findings]
```

### Task: Understand a Decision
```
You: "Why did we choose paru over yay?"

Claude: [Reads DECISIONS.md]
Claude: [Explains rationale: Rust-based, faster, better UI]
Claude: [Provides context from decision entry]
```

### Task: Review Project Status
```
You: "What's left to do on this project?"

Claude: [Reads "Not Yet Done" section in claude.md]
Claude: [Prioritizes tasks based on current status]
Claude: [Suggests next steps]
```

---

## 🔧 Maintaining Context

### Keep `claude.md` Updated

**After completing a task:**
```markdown
# In claude.md, move from "Not Done" to "Done":

### ❌ NOT YET DONE
- [ ] Custom rofi AWS script  ← Remove this

### ✅ COMPLETED
- [x] Custom rofi AWS script  ← Add this
```

**Update "Last Updated" date:**
```markdown
**Last Updated:** 2025-11-29  ← Change this
```

### Log Important Decisions

When making a choice between alternatives:

1. Copy decision template from `DECISIONS.md`
2. Fill in: Context, Options, Decision, Rationale
3. Append to `DECISIONS.md`

Example:
```markdown
## [2025-11-29] AWS Profile Switcher Implementation

**Context:** Need quick way to switch between AWS profiles

**Options Considered:**
1. Shell function in fish config
2. Rofi script with dmenu
3. Waybar module with click action

**Decision:** Rofi script

**Rationale:** Most flexible, can show profile details, integrates with existing launcher workflow
```

### Document Issues Solved

When you fix something that wasn't in troubleshooting guide:

1. Add to `TROUBLESHOOTING.md` under appropriate section
2. Include: Symptoms, Cause, Solution, Prevention
3. Use template format for consistency

---

## 💡 Tips for Working with Claude Code

### Maximize Context Awareness

**Do this:**
✅ "Read claude.md and help me with X"
✅ "Check TROUBLESHOOTING.md for similar issues"
✅ "Review my last session and continue from there"
✅ "What decisions were made about theme switching?"

**Not this:**
❌ "Make me a theme switcher" (without context)
❌ "Fix my audio" (without checking docs first)

### Iterative Development

**Workflow:**
1. Tell Claude your goal
2. Let Claude read relevant docs
3. Claude proposes solution
4. You review and test
5. Claude updates documentation
6. Commit changes

**Example:**
```
You: "Add a scratchpad terminal feature. Check what Hyprland supports."

Claude: [Reads Hyprland wiki/docs]
Claude: [Reviews current hyprland.conf]
Claude: [Proposes keybind and workspace config]
Claude: [Waits for your approval]

You: "Looks good, implement it"

Claude: [Updates hyprland.conf]
Claude: [Tests configuration syntax]
Claude: [Updates claude.md with new keybind]
Claude: [Adds to keybindings reference]
```

### Session Management

**Best Practice:**
- Start each session by stating your goal
- End each session with a summary
- Review previous session before starting new one
- Keep sessions focused (1-3 related tasks)

**Session Flow:**
```
1. Start: "./scripts/session-start.sh" or tell Claude
2. Work: Focused on specific goal
3. Test: Verify changes work
4. Document: Update relevant files
5. End: "./scripts/session-finish.sh" or tell Claude
6. Commit: Git commit with meaningful message
```

---

## 🎨 Customizing This Setup

### Add Your Own Scripts

Place scripts in `scripts/` directory:
```bash
scripts/
├── session-start.sh
├── session-finish.sh
├── backup-configs.sh      ← Your script
└── deploy-to-machine.sh   ← Your script
```

Update `claude.md` to reference new scripts.

### Add Custom Documentation

Create new markdown files in `.claude/`:
```bash
.claude/
├── claude.md
├── DECISIONS.md
├── TROUBLESHOOTING.md
├── KEYBINDS.md           ← Add this
└── PACKAGES.md           ← Add this
```

Reference them in `claude.md` under relevant sections.

### Extend Session Scripts

Modify `session-finish.sh` to:
- Auto-generate changelog
- Update package list
- Create backup
- Push to remote repository
- Send notification

---

## 🔍 Finding Information

### "Where is X documented?"

**System specifications:** `claude.md` → "System Specifications"
**What's done/not done:** `claude.md` → "Current Implementation Status"
**Why we chose X:** `DECISIONS.md` → Search for decision title
**How to fix Y:** `TROUBLESHOOTING.md` → Find relevant section
**What we did last time:** `.claude/sessions/` → Latest file
**How to do Z:** `claude.md` → "Common Tasks & How-To"

### "How do I..."

**...see project status?**
- Read `claude.md` "Current Implementation Status"
- Or ask Claude: "What's the current project status?"

**...understand a past decision?**
- Read `DECISIONS.md`
- Or ask Claude: "Why did we choose [thing]?"

**...fix a recurring issue?**
- Check `TROUBLESHOOTING.md`
- Or ask Claude: "Check troubleshooting guide for [issue]"

**...see what changed recently?**
- Read latest file in `.claude/sessions/`
- Or check git log

---

## 🚨 Important Reminders

### For You
- **Always backup before major changes** (configs are precious)
- **Test incrementally** (small changes, test, continue)
- **Document as you go** (don't wait until end of session)
- **Keep Fedora bootable** (safety net during experimentation)
- **Review Claude's changes** (you're in control, Claude assists)

### For Claude Code
- **Read claude.md first** (always understand project context)
- **Check existing solutions** (TROUBLESHOOTING.md, past sessions)
- **Document decisions** (update DECISIONS.md when choosing between options)
- **Update status** (move completed tasks in claude.md)
- **Test before declaring done** (verify changes work)
- **Explain what and why** (help user understand changes)

---

## 📊 Success Metrics

**This setup is working well if:**
- ✅ Claude Code understands project context without extensive explanation
- ✅ You can resume work after weeks away (session summaries help)
- ✅ Issues are solved once and documented (not re-solved)
- ✅ Decisions are clear and justified (DECISIONS.md has rationale)
- ✅ Project progresses incrementally (small commits, regular sessions)
- ✅ No "why did we do this?" moments (everything documented)

---

## 🎓 Learning Resources

**For Claude Code Features:**
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Using Project Files](https://docs.anthropic.com/claude-code/project-files)

**For This Project:**
- Start with `claude.md` (comprehensive overview)
- Review `DECISIONS.md` (understand reasoning)
- Read session summaries (see evolution)
- Check `TROUBLESHOOTING.md` (learn from issues)

---

## 🔄 Workflow Summary

```
┌─────────────────────────────────────────────────┐
│ 1. Start Session (./scripts/session-start.sh)  │
│    - Reviews project status                      │
│    - Shows last session goals                    │
│    - Sets current session goal                   │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│ 2. Work with Claude Code                        │
│    - Claude reads claude.md for context         │
│    - You specify what to work on                │
│    - Claude proposes solutions                   │
│    - You review and approve                      │
│    - Changes are made and tested                 │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│ 3. Document Changes                             │
│    - Update claude.md (move tasks to done)      │
│    - Add to DECISIONS.md (if decision made)     │
│    - Add to TROUBLESHOOTING.md (if issue solved)│
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│ 4. End Session (./scripts/session-finish.sh)   │
│    - Creates session summary                     │
│    - Lists changes made                          │
│    - Documents decisions and issues              │
│    - Commits to git                              │
│    - Updates claude.md timestamp                 │
└─────────────────────────────────────────────────┘
```

---

## 🎉 You're Ready!

**Next steps:**
1. Copy these files to `~/Projects/dotfiles`
2. Initialize git repository
3. Open in Claude Code
4. Start first session

**First session goals:**
- Let Claude read and understand the project
- Create dotfiles repository structure  
- Write backup script
- Begin documentation

**Have fun building!** 🚀

---

**Created:** 2025-11-28
**For:** Arch + Hyprland Dotfiles Project
**By:** AI-assisted project setup for Claude Code
