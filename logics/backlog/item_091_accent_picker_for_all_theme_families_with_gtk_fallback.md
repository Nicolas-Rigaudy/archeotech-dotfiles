## item_091_accent_picker_for_all_theme_families_with_gtk_fallback - Accent picker for all theme families with GTK fallback
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 70
> Confidence: 70
> Progress: 0
> Complexity: Medium
> Theme: Theming
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Expose the accent picker for ALL theme families (not just Catppuccin), with graceful GTK fallback. QML/terminal/rofi/mango accent already works for any palette colour; only GTK needs per-accent packages. Migrated from ROADMAP.archived (core->plugin / "super-customizable" candidates).
- Keywords: accent, picker, theme, families, gtk, fallback, catppuccin
- Use when: extending the accent picker beyond Catppuccin; theme-switch accent application.
- Skip when: family/flavor selection (already works); shipping per-accent GTK packages for every family.

# Problem
- The accent picker is Catppuccin-only, yet accent already applies for ANY palette colour across QML/terminal/rofi/mango — only GTK needs per-accent packages. This artificially limits accent selection to one family.

# Scope
- In:
  - Expose accent selection for all accent-capable families in the picker.
  - Graceful GTK fallback when no per-accent GTK package exists (fall back to a computed/base accent rather than breaking).
- Out:
  - Shipping per-accent GTK packages for every family (fallback covers the gap).

# Acceptance criteria
- AC1: Accent is selectable for non-Catppuccin families across QML/terminal/rofi/mango targets.
- AC2: GTK degrades gracefully (documented fallback, no breakage) when a per-accent package is absent.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: broadens accent theming coherency (req_000 AC1) to all families with a GTK fallback.

# Decision framing
- Product framing: Not needed
- Architecture framing: relates adr_004 (token singleton + Python applier) and adr_003 (Catppuccin default + accent) — this generalises accent beyond the default family.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_004 (theme applier), adr_003 (palette + accent)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
