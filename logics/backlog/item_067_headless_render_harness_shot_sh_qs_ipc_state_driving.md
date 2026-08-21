## item_067_headless_render_harness_shot_sh_qs_ipc_state_driving - Headless render harness (shot.sh + qs-ipc state-driving)
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
- Summary: Delivers the safety-fixed headless render-to-PNG harness (shot.sh), qs-ipc state-driving, and temporal/burst capture for motion correctness.
- Keywords: headless, render, harness, shot, ipc, state, driving
- Use when: Working on headless rendering, the nested-compositor teardown, or driving shell state via qs ipc for verification.
- Skip when: Working on golden-image diffing, QML logic tests, or CI wiring (see item_068), or on persona-tester logic (item_069).

# Problem
- There is no automated way to render the shell to an image for verification; changes are eyeballed live, which is slow and error-prone before claiming "done."
- The proven headless-render approach (`WLR_BACKENDS=headless mango -s` + `qs -c archeotech` + `grim`) exists only as an ad hoc proof, not a safe, reusable script.
- A prior harness run killed the user's real session by tearing down the nested compositor with `pkill -x mango`/`pkill quickshell`, matching the real session by name.

# Scope
- In:
  - `shot.sh`: headless render-to-PNG using the nested `WLR_BACKENDS=headless` compositor + `grim`, with teardown strictly by captured PID (never by process name)
  - qs-ipc state-driving: drive shell state into a target screen (launcher/settings/dashboard/wallpaper/media/editmode/osd/theme/notifications) via existing IPC handlers before capture
  - Temporal/burst capture (repeated grim shots) to verify motion correctness (played/duration/oscillation) short of smoothness/fps
- Out:
  - Golden-image diffing and QML logic tests (item_068)
  - CI container wiring (item_068)
  - AI persona-tester judgment logic and the verify-before-done workflow itself (item_069)

# Acceptance criteria
- AC1: `shot.sh` renders the shell headless to a real PNG and tears down the nested compositor by captured PID only, never touching the live session.
- AC2: A named shell state (e.g. launcher open, dashboard open) can be driven via `qs ipc` before capture, without synthetic input.
- AC3: A burst capture produces a sequence of frames sufficient to confirm a motion state changed (e.g. a toast appeared and later dismissed).

# AC Traceability
- request-AC6 -> This backlog slice. Proof: the headless render harness and state-driving are the foundational block (B1/B1b/B2) of milestone 0.28's testing pipeline.

# Priority
- Priority: High
- Rationale: Every other 0.28 deliverable (regression diffing, CI, persona testers) depends on this harness existing and being safe to run.

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
