## item_169_cyberdeck_entrance_motion_system - Cyberdeck entrance motion system for big and small surfaces
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 85%
> Confidence: 75%
> Progress: 0%
> Complexity: High
> Theme: Identity packs
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: One shared entrance animation for every cyberdeck surface, in two types: big panels (glitch, scan, land, decode, reticle lock) and small surfaces (glitch, rows land in order, decode; no scan). Tempo factor 1.5. Owner-approved from prototype videos on 2026-11-06.
- Keywords: cyberdeck, entrance, motion, glitch, scan, decode, reticle, tempo, reduce motion, screen effects
- Use when: Building or reviewing how cyberdeck panels, popups or toasts appear.
- Skip when: Static chrome of a register (item_166/167/168); screensaver (item_158).

# Problem
- Cyberdeck panels open with the stock slide only. The owner asked for one reusable motion system across panels rather than per-panel animation, and rejected a toast that moved differently from the other small surfaces.

# Target
- Spec: .claude/CYBERDECK_RESEARCH.md, section "Motion: one entrance system". Prototype videos: cr-0w local/state/shots/cyberdeck-pack/netrunner-motion-v3.mp4 (big) and netrunner-motion-v4.mp4 (Option 2 clips = small).
- Timings in ms times k, k = 1.5: glitch 130, scan 220 (big only), decode 380, reticle lock 80, small-surface row stagger 40.

# Scope
- In:
  - Entrance seam: a pack-level entrance component a surface opts into by declaring plate, anchor edge, sections in reading order, decoding headers and the selection; motion tokens with the tempo factor.
  - Big type (dashboard, launcher, settings, agents) and small type (popups, toasts, calendar, OSD).
  - Glitch overlay (slices plus cyan/magenta chamfered ghosts) and a scan clipped inside the chamfers.
  - Decode text role (scramble then resolve) for panel and card headers.
  - Reticle on the list selection through RowSelection.
  - Screen effects selector Off | Subtle | Full; Off and Reduce motion show content at once.
- Out:
  - Non-cyberdeck packs (the base shell keeps its current motion).
  - Exit animations.

# Acceptance criteria
- AC1: Every cyberdeck big panel and small surface enters through the shared component; no per-panel timing code.
- AC2: Frame captures at k = 1.5 match the prototype phases (glitch, scan inside the chamfers, land, decode, lock) for one big and one small surface.
- AC3: Reduce motion or Screen effects = Off renders the final state on the first frame; goldens unchanged.

# AC Traceability
- AC1 -> Entrance seam. Proof: grep shows surfaces only declare specs.
- AC2 -> Frame captures. Proof: shot.sh frame sequence beside the prototype.
- AC3 -> Reduce motion path. Proof: golden.sh passes.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: (to be linked)
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Owner-approved identity polish; follows the Netrunner chrome (item_166, done) and does not block the other registers.

# Notes
- Generated locally by logics-manager.
- Owner picks 2026-11-06: tempo x1.5; glitch over outline draw; slower scan kept inside the chamfers; two types (big + small) over one shared entrance.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

