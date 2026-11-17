## task_082_orchestrate_automatic_updates - Orchestrate automatic updates
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-11-17 10:45:54
> Owner: claude

# AI Context
- Summary: Delivers req_013 in four waves: notifier, user-tool updater, arch-update setup, docs. item_174 (sysup) is obsolete. The first real arch-update run is the owner's.
- Keywords: orchestrate, automatic, updates
- Use when: picking the next automatic-updates wave or checking its order.
- Skip when: crow's changelog watch (cr-0w req_045).

# Context
- Orchestrate the scaffolded request chain and keep sibling implementation slices linked.

# Plan
- [x] 1. Notifier and state file (everything else calls it).
- [x] 2. Tracked user-tool updater (replaces the untracked daily job; quick win, no root).
- [x] 3. arch-update setup (owner installs it with paru; tracked config, check timer, tray via mango exec_once, kitty via xdg-terminal-exec).
- [x] 4. sysup guarded upgrade: dropped 2026-11-09, arch-update covers it (item_174 Obsolete).
- [x] 5. ADR, rollback runbook and docs (written against the shipped scripts and the arch-update config).
- [x] 6. Validate each wave on the real machine with dry-run flags first; the first real arch-update run is done by the owner.
- [x] ADR 009 checkpoint: update affected Logics docs during each meaningful wave and leave the repo commit-ready.
- [x] Keep commit creation under operator control; do not force one commit per micro-step.
- [x] GATE: do not close until lint, audit, and scaffold validation pass.

# Backlog
- `item_171_update_notifier_and_state_file_shared_by_all_update_jobs`
- `item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx`
- `item_173_daily_system_update_check_with_arch_news_gate`
- `item_174_sysup_guarded_system_upgrade_command`
- `item_175_update_policy_adr_rollback_runbook_and_docs`

# Definition of Done (DoD)
- [x] Generated request, product, backlog, and task docs are present.
- [x] Context-pack handoff is available when requested.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# AC Traceability
- request-AC1 -> This task. Proof: item_172 (562e274): tracked update-dev-tools.sh + service/timer linked and enabled by install.sh; tests/test-update-dev-tools.sh (forced claude failure leaves the other tools ok); real run recorded 10 tools ok.
- request-AC2 -> This task. Proof: item_173 (d273cf9): arch-update --check state matched checkupdates (20 pkgs) with /var/lib/pacman/sync untouched; tray icon on the bar (owner-verified 2026-11-09).
- request-AC3 -> This task. Proof: item_173: owner's first full arch-update run 2026-11-09 (news, -Syu, paru AUR builds, orphans, pacdiff, reboot prompt), snap-pac pre/post pairs 2851-2860.
- request-AC4 -> This task. Proof: item_171 (35da7db, 693741d): update-notify.sh one notice per kind per day, owner saw a real critical notice; item_173: arch-update notification with a run action opening kitty.
- request-AC5 -> This task. Proof: item_175: adr_036, docs/UPDATES.md runbook (policy, daily flow, arch-update run, rollback, missing modules), docs/TOOLS.md and docs/PACKAGES.md; snapshot listing, snapper status and grub-btrfs entries checked read-only 2026-11-17.
- request-AC6 -> This task. Proof: item_171 + item_172: ~/.local/state/archeotech-updates/versions.json schema 1 with 10 tools, documented in docs/UPDATES.md; cr-0w req_045 points at it.

# Validation
- (no validation recorded yet)
- bash tests/test-update-dev-tools.sh passed on 2026-11-11 (23 checks); logics-manager audit adr_036 clean and snapper/grub-btrfs read-only checks passed on 2026-11-17
- Finish workflow executed on 2026-11-17.
- Linked backlog/request close verification passed.

# Report
- 2026-11-09 item_173 wave (d273cf9): arch-update installed; tracked arch-update.conf (AURHelper=paru, KeepOldPackages=2, NoFlatpak) + xdg-terminals.list (kitty); install.sh enables arch-update.timer; mango exec_once starts the tray. Verified: check state matches checkupdates (20 pkgs), sync db untouched, timer every 6 h. Pending owner: tray on live bar, click opens kitty, first real run + snapper pre/post pair.
- 2026-11-09 item_173 verified by the owner: tray icon on the bar, click opens arch-update in kitty, first full run done (news, -Syu, paru AUR builds, orphan removal, pacdiff: mirrorlist + locale.gen kept, fortran.conf + 2 tpm2 profiles replaced). snapper pre/post pairs 2851-2860 cover every pacman transaction; 0 pacnew left. Fixes: tray waits for the StatusNotifierWatcher (27a9468); a tray started from a Claude Code ! shell inherits the sandbox HOME, so kitty loses its theme (TROUBLESHOOTING, 02e7dbe).
- 2026-11-16 item_172 slice: update-dev-tools.sh + service/timer tracked and linked by install.sh, DNS wait (5 min) + 3 retries per tool, real start passed (b47b448). item_172 still needs per-method updaters, update-notify.sh, versions.json.
- 2026-11-16 item_171 Done (35da7db): scripts/update-notify.sh (kind + message, one notice per kind per day in notified.json, --dry-run prints and writes nothing) and scripts/update-state.sh (versions.json record/forget/show, atomic + locked; last_update moves only on a version change), both linked by install.sh. Format for crow in docs/UPDATES.md. Validated: tests/test-update-scripts.sh 15/15 (AC4 same kind suppressed, other kind sends; AC6 valid JSON, one entry per tool), shellcheck clean, real-machine --dry-run. item_172 now calls these.
- 2026-11-16 wrap: wave 1 (item_171) done and owner-verified with a real notice (693741d). Next: item_172 per-method updaters calling update-notify.sh tool-failed and update-state.sh record. Test kinds test/test-failed sit in the real notified.json (harmless).
- Finished on 2026-11-17.
- Linked backlog item(s): `item_171_update_notifier_and_state_file_shared_by_all_update_jobs`, `item_172_tracked_user_tool_updater_npm_globals_claude_code_codex_cdx_rtk_uv_pipx`, `item_173_daily_system_update_check_with_arch_news_gate`, `item_174_sysup_guarded_system_upgrade_command`, `item_175_update_policy_adr_rollback_runbook_and_docs`
- Related request(s): `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`

- 2026-11-17 item_175 Done: adr_036 + docs/UPDATES.md runbook + TOOLS/PACKAGES; cr-0w req_045 points at versions.json. All five items settled (174 Obsolete).

# Links
- Request: `req_013_automatic_updates_system_packages_aur_npm_globals_and_user_tools`
- Product brief(s): `prod_006_automatic_machine_updates`
- Architecture decision(s): `adr_036_two_tier_machine_updates_unattended_user_tools_owner_run_arch_update`

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

# Notes
- update-dev-tools: kept the daily Persistent timer + a 30 min DNS wait instead of a NetworkManager dispatcher hook (owner, 2026-11-16): connect events fire many times a day and need root; 30 min covers Wi-Fi setup on a train.
- Failure kinds (*-failed) are sent critical: red border, stays until dismissed; other kinds normal (owner, 2026-11-16, after a real test notice).
