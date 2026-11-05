## item_165_dotfiles_idle_hook_swayidle_starts_the_shell_screensaver_before_the_lock - Dotfiles idle hook: swayidle starts the shell screensaver before the lock
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 0%
> Complexity: Low
> Theme: Ambient
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: dotfiles, idle, hook, swayidle, starts, shell, screensaver, before, lock
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Problem
- Idle detection stays in the dotfiles; swayidle must call the shell's screensaver IPC before locking.

# Scope
- In:
  - config/.config/swayidle/config.sh: a SCREENSAVER timeout calling `qs -c archeotech ipc call screensaver start`, resume calling stop, ordered before dim and lock.
  - Kitty fullscreen windowrule for terminal sources in mango and hyprland configs.
  - Animation tools listed as optional in docs/PACKAGES.md and install-packages.sh.
- Out:
  - Testing on the owner's live session (the owner checks it; isolated tests only).

# Acceptance criteria
- AC4: After the screensaver timeout the screensaver starts, input stops it, and the lock still follows at its own timeout on MangoWC and Hyprland.

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: After the screensaver timeout the screensaver starts, input stops it, and the lock still follows at its own timeout on MangoWC and Hyprland.

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed

# Links
- Product brief(s): `prod_005_screensaver_engine`
- Architecture decision(s): (none yet)
- Request: `req_012_screensaver_engine_pluggable_sources_settings_picker_and_idle_hook`
- Primary task(s): `task_077_orchestrate_the_screensaver_engine`

# Priority
- Priority: Medium
- Rationale: Set by scaffold input or defaulted for grooming.

# Executions
| When | Runner | Run id | Title | State | PR | Notes |
| --- | --- | --- | --- | --- | --- | --- |

