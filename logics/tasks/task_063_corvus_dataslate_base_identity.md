## task_063_corvus_dataslate_base_identity - Corvus Dataslate base identity
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 35%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: corvus, dataslate, base, identity
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_115_corvus_dataslate_base_identity`

# Acceptance criteria
- AC1: Owner signs off on the base contact sheet across all themes, dark and light.

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_063_corvus_dataslate_base_identity.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_063_corvus_dataslate_base_identity.md` after implementation.

# Validation
- command: tests/run.sh (77 pass), unittest tests/py, token-lint 0, theme-fidelity 0; renders: font options A/B/C dashboard + settings, Grimdark dashboard vs before (same diff as live-data noise only), dashboard on all 13 themes (contact sheet) | result: passed, AC1 (owner sign-off) pending | date: 2026-10-21

# Report
- Wave 1 (shell 8d5cf24, branch night/roadmap-next): typography. Three options rendered (A current FiraCode mono, B FiraCode Nerd Font Propo, C Noto Sans): B is near-identical to A, C is the real change. Built C: Appearance.font.family = Noto Sans (UI), new font.mono = FiraCode Nerd Font for data (bar pill readouts, clocks, dashboard gauges/sparkline/bars, project branch+dirty, system-notes values); Grimdark pins its own mono family so its look is unchanged. noto-fonts is already an INSTALL.md dependency. Renders in cr-0w/local/state/night/shots/115-identity/ (font-*.png, contact-sheet-dataslate-dashboard.png, sheet/).
- Not done, needs owner direction: component-scale corner ticks, per-family dark-theme character, how far mono-for-data goes (launcher, settings values, notifications still on the UI face), and sign-off on the contact sheet (AC1). Settings/launcher/bar-wide contact sheets are the next render batch.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
