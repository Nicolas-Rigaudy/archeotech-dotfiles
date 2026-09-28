## task_032_isolate_shot_sh_fully_and_render_any_worktree - Isolate shot.sh fully and render any worktree
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-28 13:32:19

# AI Context
- Summary: Make scripts/shot.sh fully isolated (fake HOME, private runtime dir, minimal mango -c config, per-run temp dir) and able to render any checkout via --root, with theme/pack/mode flags.
- Keywords: isolate, shot, fully, render, any, worktree
- Use when: Changing how the shell is rendered headless for verification.
- Skip when: Working on golden diffing (item_068) or hooks (item_102).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_101_isolate_shot_sh_fully_and_render_any_worktree`

# Acceptance criteria
- AC1: Running shot.sh leaves every file under the real ~/.config/archeotech and ~/.local/share/archeotech unmodified (mtime check) and spawns no process outside the nested session.
- AC2: shot.sh --root <worktree> renders that worktree's code.
- AC3: Two shot.sh runs in parallel both succeed.

# Plan
- [x] 1. Fake HOME + private XDG_RUNTIME_DIR + generated minimal mango config (-c) + per-run temp dir for logs; env -i with an explicit allowlist.
- [x] 2. --root <dir> rendering any checkout (qs -p <dir>/shell.qml).
- [x] 3. --theme/--pack/--mode/--flat flags writing the fake theme.json/config.json (port of render-matrix.sh).
- [x] 4. Validate AC1 (mtime + process check), AC2 (worktree render), AC3 (two parallel runs); shellcheck.
- [x] Use `logics-manager flow progress task` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_032_isolate_shot_sh_fully_and_render_any_worktree.md` after implementation.

# Validation
- PASSED 2026-09-28 on archeotech-shell 5d7d626: (AC1) mtime snapshot of every file under ~/.config/archeotech and ~/.local/share/archeotech identical before/after a --state dashboard render, ps diff shows no new user processes; (AC2) git worktree with an edited greeting rendered via --root shows the worktree text while the main checkout is unchanged; (AC3) a --root render and a --theme archeotech-latte render ran in parallel and both produced PNGs; bash -n clean (shellcheck not installed locally).
- command: `scripts/shot.sh isolation checks (mtime diff, ps diff, --root worktree render, parallel runs)` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- shot.sh now runs each render in a private temp dir: fake HOME seeded with copies of the user's archeotech config/state/cache, private XDG_RUNTIME_DIR (no live Wayland/qs-ipc/awww/PipeWire sockets reachable), own D-Bus, generated mango -c config (autostart never runs), env -i allowlist, setsid process group torn down by PGID plus a leftover scan by runtime dir. New flags: --root, --theme, --pack, --flat, --wallpaper, --keep. Launches qs -p <root>/shell.qml so worktrees render. Commit 5d7d626.
- Finished on 2026-09-28.
- Linked backlog item(s): `item_101_isolate_shot_sh_fully_and_render_any_worktree`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof: render-isolation half of AC1 delivered in archeotech-shell 5d7d626 - real ~/.config/archeotech and ~/.local/share/archeotech mtimes unchanged across a render, no new user processes, a git worktree rendered via --root, two parallel runs succeeded; the guard-hook half of AC1 is item_102.
