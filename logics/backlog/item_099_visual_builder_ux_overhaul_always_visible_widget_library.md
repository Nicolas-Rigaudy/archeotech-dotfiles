## item_099_visual_builder_ux_overhaul_always_visible_widget_library - Visual builder UX overhaul + always-visible widget library
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 95
> Confidence: 95
> Progress: 100%
> Complexity: High
> Theme: Visual builder
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-09-08 16:54:09

# AI Context
- Summary: Post-task_028 refinement pass on the visual builder (EditOverlay) plus a new always-visible Widget Library. Grew directly out of user feedback while dogfooding task_027 (DnD) + task_028 (WYSIWYG mocks); captured here because it went past task_028's closed scope.
- Keywords: visual, builder, overhaul, always, visible, widget, library, edit mode
- Use when: touching EditOverlay chip/mock styling, the mode switch, or the Widget Library add/remove flow.
- Skip when: the core DnD mechanics (task_027) or the initial WYSIWYG silhouettes (task_028).

# Problem
- The WYSIWYG builder (task_028) shipped, but dogfooding surfaced readability/usability gaps: bar chips carried titles at rest so the status cluster crowded the centred clock; the strip mocks didn't size to their icon count; the Bar/Strip/Holder/Off selector was opaque, squared and drew a long horizontal line beside vertical strips; the per-side "+ Add" read as "add a mode" not "add a widget"; and the live Strip renderer had regressed to a fixed length.

# Scope
- In:
  - Bar chips compact (icon-only) at rest, title + gear/remove revealed on hover.
  - Strip mocks size to their icon count and centre on the edge; all strip chips icon-only (match live strip lanes).
  - Mode switch redesigned: a glass, subtly-rounded segmented control (readable solid active), that follows the side axis (horizontal under bars, vertical stack beside strips).
  - Always-visible, centred Widget Library: every addable widget as a tile in an aligned 3-column grid, grouped into functional sections (System / Info / Panels & launchers / Plugins / More); drag a tile onto a mock to add, drag an existing chip back onto the library to remove (replaces the per-side +Add and the separate centre trash). Footer "Manage & get more widgets" opens the Plugins settings pane (browse/install lands there in 0.27 — see item_065).
  - Live Strip renderer fix: strip length adapts to icon count again (decoupled `_bodyAxis` from the stale `expanded:240` that setSideType wrote), icons packed at a fixed stride with real end padding.
- Out:
  - The community plugin index / install mechanism (item_065/066, 0.27); applet grouping (item_096); 3-zone strips / N-container pill model (item_098).

# Acceptance criteria
- AC1: Builder mocks read WYSIWYG — bar chips are compact at rest with titles on hover; strips size/centre to their icon count; the mode switch is a glass segmented control that follows the side's axis.
- AC2: An always-visible categorised Widget Library adds widgets by drag and removes by dragging a chip back onto it; its footer opens the Plugins settings pane.
- AC3: The live (non-edit-mode) strips size to their icon count again (the `expanded:240` regression is fixed).

# AC Traceability
- request-AC3 -> This backlog slice. Proof: raises the visual-builder DnD/WYSIWYG chain (task_027/028) to a usable, readable edit surface and repairs the live strip sizing.

# Decision framing
- Product framing: Not needed
- Architecture framing: extends adr_028 (intra-surface mock); no new ADR — same drag machinery (ShellConfig.moveConversion/moveEntry/addAt), richer surface.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): `adr_028_visual_builder_dnd_intra_surface_mock_drag_with_click_to_assign_fallback`
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_029_visual_builder_ux_overhaul_always_visible_widget_library`

# Priority
- Priority: High
- Rationale: Directly-requested UX, delivered; documented for the record.

# Notes
- Generated locally by logics-manager.
- Task `task_029_visual_builder_ux_overhaul_always_visible_widget_library` was finished via `logics-manager flow finish task` on 2026-09-08.

# Tasks
- `task_029_visual_builder_ux_overhaul_always_visible_widget_library`
