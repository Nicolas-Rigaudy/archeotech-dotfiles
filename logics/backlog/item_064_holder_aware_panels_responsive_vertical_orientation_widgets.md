## item_064_holder_aware_panels_responsive_vertical_orientation_widgets - Holder-aware panels + responsive vertical-orientation widgets
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Makes bars able to host panels (holder-aware) and gives widgets real responsive vertical-orientation layouts so any widget lays out correctly on any side.
- Keywords: holder, aware, panels, responsive, vertical, orientation, widgets
- Use when: Working on bar/strip panel hosting, widget vertical layouts, or the holder-agnostic panel contract.
- Skip when: Working on per-instance config forms or the Plugin/Widget Manager pane (see item_063).

# Problem
- Most widgets gate on `barRoot.horizontal` and fall back to a plain icon column on vertical strips, so "fits on any side" is not fully true.
- Panels (dashboard, launcher, wallpaper picker) can only drop from the strip, not from bars, limiting where a user can place trigger widgets.
- There is no shared holder-agnostic contract, so bar and strip hosting logic duplicates rather than reuses panel/opener code.

# Scope
- In:
  - Responsive vertical-orientation layouts for widgets (shared capsule component forking horizontal/vertical instead of text rotation)
  - Holder-aware panels: bars can host and drop a panel from the bar edge, anchored to the clicked opener
  - A holder-agnostic contract (side/horizontal/type/screen/thickness/togglePanel/dismissPopups) shared by Bar and Strip
- Out:
  - configSchema auto-forms and the Plugin/Widget Manager pane (item_063)
  - Intra-overlay drag-and-drop reorder (deferred, tracked separately)

# Acceptance criteria
- AC1: Every built-in widget renders a real vertical layout (not an icon-only fallback) when placed on a vertical side.
- AC2: A panel (e.g. dashboard) can be opened by clicking its widget on a bar, not only on the strip, using the same visual treatment.
- AC3: Bar and strip hosting share one holder-agnostic API rather than duplicated per-side logic.

# AC Traceability
- request-AC2 -> This backlog slice. Proof: holder-aware panels and responsive vertical-orientation widgets ship as part of milestone 0.26's widget/panel feature set.

# Priority
- Priority: Medium
- Rationale: Improves layout flexibility but is not a hard blocker for the 0.26 exit signal, unlike per-instance config.

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.
- Audit 2026-08-21: PARTIAL — holder-aware contract in WidgetLoader (delivered); remaining: responsive vertical-orientation widget layouts. Keep Ready.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: `logics/request/req_000_archeotech_shell_dotfiles.md`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Hybrid rationale: Derived from request `req_000_archeotech_shell_dotfiles` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_000_archeotech_shell_dotfiles.md`.
- Generated locally by logics-manager.
