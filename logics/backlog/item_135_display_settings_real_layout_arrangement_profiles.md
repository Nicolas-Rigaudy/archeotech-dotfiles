## item_135_display_settings_real_layout_arrangement_profiles - Display settings: real layout, arrangement, per-output modes and profiles
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 85%
> Confidence: 80%
> Progress: 0%
> Complexity: Medium
> Theme: Display
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Replace the Display pane's fire-and-forget layout selector with settings bound to the real compositor output state.
- Keywords: settings, display, settings, real, layout, arrangement, profiles
- Use when: Implementing this Settings addition picked from the item_134 audit.
- Skip when: Working on other Settings panes; see item_134 for the full comparison.

# Problem
- Display -> Layout (extend/mirror/laptop/external) runs wlr-randr and never reads state back; after a restart it shows extend regardless.
- extend puts every external at 1920,0, so HDMI-A-1 and the portrait DP-3 overlap on the work setup.
- Reference: DMS Displays -> Configuration (arrangement canvas, per-output resolution/refresh/scale/transform, saved profiles with auto-select, staged apply/discard).

# Scope
- In:
  - Read outputs, modes, positions, scale and transform from the compositor (mango monitor rules / wlr-randr) and show them
  - Arrangement for 2-3 outputs incl. a rotated portrait output
  - Per-output resolution/refresh, scale, rotation
  - Saved profiles (work, home) with auto-select on hotplug; staged apply with revert
- Out:
  - Hyprland parity beyond what the CompositorService facade already abstracts

# Acceptance criteria
- AC1: After a restart the pane shows the real current layout of every output.
- AC2: The work setup (eDP-1 + HDMI-A-1 + portrait DP-3) can be arranged without overlap and saved as a profile that re-applies on dock.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC1: After a restart the pane shows the real current layout of every output.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_003_archeotech_1_0_after_the_2026_09_28_audit`
- Architecture decision(s): (none yet)
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Primary task(s): (none yet)

# Priority
- Priority: High
- Rationale: owner picked it from the item_134 settings audit (2026-09-29).

# Notes
- Generated locally by logics-manager.
