## task_065_palette_crossfade_on_theme_apply - Palette crossfade on theme apply
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
- Keywords: palette, crossfade, theme, apply
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_009_palette_crossfade_on_theme_apply`

# Acceptance criteria
- AC5: Applying a theme crossfades the palette instead of snapping

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_065_palette_crossfade_on_theme_apply.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_065_palette_crossfade_on_theme_apply.md` after implementation.

# Validation
- command: tests/run.sh (85 pass, new tst_palettelogic.qml), qmllint-ci unchanged, theme-fidelity 0; harness render mid-fade (cr-0w/local/state/night/shots/009-crossfade/mid-fade.png shows base/accent/surface blended between old and new) and a full-shell latte dashboard | result: passed; the live feel of a real theme switch was not watched (owner to eyeball) | date: 2026-10-21
- Finish workflow executed on 2026-10-21.
- Linked backlog/request close verification passed.

# Report
- Landed 90dc5c7 on shell branch night/roadmap-next. Appearance._c is the one colour source, so it now returns blend(_prevData, _data, _mix) while a 300ms OutCubic NumberAnimation (anim.effectsSlow, scaled by the animation-speed setting) runs; the snapshot is taken from _c itself so an interrupting switch starts from the blended colours, and the accent follows the accent role so a new accent name fades too. Pack colours, first load, scale 0 and unchanged themes snap. Maths in Commons/PaletteLogic.js. Cost: base-colour bindings re-evaluate per frame for 300ms after a switch.
- Finished on 2026-10-21.
- Linked backlog item(s): `item_009_palette_crossfade_on_theme_apply`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
