## item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx - Tracked user-tool updater: npm globals, Claude Code, Codex, cdx, rtk, uv, pipx
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:34:22

# AI Context
- Summary: Moves the untracked daily updater into the repo and gives each install method its own upgrade step: npm -g, Claude Code native, pipx (cdx), rtk release binary, uv tools, codebase-memory-mcp.
- Keywords: tracked, user, tool, updater, npm, globals, claude, code, codex, cdx, rtk, pipx
- Use when: adding a user tool to the daily update or fixing a tool that stays behind.
- Skip when: pacman or AUR packages (item_173, item_174).

# Problem
- The daily updater lives untracked in ~/.local/bin, does not upgrade cdx, rtk or Claude Code (cdx update all only lists them), and Codex CLI is not installed.

# Scope
- In:
  - Move update-dev-tools.sh and its service/timer into scripts/ and config/.config/systemd/user/, linked by install.sh; remove the untracked copies.
  - One updater per install method: npm -g (logics-manager, @openai/codex, installed when missing), Claude Code (`claude update`, with its auto-updater left on), cdx (pipx upgrade cdx-manager, then cdx update all for the workstation plan), rtk (GitHub release binary with checksum, or the method rtk documents), uv tool upgrade --all, pipx upgrade-all, codebase-memory-mcp (versioned dir switch).
  - Each tool runs alone with a timeout; failures call update-notify.sh tool-failed; results go to versions.json.
  - Daily timer kept (Persistent=true, randomized delay).
- Out:
  - pacman and AUR packages.
  - Reading changelogs (crow req_045).

# Acceptance criteria
- AC1: After one run, every followed tool shows its latest version or a recorded failure reason; a forced failure in one tool leaves the others updated.
- AC1: A fresh install.sh run installs the units and the timer is active.
- AC6: versions.json lists each tool after the run.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: After one run, every followed tool shows its latest version or a recorded failure reason; a forced failure in one tool leaves the others updated.
- request-AC6 -> This backlog slice. Proof: AC1: A fresh install.sh run installs the units and the timer is active.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): (none yet)
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Primary task(s): `task_082_orchestrate_automatic_updates`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
