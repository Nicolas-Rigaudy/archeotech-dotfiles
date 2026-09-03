## item_089_niri_and_sway_compositor_services_post_v1_0 - Niri and Sway compositor services post v1_0
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 60
> Confidence: 65
> Progress: 0
> Complexity: Medium
> Theme: Compositor
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Add `NiriService`/`SwayService` behind the existing `CompositorService` facade so the shell also runs on Niri and Sway (Mango + Hyprland already shipped). Post-v1.0 portability; migrated from ROADMAP.archived "Post-v1.0 depth sprints". Ref Noctalia `Services/Compositor/`.
- Keywords: niri, sway, compositor, service, facade, portability, post-v1.0
- Use when: adding a 3rd/4th compositor backend behind CompositorService.
- Skip when: Mango/Hyprland backends (shipped); the facade API itself (proven).

# Problem
- The CompositorService facade + Mango + Hyprland backends are shipped, but the shell does not run on Niri or Sway — limiting portability to other machines/users. Cheap to add now that the facade has proven the pattern.

# Scope
- In:
  - Implement `NiriService` + `SwayService` against the facade API (`switchWorkspace`/`focusWindow`/`activeWorkspace`/`focusedApp`/`activeWindowTitle`); per-compositor blur namespace; extend `docs/COMPOSITOR_SUPPORT.md`.
- Out:
  - New facade API surface (reuse the Sprint-29 contract); audio/network/BT/notifications/lock (native QML, compositor-agnostic).

# Acceptance criteria
- AC1: The shell runs on Niri via `NiriService` behind the facade (workspaces + window/focus tracking work).
- AC2: The shell runs on Sway via `SwayService` behind the same facade.
- AC3: `docs/COMPOSITOR_SUPPORT.md` documents both.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: extends multi-compositor support (req_000 AC4) to Niri/Sway behind the CompositorService facade.

# Decision framing
- Product framing: Not needed
- Architecture framing: Governed by adr_006 (prefer native QS services; scope the daemon to raw Wayland protocols) — Niri/Sway are additional facade backends, no new architecture.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_006 (native-QS services + compositor facade), adr_001 (Mango primary / Hyprland fallback)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
