## item_019_theme_applier_plugins_refactor - Theme-applier plugins refactor
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Theming / plugins
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: theme, applier, plugins, refactor
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- theme-switch.py's applier table is hardcoded; edit-the-Python-per-app coupling

# Scope
- In:
  - Declarative applier manifests (render->write->reload) + script escape-hatch; theme-switch.py becomes a thin discovering runner keeping failure isolation
- Out:
  - v1.0 (skip-if-missing minimum is enough); rides on Sprint 27 install mechanism

# Acceptance criteria
- AC3: Appliers are drop-in plugins discovered and invoked by a runner, with per-target failure isolation preserved

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC3: Appliers are drop-in plugins discovered and invoked by a runner, with per-target failure isolation preserved
- request-AC3 -> This backlog slice. Proof: AC3: Appliers are drop-in plugins discovered and invoked by a runner, with per-target failure isolation preserved

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — applier REGISTRY table exists in theme-switch.py (delivered); remaining: refactor to declarative plugin manifests + failure isolation. Keep Ready.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.
