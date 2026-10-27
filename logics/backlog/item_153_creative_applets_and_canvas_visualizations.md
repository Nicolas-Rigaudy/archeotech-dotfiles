## item_153_creative_applets_and_canvas_visualizations - Creative applets and canvas visualizations
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 25%
> Complexity: High
> Theme: Operator workflow and runtime integration
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-10-21 17:50:34

# AI Context
- Summary: Canvas hero-viz primitive (OrbitViz, shipped on night/showcase as a System Status face) plus the creative applets still to build: Digital Wellbeing, Kanban/Tasks, draw/annotation overlay.
- Keywords: creative, applets, canvas, visualizations
- Use when: Building a Canvas data-viz for a panel, or one of the creative applets (wellbeing, kanban, draw).
- Skip when: The GPU cava visualizer, plain list panels, motion plumbing (item_125 / req_002).

# Problem
Panels should reach for a signature Canvas visualization where a plain list is dull, and the applet set should grow toward "full-featured + creative."
Scope IN: a reusable Canvas hero-viz primitive (radial nodes + animated strands / decorative orbit, repaint gated on `visible`); a Digital Wellbeing (screen-time) applet; a Kanban/Tasks applet; a draw/annotation quick-action overlay.
Scope OUT: the GPU cava audio visualizer (existing item — separate); motion plumbing (req_002); theming/packs (req_001); widget faces (req_003).

# Scope
- In:
  - one coherent delivery slice from the source request
- Out:
  - unrelated sibling slices that should stay in separate backlog items instead of widening this doc

# Acceptance criteria
- AC1: A reusable Canvas hero-viz primitive (radial nodes + animated strands / decorative orbit), repaint gated on visibility, usable by the network/BT/workspace panels.
- AC2: A Digital Wellbeing (screen-time) applet.
- AC3: A Kanban/Tasks applet (to-do / ongoing / done, priority, deadlines) aligned with the work-first principle.
- AC4: A draw/annotation quick-action overlay (brush/eraser, undo/redo).

# AC Traceability
- request-AC1 -> This backlog slice. Proof: AC1: A reusable Canvas hero-viz primitive (radial nodes + animated strands / decorative orbit), repaint gated on visibility, usable by the network/BT/workspace panels.
- request-AC2 -> This backlog slice. Proof: AC2: A Digital Wellbeing (screen-time) applet.
- request-AC3 -> This backlog slice. Proof: AC3: A Kanban/Tasks applet (to-do / ongoing / done, priority, deadlines) aligned with the work-first principle.
- request-AC4 -> This backlog slice. Proof: AC4: A draw/annotation quick-action overlay (brush/eraser, undo/redo).

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
- Request: `logics/request/req_004_creative_applets_and_canvas_visualizations.md`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: The hero-viz primitive is the visible wow for new users; the three applets are post-1.0 depth (scope freeze) so only AC1 is pulled forward.

# Notes
- 2026-10-21 (night run): AC1 primitive delivered on shell branch night/showcase: `Commons/Primitives/OrbitViz.qml` + `OrbitLogic.js` (tests/qml/tst_orbitlogic.qml), mounted as the System Status "orbit" face. Repaint timer gated on visibility. Not yet used by the network/BT/workspace panels (remaining part of AC1). AC2-AC4 untouched. Renders: cr-0w/local/state/night/shots/20261021-showcase/showcase/. Open owner decision: make Orbit the default System Status face (currently opt-in via the face carousel).
- Hybrid rationale: Derived from request `req_004_creative_applets_and_canvas_visualizations` and kept bounded to one coherent delivery slice.
- Source file: `logics/request/req_004_creative_applets_and_canvas_visualizations.md`.
- Generated locally by logics-manager.

# Tasks
- `task_075_creative_applets_and_canvas_visualizations`
