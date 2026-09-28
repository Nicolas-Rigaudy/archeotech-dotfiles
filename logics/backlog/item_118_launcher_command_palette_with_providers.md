## item_118_launcher_command_palette_with_providers - Launcher command palette with providers
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Launcher
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: Launcher command palette with providers. The provider registry at Launcher.qml:221 only has settings, power and a JS calculator
- Keywords: launcher, command, palette, providers
- Use when: Implementing or reviewing the 0.50 Utility layer milestone work on launcher.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- The provider registry at Launcher.qml:221 only has settings, power and a JS calculator; clipboard, emoji, window switching and commands still live in rofi scripts.
- Evidence: audit-features.md competitor matrix (DMS, Noctalia, Caelestia, end-4/ii, Ambxst).

# Scope
- In:
  - Prefix modes; providers for clipboard (cliphist), windows, projects, emoji, qalc, script commands, quicklinks, SSH hosts
  - Plugin-extensible provider API
- Out:
  - AI provider (Claude Ask item)

# Acceptance criteria
- AC1: Each provider is reachable by prefix and by blended search.
- AC2: Four rofi scripts are retired.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC1: Each provider is reachable by prefix and by blended search.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Absorbs item_025 (clipboard image entries and pinning), item_029 (quick tools: color picker, screenshot, record, OCR, emoji) and item_032 (SSH hosts).

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: High
- Rationale: biggest feature gap vs the field and the entry point for dev features (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
