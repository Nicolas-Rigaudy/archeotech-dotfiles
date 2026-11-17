## item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx - Tracked user-tool updater: npm globals, Claude Code, Codex, cdx, rtk, uv, pipx
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-11-17 10:45:55

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

# Notes
- 2026-11-16: first slice landed. update-dev-tools.sh and its service/timer are tracked (scripts/, config/.config/systemd/user/) and linked/enabled by install.sh; the untracked copies are now symlinks. The script waits for DNS (github.com, registry.npmjs.org, up to 30 min) and retries each step 3 times, after the 2026-11-16 resume run failed offline. Still open: per-install-method updaters (npm -g, codex, claude update, pipx, uv, rtk, codebase-memory-mcp), per-tool timeouts, update-notify.sh and versions.json.
- 2026-11-16: delivered. One updater per method (native claude update; npm logics-manager + codex, installed when missing; cdx self-update + `cdx update all`; every pipx venv; every uv tool; rtk release binary checked against checksums.txt, old kept as rtk.prev; codebase-memory-mcp versioned dirs, newest two kept). Each tool runs alone under `timeout` (10 min, 3 attempts), records to versions.json, and failures go to one `tool-failed` notice + exit 1. Proof: `tests/test-update-dev-tools.sh` (23 checks: forced claude failure leaves the 7 others ok, timeout killed and reported, versions.json has every tool); real service run 18:39-18:42 recorded 10 tools ok (codex installed 0.169.0, cbm 0.11.0 -> 0.12.1, uv/pipx/uv-tool upgrades); timer active. The cbm installer appended `fish_add_path` to the tracked config.fish: the updater now runs it with the target dir on PATH and strips its marker block. Docs: `docs/UPDATES.md`.
- Task `task_082_orchestrate_automatic_updates` was finished via `logics-manager flow finish task` on 2026-11-17.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# Tasks
- `task_082_orchestrate_automatic_updates`
