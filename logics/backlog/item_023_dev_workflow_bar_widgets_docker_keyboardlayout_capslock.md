## item_023_dev_workflow_bar_widgets_docker_keyboardlayout_capslock - Dev-workflow bar widgets (Docker/KeyboardLayout/CapsLock)
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Medium
> Theme: Dev workflow
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: dev, workflow, bar, widgets, docker, keyboardlayout, capslock
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Sprint 28 covers git/AWS/terraform; Docker/keyboard-layout/capslock widgets remain

# Scope
- In:
  - DockerWidget (containers badge -> btop/lazydocker), KeyboardLayoutWidget (QWERTY/AZERTY from mango state), CapsLockWidget
- Out:
  - The core dev-workflow git/AWS/TF widgets (Sprint 27)

# Acceptance criteria
- AC2: Docker, keyboard-layout, and caps-lock bar widgets exist per the widget registry

# AC Traceability
- request-AC2 -> This backlog slice. Proof: AC2: Docker, keyboard-layout, and caps-lock bar widgets exist per the widget registry
- request-AC3 -> This backlog slice. Proof: AC2: Docker, keyboard-layout, and caps-lock bar widgets exist per the widget registry

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Audit 2026-08-21: PARTIAL — keyboard-layout wiring exists (delivered); remaining: Docker + CapsLock widgets. Keep Ready.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.
