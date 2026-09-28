## item_126_versioned_plugin_api_exposing_shell_services - Versioned plugin API exposing shell services
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 20%
> Complexity: High
> Theme: Extensibility
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 15:27:46

# AI Context
- Summary: Versioned plugin API exposing shell services. Plugins get no audio, media, network, compositor or storage access
- Keywords: versioned, plugin, api, exposing, shell, services
- Use when: Implementing or reviewing the 1.0 Release milestone work on extensibility.
- Skip when: Working outside this milestone; see road_001 for sequencing and .claude/audits/2026-09-28/ for evidence.

# Problem
- Plugins get no audio, media, network, compositor or storage access; built-in panel and widget ids are hand-listed in 5+ places instead of sharing the plugin manifest.

# Scope
- In:
  - Versioned service facade for plugins
  - Built-ins described by the same manifest as plugins
  - Port 2-3 built-in widgets onto the API as proof
- Out:
  - Plugin marketplace UI

# Acceptance criteria
- AC1: A plugin widget reads volume and media state through the API.
- AC2: Three built-in widgets run on the public API.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: AC1: A plugin widget reads volume and media state through the API.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: High
- Rationale: plugins can currently read theme tokens only (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
