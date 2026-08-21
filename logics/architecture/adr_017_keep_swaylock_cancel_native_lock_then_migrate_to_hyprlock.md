## adr_017_keep_swaylock_cancel_native_lock_then_migrate_to_hyprlock - Keep swaylock (cancel native lock), then migrate to hyprlock
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: The only real gap in swaylock was theme-following colors; a broken WlSessionLock native lock risks locking the user out with no recovery.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Cancel the native QML lock, close the theming gap by making the lock a theme-switch.py target, and later migrate to hyprlock after a resume-freeze bug.

# Context
- Sprint 23 built a native WlSessionLock + PamContext lock, then cancelled it before shipping — swaylock is battle-tested and the user is happy with it.
- A broken WlSessionLock locks you out of the session with no in-session recovery.
- Later, a recurring resume freeze was diagnosed as swaylock (jirutka's unmaintained swaylock-effects fork) segfaulting on output-hotplug-during-resume — a known longstanding sway-ecosystem bug, not a config error.

# Decision
- Cancel the native lock (delete the QML, recoverable from git) and add swaylock as a theme-switch.py target so its colors follow theme switches.
- Move to upstream swaylock 1.8.5 as an interim, de-effecting the config; then ship hyprlock as the real fix (separate maintained codebase, restores blur + clock).
- Generate hyprlock.conf from a template via theme-switch.py, indirect the wallpaper through a stable ~/.cache/wallpaper/current symlink, and keep label commands in scripts/hyprlock-info.sh; keep swaylock as a documented fallback.

# Consequences
- Lock UI is a separate stack (not shell QML components); WlSessionLock + PamContext remain confirmed-working if ever revisited.
- hyprlock is a separate process with no live QML/IPC, so a future Lock Screen Settings pane is a config generator, not QML widgets on the lock surface.
- The slow wrong-password response is PAM pam_unix fail-delay, left as the safe default.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
