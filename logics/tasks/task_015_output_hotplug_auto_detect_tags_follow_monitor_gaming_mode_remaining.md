## task_015_output_hotplug_auto_detect_tags_follow_monitor_gaming_mode_remaining - output hotplug auto-detect + tags-follow-monitor + gaming mode (remaining)
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-04 00:31:44

# AI Context
- Summary: The three remaining pieces of item_026 (task_014 delivered the layout picker/keybinds): output-hotplug auto-detect, tags-follow-monitor on undock, and a gaming mode. Delivered as MangoWC helper scripts + one keybind + autostart entry.
- Keywords: output, hotplug, auto, detect, tags, follow, monitor, gaming, mode, remaining
- Use when: Working on MangoWC multi-monitor dock/undock behavior or the blur/shadow/anim performance toggle.
- Skip when: Working on the tiling layout picker (task_014, done) or the full CompositorService facade (out of item_026 scope).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_026_multi_monitor_compositor_utilities`

# Acceptance criteria
- AC4: Monitor layouts, hotplug, tag migration on undock, and a gaming mode are available

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_015_output_hotplug_auto_detect_tags_follow_monitor_gaming_mode_remaining.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_015_output_hotplug_auto_detect_tags_follow_monitor_gaming_mode_remaining.md` after implementation.

# Validation
- Gaming mode: end-to-end round-trip on the live MangoWC 0.16.2 session — `gaming-mode.sh on/off/status/toggle` all exit 0, state file tracks correctly, effects restored from config.conf. Raw `mmsg dispatch setoption,blur,1` returns `{"success":true}`; bogus key handled gracefully (no IPC crash).
- Hotplug daemon: startup + initial-snapshot read verified; `flock` single-instance guard rejects a second instance ("already running, exiting"). Full dock/undock apply path uses the same proven `monitor-apply.sh` logic extracted verbatim from `mango-reload.sh` — final confirmation deferred to the user's next physical dock/undock (only one output active during dev).
- Tags-follow-monitor: confirmed by MangoWC source inspection (v0.16.2) — `closemon()` reparents every client on a removed output to the surviving monitor via `client_set_group_mon(c, selmon)` and records `oldmonname` for restore. Compositor-native; no script needed.
- Syntax: `bash -n` clean on all three scripts (shellcheck unavailable on host).
- Finish workflow executed on 2026-09-04.
- Linked backlog/request close verification passed.

# Report
- Delivered `scripts/monitor-apply.sh` (shared output→layout logic, extracted from `mango-reload.sh`), `scripts/monitor-hotplug.sh` (debounced `mmsg watch all-monitors` daemon, `flock`-guarded, wired into `config.conf` `exec-once`), and `scripts/gaming-mode.sh` (`Super+Ctrl+G`, live `setoption` toggle, config-sourced restore).
- `mango-reload.sh` refactored to call the shared `monitor-apply.sh` (removed duplicated layout block). Registered all three in `install.sh`; symlinked into `~/.local/bin`.
- Tags-follow-monitor required no code — the compositor already migrates clients on undock (source-verified).
- Docs: `KEYBINDS-MANGO.md` (gaming-mode bind) + `TOOLS.md` (Multi-Monitor & Gaming Mode subsection).
- Finished on 2026-09-04.
- Linked backlog item(s): `item_026_multi_monitor_compositor_utilities`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof deferred to slice closeout.
- request-AC2 -> This task. Proof deferred to slice closeout.
- request-AC3 -> This task. Proof deferred to slice closeout.
- request-AC4 -> This task. Proof: hotplug auto-detect (monitor-hotplug.sh daemon), tag migration on undock (compositor closemon, source-verified), and gaming mode (gaming-mode.sh, Super+Ctrl+G) all delivered; monitor layouts via task_014 + monitor-apply.sh.
- request-AC5 -> This task. Proof deferred to slice closeout.
- request-AC6 -> This task. Proof deferred to slice closeout.
