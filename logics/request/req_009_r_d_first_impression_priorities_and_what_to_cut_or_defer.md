## req_009_r_d_first_impression_priorities_and_what_to_cut_or_defer - R&D: first-impression priorities and what to cut or defer
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 80%
> Confidence: 70%
> Complexity: Medium
> Theme: Planning
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.
> Indicators reviewed: 2026-10-27 12:22:21

# AI Context
- Summary: Research note (no code) on what the shell should do next so a new user is impressed, and what to cut or defer from the road_001 roadmap to make room. Written after the 2026-10-21 showcase night (OrbitViz face, staggered dashboard entrance). Items marked "Proposal" are NOT backlog items; nothing here is scheduled.
- Keywords: research, priorities, first impression, showcase, cut, defer, roadmap
- Use when: Re-sequencing road_001, deciding what to build after 0.60, or choosing the next wow feature.
- Skip when: Implementing an already-scoped item.

# Needs
- Owner goal (2026-10-21): make the overall UI/UX better and more impressive for a user, like the canvas panels.
- Decide what earns the first 60 seconds of a stranger's experience, and which of ~100 open roadmap items can wait.

# Context
## What a newcomer sees, in order
1. README (screenshots, GIF) 2. install 3. first boot (bar) 4. dashboard 5. launcher 6. settings and theme switch. Peer shells (Caelestia, Noctalia, DankMaterialShell, HyprPanel, illogical-impulse; from general knowledge, not re-checked tonight) win mostly on steps 1 and 3-4: visible motion, wallpaper-driven colour and a polished first screen. Archeotech already has the harder parts (theme engine, visual builder, settings GUI, headless render/golden harness) but its storefront is the weakest: item_077 (README shots and GIF) and item_040 (onboarding) sit at the very end of 1.0.

## Audience risk
MangoWC is the primary target and a niche compositor; Hyprland parity (item_128) decides how many strangers can even try the shell. It is more important to the "impressive to a user" goal than any single widget.

## State found tonight
- Panels already grow from the bar edge (`Strip.qml` `_perp`/`_axis` Behaviors, input mask follows); item_125's "panels fade in" premise is stale. What is missing is a single shared driver (interrupt proof) and inner choreography. Staggered dashboard entrance now exists (EntranceStagger).
- Canvas hero-viz exists (OrbitViz) but is only mounted as an opt-in System Status face.
- Render harness can capture bursts, so motion can be shown in the README without screen recording.

# Recommendation: do next (in this order)
1. Finish the signature feel before Contexts: item_125 remainder (shared morph driver with a burst-capture proof, sliding selection highlight, EntranceStagger on launcher/settings) plus item_114's reduced-motion/animation-scale switch, because every new animation needs an off switch. Reason: cheap, visible in every session, and the exit signal of 0.60 already demands it.
2. Pull the storefront forward: item_077 (without the tag, which stays an owner action) and item_040 onboarding, built from `shot.sh --fresh` renders and burst strips. Reason: it is the first thing strangers see and costs days, not weeks.
3. Hyprland parity (item_128) before Contexts. Reason: audience size.
4. Contexts (item_122) stays the headline but time-boxed; if it slips, ship 1.0 with the wow set above and move Contexts to 1.1 (the roadmap already names it the first candidate to move).
5. Reuse OrbitViz where data is live: network/Bluetooth node graph (completes item_153 AC1), workspace overview. Reason: that is where a plain list is dullest and the data already exists (item_121).

# Recommendation: defer or cut
- Defer to after 1.0 (unchanged): 1.3 builder depth (096, 098, 046, 062), 1.2 motion personalities (keep only the reduced-motion/scale switch), 088 bar container variants, 129 more identity packs.
- Cut or park indefinitely: 1.5 as a block (084 Hyprland Lua, 089 Niri/Sway, 090 Zen chrome, 019/020 refactors) until a user asks; they widen reach before depth is there.
- Keep small and late: 085 idle/screensaver (OrbitViz would make a cheap one), item_153 AC2-4 (wellbeing, kanban, draw) as opt-in plugins; they are applets, not first-impression work.
- Do not start more identity-pack or theme work before the 0.40 sign-off: past commits were about half look-and-feel iteration (see roadmap risks).

# Proposals (not backlog items, owner to accept or drop)
- P1: README motion strip from burst frames (publishes outward: owner approves).
- P2: Perf budget for canvas panels: measure idle CPU with the dashboard closed (the repaint timer is gated on visible) and open on the target laptop, record it, then add a threshold to the golden run.
- P3: Decide whether Orbit becomes the default System Status face (one line: `face: "orbit"` in SystemStatus.qml).
- P4: Sliding selection highlight needs a visual choice (spring vs ease, accent bar vs filled pill); render options first.
- P5: A GPU/shader alternative (Caelestia-style SDF blob) only if Canvas proves too heavy; keep it a documented upgrade path as in req_004.

# Scope
- In: prioritisation advice and rationale.
- Out: code, new backlog items, schedule changes to road_001 (owner decision).

# Acceptance criteria
- AC1: The note ranks next work and says what to defer or cut, each with a reason.
- AC2: Proposals are labelled as proposals and no backlog item is created from them.
- AC3: Claims about peer shells are flagged as unverified general knowledge.

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [x] Acceptance criteria are testable.
- [x] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- `logics/roadmap/road_001_archeotech_shell.md`
- `logics/request/req_002_motion_and_fluidity_system.md`, `req_004_creative_applets_and_canvas_visualizations.md`
- shell branch `night/showcase` (OrbitViz, EntranceStagger)

# Backlog
- none

# Notes
- P3 settled 2026-10-21 by the owner: gauges stay the System Status default and the Orbit face was removed (2026-10-27). Canvas placement moves to req_010_canvas_panel_design_session.
