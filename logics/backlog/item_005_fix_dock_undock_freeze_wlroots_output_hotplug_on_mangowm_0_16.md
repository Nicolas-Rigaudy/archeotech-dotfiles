## item_005_fix_dock_undock_freeze_wlroots_output_hotplug_on_mangowm_0_16 - Fix dock-undock freeze (wlroots output-hotplug) on mangowm 0.16
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: High
> Theme: Stability
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.
> Indicators reviewed: 2026-08-20 17:08:28

# AI Context
- Summary: The undock-freeze bug. Investigation 2026-09-04 found the documented mango output-teardown crash family (#1208/#1230/#1149) was fixed in mango 0.16.0 (commit 8169bfc); we run 0.16.2 = already patched. wlroots 0.20.x point releases carry no output-teardown fix (fix was mango-side). Remaining unknown: our symptom is a *hang* not a *crash* — a different, undocumented signature possibly rooted in kernel i915/DRM. Full findings + verification protocol in `.claude/TROUBLESHOOTING.md` (MangoWC Issues).
- Keywords: fix, dock, undock, freeze, wlroots, output, hotplug, mangowm
- Use when: The compositor hangs/crashes on dock removal or suspend/resume with external outputs.
- Skip when: Investigating the layout re-apply on hotplug (that is task_015 / monitor-hotplug.sh, which assumes the compositor survives the event).

# Problem
- Unplugging the dock hangs MangoWC completely (even laptop kbd/trackpad dead); wlroots output-hotplug hang; distribution-blocking for laptop+dock users

# Scope
- In:
  - Verify whether mangowm->wlroots 0.20.2 update resolves it; record in DECISIONS or file upstream report
- Out:
  - Patching wlroots itself

# Acceptance criteria
- AC4: Dock-undock no longer freezes the compositor, or a robust fallback path is confirmed

# AC Traceability
- request-AC4 -> This backlog slice. Proof: AC4: Dock-undock no longer freezes the compositor, or a robust fallback path is confirmed

# Decision framing
- Product framing: Not needed
- Architecture framing: Not needed
- Finding (2026-09-04): Documented crash family fixed in mango 0.16.0; current stack (0.16.2 + wlroots 0.20.2) already carries the fix. wlroots update was a red herring (no output-teardown fix in 0.20.x — fix was mango teardown-order commit 8169bfc). Cannot close: our symptom is a hang, not the documented crash, and hardware repro (physically unplug dock → session crash risk) has not been run on the current stack. Blocked on a user dock-test using the verification protocol in TROUBLESHOOTING.md. AC4's "robust fallback path" candidate = pre-undock `wlr-randr --off` of external outputs.
- Resolution (2026-09-07): Hardware repro RUN on the current stack (mango 0.16.2 + wlroots 0.20.2 + kernel 7.2.2, dual external HDMI-A-1 + DP-3 + eDP-1). Multiple raw dock unplugs — no freeze, no hang, no crash. AC4 first branch satisfied: dock-undock no longer freezes the compositor. Confirms the upstream mango 0.16.0 teardown-order fix (8169bfc) resolves the item_005 symptom on this hardware. No shell/script change required; the pre-undock `wlr-randr --off` safe-undock fallback was NOT needed and is not built. Closing.

# Links
- Product brief(s): `prod_001_archeotech_shell`
- Architecture decision(s): (none yet)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): `task_001_orchestrate_archeotech_shell_delivery`

# Priority
- Priority: High
- Rationale: Set by scaffold input or defaulted for grooming.
