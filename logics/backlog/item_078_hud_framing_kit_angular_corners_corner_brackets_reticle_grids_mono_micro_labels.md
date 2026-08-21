## item_078_hud_framing_kit_angular_corners_corner_brackets_reticle_grids_mono_micro_labels - HUD framing kit (angular corners, corner brackets, reticle grids, mono micro-labels)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 16:01:07

# AI Context
- Summary: A reusable framing primitive — angular/clipped corner cuts, corner brackets + tick marks, thin reticle/technical-grid overlays, all-caps monospace micro-labels — offered as QML helpers + tokens. NOT a global treatment: it is a capability that the **Gundam cockpit-HUD theme pack** (and partly the cyberdeck pack) turns on. The neutral glassmorphism base does NOT use it. Sourced from item_042 finding A1; a building block for the themeable-shell direction (see item_021 theme packs).
- Keywords: hud, framing, kit, primitive, angular, corners, brackets, reticle, grid, mono, micro-labels, gundam, theme-pack
- Use when: Building the Gundam/cyberdeck theme packs, or any pack that wants HUD chrome; building the shared framing helper.
- Skip when: Working the neutral base theme, release plumbing, or a surface where a pack hasn't opted into HUD chrome.

# Problem
- Archeotech is moving to a base-theme + swappable-theme-pack model. The Gundam-cockpit and cyberdeck packs need HUD framing chrome, but there is no reusable, theme-gated primitive for angular corners / brackets / reticle grids / mono labels — so pack authors would reinvent it ad-hoc.

# Scope
- In:
  - A reusable QML helper (Shape/Canvas + tokens) for angular corner cuts, corner brackets/ticks, thin reticle-grid overlays, and all-caps mono micro-labels.
  - Token entries so it is theme-driven (nothing hardcoded) and **only active when a theme pack opts in** (off on the neutral base).
  - Adoption on a pilot surface under a HUD-flavored pack, feel-checked live.
- Out:
  - Applying HUD chrome to the neutral base theme (it is pack-scoped).
  - The theme-pack architecture itself (item_021 + a theming-depth ADR).
  - Motion/shader work (separate item_042 findings A3/A4).

# Acceptance criteria
- AC1: A reusable, token-driven HUD-framing helper exists and is documented in the widget API.
- AC2: At least one surface adopts it and passes a live feel-check without hurting hover/hit-testing.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: reusable HUD-framing helper delivered.
- request-AC2 -> This backlog slice. Proof: piloted on a real surface and feel-checked.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Highest fit-to-effort from the item_042 ricing pass; cheap, on-brand, strong coherency + wow win feeding the polish rollout.

# Notes
- Generated locally by logics-manager.
