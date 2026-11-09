## req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools - Automatic updates: system packages, AUR, npm globals and user tools
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Complexity: Medium
> Theme: Machine upkeep
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-11-09 17:44:32

# AI Context
- Summary: Two-tier update plan for the Arch laptop. User tools in ~/.local update daily and unattended. pacman and AUR go through arch-update (AUR, owner choice 2026-11-09): its user timer checks without root and notifies, its tray icon in the bar opens it in kitty, and a run shows the Arch news, upgrades with paru, then offers pacnew, service restart and reboot steps. Nothing applies system updates or reboots unattended.
- Keywords: pacman, paru, aur, npm, cdx, rtk, claude code, codex, systemd timer, arch news, snapper, snap-pac, notify-send, arch-update
- Use when: building or changing update timers, the arch-update setup, the update notifier or the versions state file.
- Skip when: reading changelogs or proposing changes from new tool releases (cr-0w req_045).

# Needs
- The owner updates the machine by hand and too often. Updates run on a schedule and the owner acts only when something needs them.
- Covered: pacman, AUR (paru), npm globals (@grifhinz/logics-manager, Codex CLI), Claude Code, cdx, rtk, and the other user tools in ~/.local (uv tools, pipx venvs, codebase-memory-mcp).
- Safety: Arch news is checked before any pacman -Syu, a snapshot exists before every system upgrade with a written rollback path, and a kernel upgrade never reboots the machine on its own.
- One desktop notification when something needs the owner: news to read, system upgrade ready, reboot needed, a tool update failed. Nothing when all is fine.
- crow (cr-0w req_045) reads installed versions and changelogs. Installing and upgrading live in this repo.

# Context
- Today: ~/.local/bin/update-dev-tools.sh with update-dev-tools.timer (daily, Persistent, 30 min jitter) runs `cdx update all --yes` and `logics-manager update`. Neither file is in git.
- `cdx update all` is an inventory plus a workstation plan: on 2026-11-09 it reported claude and rtk as UNKNOWN (latest unavailable) and codex as MISSING, and changed nothing. cdx itself (pipx venv cdx-manager, cdx 0.26.11) is not upgraded by that call.
- Install methods found: logics-manager via npm -g with prefix ~/.local; Claude Code via its native installer (~/.local/share/claude/versions, built-in auto-updater); rtk 0.35.0 as a bare binary in ~/.local/bin (April 2026); cdx, code-review-graph, uv via pipx; ast-grep, graphify via uv tool; codebase-memory-mcp as a versioned dir; Codex CLI not installed.
- System: paru (no yay), linux 7.2 only (no fallback kernel), snapper timeline + cleanup timers, snap-pac pre/post snapshots on every pacman transaction, grub-btrfs boot entries, pacman-contrib (checkupdates, pacdiff, paccache) installed. No system update check runs today.
- Decision (this request): two tiers. User tools in ~/.local need no root and update unattended on a daily user timer. System packages (pacman + AUR) are never applied unattended: a no-root check notifies, and the owner applies the upgrade from one interactive tool that walks the safety steps. Unattended -Syu breaks on news-flagged manual interventions and pacnew merges, and a kernel swap leaves the running kernel without modules until reboot.
- Decision (owner, 2026-11-09): the system tier is arch-update (AUR, github.com/Antiz96/arch-update), not a custom `sysup` script. It follows the Arch wiki System maintenance steps: Arch news published since the last run shown before the upgrade prompt, full upgrade with paru, then orphans, package cache, pacnew/pacsave, services to restart and a pending kernel reboot, each offered and never forced. Its check (`arch-update --check --enable`, a user timer at boot then every 6 h) runs checkupdates on a temporary db and writes ~/.local/state/arch-update/last_updates_check_{packages,aur,flatpak}.
- Decision: cadence is systemd user timers with Persistent=true for the user-tool job, so a missed run catches up at the next login or resume. No login hook. The system nudge is arch-update's own check and notification.
- Decision: notifications go to the shell's notification server. arch-update sends its own (updates available, with a run action) and shows a tray icon in the shell's TrayWidget. Mango runs no XDG autostart, so the tray starts from a mango exec_once line, and xdg-terminal-exec with kitty makes a tray click open kitty. The user-tool job uses notify-send. A bar widget reading arch-update's state is a later archeotech-shell item, out of scope here.
- Personal repo, private machine config (road_002). Scripts in scripts/, units in config/.config/systemd/user/, linked by install.sh.

# Acceptance criteria
- AC1: The user-tool updater and its timer are tracked in this repo, installed by install.sh, and update logics-manager, Codex CLI, Claude Code, cdx, rtk, uv tools and pipx venvs; one tool failing does not stop the others.
- AC2: arch-update's check timer records pending pacman and AUR updates without root and without touching /var/lib/pacman/sync, and its tray icon shows them in the bar.
- AC3: An arch-update run shows the Arch news published since the last run before asking to upgrade, upgrades pacman and AUR packages with paru (snap-pac takes the pre/post snapshot), then offers pacnew/pacsave handling, service restarts and the pending kernel reboot. Nothing reboots without the owner's yes.
- AC4: The owner gets a notification only when something needs them: system updates available (arch-update) or a tool update failed (user-tool job, at most once a day). None when nothing is due.
- AC5: A runbook covers the policy, the daily flow (user-tool job, arch-update) and rolling back a bad upgrade from a snapper snapshot via grub-btrfs. An ADR records the two-tier decision, and docs/TOOLS.md and docs/PACKAGES.md are updated.
- AC6: Installed versions are written to a state file that crow (cr-0w req_045) can read without running any updater.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): (none yet)

# References
- cr-0w logics/request/req_045_periodic_tool_update_watch.md (reads versions and changelogs only; installing belongs here)
- ~/.local/bin/update-dev-tools.sh and ~/.config/systemd/user/update-dev-tools.{service,timer} (untracked, daily, 2026-11 state)
- scripts/setup-snapper.sh (snapper + snap-pac + grub-btrfs)
- scripts/install.sh (stow, ~/.local/bin links)
- config/.config/systemd/user/battery-alert.service (tracked user unit pattern)
- docs/PACKAGES.md, docs/TOOLS.md
- https://archlinux.org/feeds/news/ (Arch news RSS)
- https://wiki.archlinux.org/title/System_maintenance (partial upgrades, pacnew, reading news before -Syu)
- https://github.com/Antiz96/arch-update (README, arch-update(1), arch-update.conf(5))

# Backlog
- `item_171_update_notifier_and_state_file_shared_by_all_update_jobs`
- `item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx`
- `item_173_daily_system_update_check_with_arch_news_gate`
- `item_174_sysup_guarded_system_upgrade_command`
- `item_175_update_policy_adr_rollback_runbook_and_docs`

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
