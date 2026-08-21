## item_069_ai_persona_testers_verify_before_done_loop - AI persona-testers + verify-before-done loop
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
- Summary: Adapts the UXAgent persona-tester architecture to the shell (screenshot + a11y-tree + qs ipc connector) and formalizes the verify-before-done loop before claiming a visual change complete.
- Keywords: persona, testers, verify, before, done, loop
- Use when: Working on persona-tester judgment logic, the a11y/screenshot connector, or the verify-before-done checklist/process.
- Skip when: Working on the render harness or CI/regression mechanics themselves (see item_067, item_068).

# Problem
- Visual changes are sometimes claimed "done" without ever being rendered or diffed, causing a "claimed done but wrong" back-and-forth.
- There is no static-UX judgment layer (clarity/contrast/discoverability/wording) beyond a human eyeballing a screenshot.
- Motion/feel cannot be judged from a still frame, so any persona-tester or verify step needs an explicit limit on what it can and cannot claim.

# Scope
- In:
  - AI persona-tester adapted from UXAgent architecture: Persona Generator + LLM Agent + a connector swapping UXAgent's browser hook for screenshot + a11y-tree + `qs ipc`
  - Judgment scope limited to static UX (clarity, contrast, discoverability, wording), using UXBench's actionability lens to keep findings triageable
  - A verify-before-done loop: drive state -> render (item_067) -> diff or inline image (item_068) -> only then mark done, image attached
- Out:
  - The render harness and state-driving mechanics (item_067)
  - Golden diffing and CI wiring (item_068)
  - Any claim about motion smoothness/fps from a still frame (explicitly out of scope, flagged instead)

# Acceptance criteria
- AC1: A persona-tester run produces a triageable finding (not a blanket unfocused sweep) for at least one static UX dimension on a real panel.
- AC2: The verify-before-done loop is documented and followed: no visual change is marked done without a rendered/diffed image attached.
- AC3: Any motion-related claim is explicitly flagged as unverified-by-persona rather than silently asserted.

# AC Traceability
- request-AC6 -> This backlog slice. Proof: persona-testers and the verify-before-done loop are the B6/B7 blocks of milestone 0.28's testing pipeline.

# Priority
- Priority: Medium
- Rationale: The ambitious top layer of 0.28, built last on top of the harness (item_067) and regression tooling (item_068).

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
