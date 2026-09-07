## item_016_launcher_keyboard_first_master_search - Launcher keyboard-first master search
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: High
> Theme: Launcher
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-07 11:46:10

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: launcher, keyboard, first, master, search
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Launcher search field doesn't auto-focus on open; launcher only launches apps, not actions/tools

# Scope
- In:
  - Auto-focus/forceActiveFocus + keyboard grab on open; master search across apps/windows/settings/wallpaper-theme/power/calc/convert; pluggable provider list
- Out:
  - Web-search backend implementation

# Acceptance criteria
- AC2: Launcher auto-focuses on open and searches apps + actions via pluggable providers, Enter runs the top result

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: Launcher auto-focuses on open and searches apps + actions via pluggable providers, Enter runs the top result
- request-AC3 -> This backlog slice. Proof: AC2: Launcher auto-focuses on open and searches apps + actions via pluggable providers, Enter runs the top result

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — keyboard-first focus in Launcher (delivered); remaining: master-search providers (settings/wallpaper/power/calc). Keep Ready.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_023_launcher_keyboard_first_master_search`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Tasks
- `task_023_launcher_keyboard_first_master_search`

# Notes
- Task `task_023_launcher_keyboard_first_master_search` was finished via `logics-manager flow finish task` on 2026-09-07.
