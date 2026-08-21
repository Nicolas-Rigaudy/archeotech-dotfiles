## item_079_cava_audio_visualizer_element_bar_dashboard_lock_spectrum_opt_in - cava audio-visualizer element (bar/dashboard/lock spectrum, opt-in)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-21 15:52:25

# AI Context
- Summary: An opt-in cava audio-spectrum visualizer element, themed to tokens, mountable on the bar, dashboard, and/or lock screen. Reads cava output and renders a glass/HUD spectrum that pairs with the existing MPRIS media surface. Sourced from item_042 finding A2; a high-wow, on-theme (mecha-HUD/cyberdeck) addition feeding the polish + demo story.
- Keywords: cava, audio, visualizer, spectrum, bar, dashboard, lock, mpris, opt-in
- Use when: Adding motion/liveliness to a demo or the dashboard/lock; wiring the media story.
- Skip when: A surface that must stay static/quiet, or when audio capture isn't desired.

# Problem
- The shell has no live, audio-reactive element; peer rices lean on visualizers for "liveliness" and it's a strong demo/wow beat that also fits the Gundam-HUD identity.

# Scope
- In:
  - A cava-backed spectrum widget (subprocess stream -> token-themed bars), opt-in per mount point (bar / dashboard / lock).
  - Config surface via configSchema; respects flat<->glass and the accent tokens.
  - Idle handling (no audio -> collapse/hide) to stay "quiet by default".
- Out:
  - Bundling/installing cava itself (packaging note only; add to docs/PACKAGES.md).
  - Full media-panel redesign.
- Dependency: requires `cava` present (document as optional dep).

# Acceptance criteria
- AC1: An opt-in, token-themed cava spectrum renders on at least one mount point and idles cleanly with no audio.
- AC2: Enable/placement is configurable and respects the flat<->glass toggle + accent tokens.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: token-themed cava spectrum with idle handling delivered.
- request-AC2 -> This backlog slice. Proof: configurable + theme-respecting.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: High-wow, on-theme liveliness win from the item_042 pass; opt-in so it stays "quiet by default". Below the HUD kit (item_078) on fit-to-effort due to the cava dependency.

# Notes
- Generated locally by logics-manager.
