## item_160_scanner_launcher_style_kill_mode_overlay_and_layout_profiles - Scanner launcher style, kill-mode overlay and layout profiles
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: High
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: scanner, launcher, style, kill, mode, overlay, layout, profiles
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Three CyberArch-Shell ideas touch behaviour, which a pack cannot add (adr_026).

# Scope
- In:
  - Scanner launcher: a launcher style delegate (scan line sweep on open, framed result tiles, target reticle on the selection); sound off by default.
  - Kill mode: a core or plugin action (pick a window, confirm, close or kill) with a pack-styled overlay (reticle, window label, target box); Esc cancels; check overlap with mango's own kill bind first.
  - Layout profiles (Minimal, Balanced, Cinematic): check against Contexts (0.60) and Edit Layout before adding anything; likely a preset list of shell-config layouts.
  - Split into separate items once the owner picks which to keep.
- Out:
  - Audio cues on by default; behaviour inside the pack.

# Acceptance criteria
- AC1: Each idea has an owner decision (keep, merge into an existing item, drop) and the kept ones have their own item.

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC1: Each idea has an owner decision (keep, merge into an existing item, drop) and the kept ones have their own item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_004_cyberdeck_identity_pack`
- Architecture decision(s): (none yet)
- Request: `req_011_cyberdeck_theme_pack_droid_console_identity_for_the_shell_and_terminal`
- Primary task(s): `task_076_orchestrate_the_cyberdeck_theme_pack`

# Priority
- Priority: Low
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

