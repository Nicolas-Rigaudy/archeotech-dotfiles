## item_021_theme_packs_official_community - Theme Packs (official + community)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Theming ecosystem
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-28 12:53:19

# AI Context
- Summary: The DISTRIBUTION + tiers slice of the theme-pack system (rescoped 2026-08-21 under adr_026): bundling a whole identity as an installable pack and the official/verified/community tier model. The deep capability surface is item_081, the manifest schema is item_066, install mechanics are item_065, and the Manager UI is item_063 — this item owns the "installable, curated catalog" concern.
- Keywords: theme, packs, official, verified, community, tiers, catalog, distribution, bundle
- Use when: Defining what a distributable pack bundles + the official/verified/community tier + trust model.
- Skip when: Building the engine (item_081), the manifest (item_066), or install/Manager plumbing (item_065/063).

# Problem
- Even with a capability surface (item_081), there is no way to BUNDLE a whole aesthetic identity (tokens + shape/font overrides + FX + wallpapers + logo/sigil + Zen gradient + persona + pack-scoped settings) as an installable, trust-tiered pack discoverable from an index.

# Scope
- In:
  - Pack bundle definition (what ships in a pack) layered on the item_081 capability surface + item_066 manifest.
  - Official / verified / community tier + trust model; official packs incl. Shadow Spears (item_082); community index via plugins.json (item_065).
  - Palette-driven Zen workspace gradient write during the relaunch window.
- Out:
  - The capability-surface engine (item_081) and manifest schema (item_066).
  - Install mechanics (item_065) and Manager pane UI (item_063) — reused, not rebuilt here.
  - Building named-personality packs before the glass base is settled.

# Acceptance criteria
- AC3: A theme pack bundling tokens/shape/FX/wallpapers/logo/gradient/persona/pack-settings can be installed from a trust-tiered index

# AC Traceability
- request-AC3 -> This backlog slice. Proof: AC3: an identity-complete, trust-tiered pack is installable from an index
- request-AC1 -> This backlog slice. Proof: AC3 delivers the installable-pack half of the platform

# Decision framing
- Product framing: Not needed
- Architecture framing: Governed by `adr_026_theming_architecture_skin_structure_boundary_and_versioned_capability_surface`.
- 2026-09-28 owner decision: all identity packs other than Base (Grimdark/Warhammer, cyberpunk, gundam, ...) ship as add-ons through this community pack support; this is a 1.0 requirement.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): `adr_026_theming_architecture_skin_structure_boundary_and_versioned_capability_surface`
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): `task_031_orchestrate_2026_09_28_audit_upgrade_program`

# Priority
- Priority: High
- Rationale: Owner decision: identity packs ship as community add-ons (2026-09-28 audit)

# Tasks
- `task_031_orchestrate_2026_09_28_audit_upgrade_program`
