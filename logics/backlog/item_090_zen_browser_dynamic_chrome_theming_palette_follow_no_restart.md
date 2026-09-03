## item_090_zen_browser_dynamic_chrome_theming_palette_follow_no_restart - Zen browser dynamic chrome theming palette follow no restart
> From version: 1.0.0
> Schema version: 1.0
> Status: Draft
> Understanding: 55
> Confidence: 55
> Progress: 0
> Complexity: Medium
> Theme: Theming
> Reminder: Update status/understanding/confidence/progress and linked request/task references when you edit this doc.

# AI Context
- Summary: Make the Zen browser CHROME follow the shell palette DYNAMICALLY (no restart). Today `theme-switch.py` only writes a restart-based workspace gradient; this adds live chrome theming. Researched-but-unbuilt in ROADMAP.archived (Zen dynamic-theming avenues, 2026-07-01).
- Keywords: zen, firefox, chrome, theming, palette, pywalfox, userchrome, no-restart
- Use when: wiring palette -> Zen chrome; extending theme-switch.py Zen integration.
- Skip when: the workspace-gradient write (separate, needs the `zen_workspaces` DB write); non-Zen apps.

# Problem
- Zen chrome only follows the palette via a restart-based gradient write — no dynamic, no-restart chrome theming. The ecosystem-standard approach (Firefox Theme API) does exactly this. Note: gradient-vs-external-palette is a real tradeoff in every mechanism.

# Scope
- In:
  - Evaluate + implement ONE avenue: (a) Firefox Theme API via a WebExtension (Pywalfox model — a native-messaging host fed a color file that theme-switch.py writes; applies chrome colors with no restart / no userChrome CSS), OR (b) `userChrome.js` live-reload (poll CSS + re-register via `nsIStyleSheetService` + `chrome-flush-caches`, needs an fx-autoconfig loader) to kill the restart requirement.
  - Keep the existing workspace-gradient path; document the gradient-vs-palette tradeoff.
- Out:
  - Rebuilding the `zen_workspaces` gradient write; the `zen.theme.accent-color` pref (tried 2026-07-01, no visible effect with a gradient set).

# Acceptance criteria
- AC1: Zen chrome colours update to match the active palette WITHOUT a browser restart.
- AC2: `theme-switch.py` drives it from the same token source as the rest of the shell.
- AC3: Coexists with the workspace gradient (documented tradeoff/limitation).

# AC Traceability
- request-AC1 -> This backlog slice. Proof: extends theming coherency / cross-app consistency (req_000 AC1) to dynamic Zen chrome.

# Decision framing
- Product framing: Not needed
- Architecture framing: relates adr_004 (token singleton + Python applier — Zen becomes another applier target). Refs: Pywalfox (Firefox Theme API model), PywalZen (archived/broken — "overrides custom gradients").

# Links
- Product brief(s): (none yet)
- Architecture decision(s): relates adr_004 (theme applier targets)
- Request: `req_000_archeotech_shell_dotfiles`
- Primary task(s): (none yet)

# Priority
- Priority: Medium
- Rationale: Default until groomed.

# Notes
- Generated locally by logics-manager.
