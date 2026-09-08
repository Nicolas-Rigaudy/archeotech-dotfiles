## item_098_custom_pill_containers_arbitrary_n_separators_containers_per_side_with_chosen_widgets - Custom pill containers — arbitrary N separators/containers per side with chosen widgets
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 55
> Confidence: 50
> Progress: 0%
> Complexity: High
> Theme: Visual builder
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Future generalization of bar/strip zoning — instead of fixed left/center/right (bars) and a single centered lane (strips), let a side hold an arbitrary number of user-defined "pill containers", each a grouped pill with its own chosen widgets and a separator between them. Supersedes the fixed 3-zone-strips idea and connects to the applet-grouping stretch (item_096).
- Keywords: custom, pill, containers, arbitrary, separators, per, side, chosen, widgets
- Use when: designing the general container/zoning model for bars and strips together.
- Skip when: the immediate WYSIWYG builder work (task_028, done) or a fixed 3-zone-strips slice.

# Problem
- Zoning is hardcoded: bars = left/center/right, strips = one centered cluster. The user wants to define as many containers/separators as they like per side and place chosen widgets in each — a fully customizable grouping model, framed as the endgame that a fixed-3-zone-strips change would otherwise be throwaway work against.

# Scope
- In:
  - A general per-side container model: an ordered list of containers, each with an alignment/position and its own widget list, replacing the fixed align tokens; a separator/pill chrome between/around containers.
  - Builder support to add/remove/reorder containers and drag widgets between them (reuses task_027 drag machinery); live Bar/Strip renderers honor N containers.
  - Backward-compatible migration from today's align-based config (left/center/right + "").
- Out:
  - The applet-grouping merge affordance (item_096) — related but separate; cross-window drag (adr_028).

# Acceptance criteria
- AC1: A side can hold N user-defined containers, each with chosen widgets, rendered live with separators and editable in the builder.
- AC2: Existing align-based configs migrate cleanly and keep rendering.

# Decision framing
- Product framing: Not needed
- Architecture framing: Needs an ADR — this reworks the align/zoning model that adr_028 and the non-destructive type-flip invariant depend on; sequence relative to item_096 (grouping) and any fixed-3-zone-strips slice.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (ADR to be written at grooming)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: User-requested future direction; groom alongside item_096 before committing to the zoning-model rework.

# Notes
- Generated locally by logics-manager.
