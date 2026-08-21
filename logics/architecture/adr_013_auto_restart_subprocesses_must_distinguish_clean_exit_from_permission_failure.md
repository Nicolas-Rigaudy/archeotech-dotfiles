## adr_013_auto_restart_subprocesses_must_distinguish_clean_exit_from_permission_failure - Auto-restart subprocesses must distinguish clean exit from permission failure
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: busctl monitor org.bluez exits code 1 (Access denied) in user sessions, and an unconditional restart created an infinite crash-loop.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Only restart a monitored subprocess on clean exit, falling back to polling when the monitor is unavailable.

# Context
- Original onExited handler restarted unconditionally.
- busctl monitor exits with Access denied in normal user sessions.

# Decision
- Restart only on code === 0 (clean disconnect); fall back to a 3-second polling Timer when the monitor is unavailable.

# Consequences
- General lesson: any auto-restart on subprocess exit must distinguish clean exit from auth/permission failure.

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
