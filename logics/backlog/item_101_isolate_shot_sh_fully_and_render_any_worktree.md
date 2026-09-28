## item_101_isolate_shot_sh_fully_and_render_any_worktree - Isolate shot.sh fully and render any worktree
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Tooling
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 13:32:20

# AI Context
- Summary: Isolate shot.sh fully and render any worktree. shot.sh starts mango without -c, so with HOME=/home/corvus it runs the owner's full autostart inside the nested session, including `qs -c archeotech ipc call dashboard openAuto` which selects by config name and can...
- Keywords: isolate, shot, fully, render, any, worktree
- Use when: Implementing or reviewing the 0.30 Safety net milestone work on tooling.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- shot.sh starts mango without -c, so with HOME=/home/corvus it runs the owner's full autostart inside the nested session, including `qs -c archeotech ipc call dashboard openAuto` which selects by config name and can reach the live shell.
- The nested shell reads and writes the real ~/.config/archeotech and ~/.local/share/archeotech; logs use fixed /tmp paths that collide between parallel runs; it cannot render a git worktree because -c archeotech follows the symlink to the main checkout.
- Evidence: audit-tooling.md; audit session reproduced it; .claude/audits/2026-09-28/render-matrix.sh is the working fake-HOME prototype.

# Scope
- In:
  - Fake HOME per run (config/state/cache copied or generated), private XDG_RUNTIME_DIR, env -i, a minimal generated mango config passed with -c, per-run temp dir for logs
  - --root <dir> flag rendering any checkout or worktree via qs -p
  - --theme/--pack/--mode/--flat flags writing the fake theme.json/config.json (port of render-matrix.sh)
- Out:
  - Golden image diffing (separate item)

# Acceptance criteria
- AC1: Running shot.sh leaves every file under the real ~/.config/archeotech and ~/.local/share/archeotech unmodified (mtime check) and spawns no process outside the nested session.
- AC2: shot.sh --root <worktree> renders that worktree's code.
- AC3: Two shot.sh runs in parallel both succeed.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: Running shot.sh leaves every file under the real ~/.config/archeotech and ~/.local/share/archeotech unmodified (mtime check) and spawns no process outside the nested session.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_032_isolate_shot_sh_fully_and_render_any_worktree`

# Priority
- Priority: High
- Rationale: every later verification depends on a render tool that cannot touch the live session (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
- `task_032_isolate_shot_sh_fully_and_render_any_worktree`

# Notes
- Task `task_032_isolate_shot_sh_fully_and_render_any_worktree` was finished via `logics-manager flow finish task` on 2026-09-28.
