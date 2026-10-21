## task_061_unified_motion_presets_with_reduced_motion_and_animation_scale - Unified motion presets with reduced motion and animation scale
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: unified, motion, presets, reduced, animation, scale
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_114_unified_motion_presets_with_reduced_motion_and_animation_scale`

# Acceptance criteria
- AC1: No literal easing or duration outside Commons.
- AC2: Reduced motion disables non-essential animation shell-wide.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_061_unified_motion_presets_with_reduced_motion_and_animation_scale.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_061_unified_motion_presets_with_reduced_motion_and_animation_scale.md` after implementation.

# Validation
- command: `tests/run.sh` (77 pass, incl. new tst_motionlogic.qml), `python3 -m unittest discover tests/py`, `scripts/token-lint.py` (0, now also flags literal duration/easing outside Commons), qmllint-ci unchanged; headless renders of Settings > Appearance (new rows) and the wifi popup with animScale 0 + reduced motion | result: passed | date: 2026-10-21
- Finish workflow executed on 2026-10-21.
- Linked backlog/request close verification passed.

# Report
- Landed b079787 + 69fc1a6 on shell branch night/roadmap-next. New: Commons/MotionLogic.js (clamp, effects vs spatial scaling), Commons/Tween.qml (named ease-out preset, spatial flag), Commons/Spin.qml (unscaled busy spinner), Appearance.animScale/reducedMotion driven from shell.qml, Settings > Appearance rows "Animation speed" (Off/Quick/Normal/Slow) and "Reduce motion", both in the settings search index and ConfigDefaults. All 46 hand-set NumberAnimation sites and 7 spinner copies now use the presets; tokens `tick`, `hold`, `spin`, `easingLinear` added; media marquee stops under reduced motion. token-lint enforces AC1. Reduced motion = spatial tokens (panel, spatial*, enter, exit, tick) and Tween{spatial:true} go instant, fades keep their duration. Spinners and the display-confirm countdown stay on (state indicators). Decision worth review: the Quick/Slow multipliers (0.5/1.5) and that reduce-motion keeps fades.
- Finished on 2026-10-21.
- Linked backlog item(s): `item_114_unified_motion_presets_with_reduced_motion_and_animation_scale`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
