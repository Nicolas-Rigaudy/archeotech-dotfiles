## item_044_workspace_indicators_3d_polish - Workspace indicators 3D polish
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Low
> Theme: Polish
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: Give WorkspacesWidget tag dots real visibility/contrast + a raised-glass 3D read in glass mode; delivered.
- Keywords: workspace, indicators, polish, tag-dots, sheen, glass, 3d
- Use when: Touching WorkspacesWidget bead styling or per-state (empty/occupied/selected) contrast.
- Skip when: Changing tag/workspace switching logic (out of scope).

# Problem
- Workspace indicators lack visibility/contrast and a real 3D look in non-flat mode

# Outcome (2026-09-11)
- Delivered in archeotech-shell commit `e94770f` (WorkspacesWidget.qml). Glass mode now gives each bead a raised-glass read via three levers (the token sheen alone was too subtle at dot size): a `RectangularShadow` lift, a top-lit `sheen.knob` gradient, and a specular gloss cap.
- Per-state hierarchy tuned live with the user: empty = dim + matte `surface1` (delineated by soft shadow, no hard border), occupied = brighter + glossy `overlay1` (differs from empty on both brightness and sheen), selected = accent pill with a softened gloss cap. Steel packs keep their metal shading; depthFlat collapses all depth cues.
- Verified empty/selected headless via shot.sh; occupied state eyeballed live by the owner (un-mockable headless — only one window in the isolated session).

# Scope
- In:
  - More visibility/contrast + 3D treatment in WorkspacesWidget when non-flat mode is on
- Out:
  - Reworking workspace logic

# Acceptance criteria
- AC5: Workspace indicators read clearly with a 3D look in glass mode

# AC Traceability
- request-AC5 -> This backlog slice. Proof: AC5: Workspace indicators read clearly with a 3D look in glass mode

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
- Rationale: Set by scaffold input or defaulted for grooming.
