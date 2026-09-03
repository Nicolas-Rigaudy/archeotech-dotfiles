## req_004_creative_applets_and_canvas_visualizations - Creative applets and canvas visualizations
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 65
> Confidence: 65
> Complexity: High
> Theme: Applets
> Reminder: Update status/understanding/confidence and linked backlog/task references when you edit this doc.

# AI Context
- Summary: A reusable Canvas "hero visualization" primitive (radial nodes + animated strands, decorative orbit/idle motion) plus a set of new creative, full-featured applets — Digital Wellbeing (screen-time), Kanban/Tasks, and a draw/annotation quick-action. Candidate work from ANALYSIS.md §20.
- Keywords: creative, applets, canvas, visualization, wellbeing, kanban, draw, whiteboard
- Use when: building a creative panel/applet, a Canvas data-viz for a panel, or any of the new applets listed.
- Skip when: the GPU audio visualizer (existing `cava_audio_visualizer` item); plain list-style panels; motion-system plumbing (req_002); theming (req_001).

# Needs
- Panels should reach for a signature Canvas visualization where a plain list is dull, and the applet set should grow toward "full-featured + creative."
- Scope IN: a reusable Canvas hero-viz primitive (radial nodes + animated strands / decorative orbit, repaint gated on `visible`); a Digital Wellbeing (screen-time) applet; a Kanban/Tasks applet; a draw/annotation quick-action overlay.
- Scope OUT: the GPU cava audio visualizer (existing item — separate); motion plumbing (req_002); theming/packs (req_001); widget faces (req_003).

# Context
- Reference sources (ANALYSIS §20.1/20.2): Serpantinum orbital connection manager (Canvas central-core + orbiting nodes linked by animated sine-perturbed energy strands, 25ms repaint, distance falloff), cosmic calendar (multi-axis idle wobble + dashed orbit ring), DrawAction whiteboard (bristle brush + destination-out eraser + replay undo/redo, FBO), first-run guide with a Digital Wellbeing screen-time view; Brain_Shell Kanban/Tasks. Perf: gate `requestPaint` on `panel.visible`, cap to the focused popup (Iris Xe).
- Relates: existing applet items (clipboard_improvements, screenshot_recording_improvements, quick_tools_context_menu_super_x), and the work-first principle (#6) for Kanban.
- Deferred creative-shape option (ANALYSIS §16, CAELESTIA_BLOB_RESEARCH.md): the Caelestia blob system (SDF rounded-rects + `smin` goo-merge + spring squash) is a GLSL alternative to Canvas for a signature "liquid" viz/identity — single-rect SDF ~2-4h, full multi-rect merge ~2-3d. Kept deferred (we use Shape/Rectangle); note as an upgrade path if a hero-viz needs true shader-grade fluidity.

# Acceptance criteria
- AC1: A reusable Canvas hero-viz primitive (radial nodes + animated strands / decorative orbit), repaint gated on visibility, usable by the network/BT/workspace panels.
- AC2: A Digital Wellbeing (screen-time) applet.
- AC3: A Kanban/Tasks applet (to-do / ongoing / done, priority, deadlines) aligned with the work-first principle.
- AC4: A draw/annotation quick-action overlay (brush/eraser, undo/redo).

# Definition of Ready (DoR)
- [x] Problem statement is explicit and user impact is clear.
- [x] Scope boundaries (in/out) are explicit.
- [ ] Acceptance criteria are testable.
- [ ] Dependencies and known risks are listed.

# Companion docs
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# References
- `.claude/ANALYSIS.md` (§20.1 Canvas hero-viz; §20.2 Serpantinum/Brain_Shell applets; §20.3 recs 6/9)

# Backlog
- none
