## item_185_shell_polkit_agent_styled_password_prompt_above_panels - Shell polkit agent: styled password prompt above panels
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: shell
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: shell, polkit, agent, styled, password, prompt, above, panels
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Deliver a bounded backlog slice for shell polkit agent: styled password prompt above panels.

# Scope
- In:
  - one coherent delivery slice from the operator request.
- Out:
  - unrelated sibling slices.

# Acceptance criteria
- AC1: The backlog slice stays bounded for shell polkit agent: styled password prompt above panels.
- AC2: The backlog slice is reviewable and promotable into a task.

# AC Traceability
- request-AC1 -> This backlog slice. Proof: bounded delivery slice.
- request-AC2 -> This backlog slice. Proof: promotable backlog item.
- request-AC3 -> This backlog slice. Proof: delivery chain includes a task-ready backlog item.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Found 2026-11-24 testing Storage cleanup: pkexec had no polkit agent under mango (no XDG autostart; polkit-kde-agent now started by exec_once in mango config.conf). The KDE prompt opens behind layer-shell panels (the Storage panel covers it) and does not match the shell look. Build a shell agent with Quickshell.Services.Polkit (PolkitAgent + AuthFlow: message, inputPrompt, submit, cancelAuthenticationRequest, failed, supplementaryMessage) drawn on the overlay layer with MetalSurface styling; then remove the KDE exec_once line (one agent per session). Owner chose: later, after Storage lands.

# Links
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
- Request: (to be linked)
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |
