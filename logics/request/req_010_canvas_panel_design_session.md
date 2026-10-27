## req_010_canvas_panel_design_session - Canvas panel design session: which panels gain from a canvas approach
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 90%
> Confidence: 85%
> Complexity: Medium
> Theme: General
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: Working session with the owner to pick the panels where a Canvas hero visual (OrbitViz style) improves UI and UX, and how it fits the panel design, before any of it ships.
- Keywords: canvas, OrbitViz, hero viz, panel redesign, Serpantinum, orbital connection manager
- Use when: planning canvas visuals in any panel, or reviving OrbitViz.
- Skip when: tuning an existing list or card layout with no canvas element.

# Needs
- The owner likes the canvas direction from the inspiration repos (Serpantinum orbital connection manager, cosmic calendar, audio-reactive media) but not the first attempt: an Orbit face and a Chain render for System Status (night run, 2026-10-21).
- Decide, in a working session with the owner, which panels gain from a canvas approach and how it sits inside the global panel design, instead of bolting a visual onto one card.

# Context
- Owner decision 2026-10-21: System Status keeps gauges as the default; Orbit and Chain have "something there" but need refining and integrating into the global panel design, maybe for another panel. The Orbit face was removed from System Status on 2026-10-27 (shell `0fe8efd`).
- `Commons/Primitives/OrbitViz.qml` + `OrbitLogic.js` (tests `tests/qml/tst_orbitlogic.qml`) stay on shell main, unmounted, as the starting point.
- Inspiration: `.claude/ANALYSIS.md` section 20.1/20.2 (Serpantinum canvas hero element, orbital connection manager, cosmic calendar, audio-reactive MusicPopup). Renders of the first attempt: `cr-0w/local/state/night/shots/20261021-showcase/showcase/` (`options-compare.png`).
- Candidates to review: Bluetooth / network (device node graph, item_153 AC1), media panel, calendar, workspace overview, idle screensaver (item_085), System Status in a refined form.
- Constraints: repaint gated on visibility, Iris Xe CPU budget, follows the motion settings (item_114 reduce motion and animation speed), works in light, flat and Grimdark.

# Acceptance criteria
- AC1: A session with the owner reviews rendered options per candidate panel (opened in imv before any choice) and records which panels get a canvas visual and which do not.
- AC2: The chosen panels have a design direction that fits the global panel design (materials, motion, light/flat/Grimdark).
- AC3: The outcome is promoted into backlog slices, or merged into item_153, with OrbitViz reused or reworked.

# Definition of Ready (DoR)
- [ ] Problem statement is explicit and user impact is clear.
- [ ] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- `.claude/ANALYSIS.md`
- `logics/backlog/item_153_creative_applets_and_canvas_visualizations.md`
- `logics/request/req_004_creative_applets_and_canvas_visualizations.md`

# Backlog
- none
