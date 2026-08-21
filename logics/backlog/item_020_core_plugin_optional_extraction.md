## item_020_core_plugin_optional_extraction - Core -> plugin / optional extraction
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Extensibility
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: core, plugin, optional, extraction
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Personal bits baked into core: dev-workflow tooling, hardcoded logo set, machine-specific config, dashboard persona/dev bits, Catppuccin-only accent, obsidian vault lock

# Scope
- In:
  - Data-driven logo set; machine profiles; configurable dashboard scan paths; accent for all families with GTK fallback; document obsidian per-vault lock
- Out:
  - Dev-workflow plugin itself (Sprint 27)

# Acceptance criteria
- AC3: Personal-only features are extractable/config-driven and a lean sane default ships

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: Personal-only features are extractable/config-driven and a lean sane default ships
- request-AC4 -> This backlog slice. Proof: AC3: Personal-only features are extractable/config-driven and a lean sane default ships

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.
