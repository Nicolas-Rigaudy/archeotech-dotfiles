## item_072_docs_compositor_support_md_for_both_compositors - docs COMPOSITOR_SUPPORT.md for both compositors
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
- Summary: Writes docs/COMPOSITOR_SUPPORT.md documenting setup and behavior parity for both MangoWC and Hyprland.
- Keywords: docs, compositor, support, both, compositors
- Use when: Writing or updating the compositor-support documentation itself.
- Skip when: Implementing the CompositorService facade (item_070) or the Hyprland config/session/reload work (item_071) that this doc describes.

# Problem
- There is no single document telling a user which compositor to pick, how to switch, or what parity gaps (if any) exist between MangoWC and Hyprland.
- Without this doc, a stranger installing the shell on Hyprland has no reference for session setup or known limitations.

# Scope
- In:
  - `docs/COMPOSITOR_SUPPORT.md` covering: supported compositors (MangoWC primary, Hyprland), SDDM session selection, feature parity table, and any known gaps
  - Cross-links to the Hyprland config port (item_071) and the CompositorService facade (item_070)
- Out:
  - Implementing the facade or config port itself (item_070, item_071)
  - Niri/Sway documentation (post-1.0)

# Acceptance criteria
- AC1: docs/COMPOSITOR_SUPPORT.md exists and documents setup steps for both MangoWC and Hyprland sessions.
- AC2: The doc lists any known feature gaps between the two compositors rather than implying full parity if one doesn't exist.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: docs/COMPOSITOR_SUPPORT.md is the exit-signal documentation deliverable for milestone 0.29.

# Priority
- Priority: Low
- Rationale: Documentation-only task that depends on item_070 and item_071 landing first; no code risk.

# Decision framing
- Product framing: Not needed
- Product signals: (none detected)
- Product follow-up: No product brief follow-up is expected based on current signals.
- Architecture framing: Not needed
- Architecture signals: (none detected)
- Architecture follow-up: No architecture decision follow-up is expected based on current signals.

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
