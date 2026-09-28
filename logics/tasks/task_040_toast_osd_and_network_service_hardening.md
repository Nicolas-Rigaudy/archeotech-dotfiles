## task_040_toast_osd_and_network_service_hardening - Toast, OSD and network service hardening
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: claude
> Indicators reviewed: 2026-09-28 15:58:27

# AI Context
- Summary: Toast queue becomes a ListModel with stable uids (no timer resets) on the focused output; nmcli monitors get exponential backoff and a debounce; the Wi-Fi password goes to nmcli --ask on stdin instead of argv.
- Keywords: toast, osd, network, service, hardening
- Use when: Touching the toast layer in shell.qml, Network.qml/VPN.qml monitors, or the Wi-Fi connect path.
- Skip when: Migrating to Quickshell.Networking (separate item); OSD placement (already focused-output only in Osd.qml:14).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_108_toast_osd_and_network_service_hardening`

# Acceptance criteria
- AC1: Each toast honours its own timeout and appears on the focused monitor.
- AC2: With NetworkManager stopped, CPU use stays flat.
- AC3: No secret appears in any process command line.

# Plan
- [x] 1. A/B probe on unfixed main: toast delegate creations and per-toast expiry times under a 5-toast burst.
- [x] 2. shell.qml: ListModel + uid removal; toast window screen = focused output at latest arrival; maxToasts trim on the model.
- [x] 3. Network.qml/VPN.qml: nmcli monitor backoff (1s -> 30s, reset after 10s up); Network monitor lines debounced 300ms.
- [x] 4. Network.qml: connectWithPassword via argv-only nmcli --ask, secret on stdin, stdin closed after write.
- [x] 5. Fake-nmcli harness A/B: monitor spawn count without NetworkManager; secret absent from argv.
- [x] 6. qml-reviewer on the worktree diff; land on main by path; closeout.
- [x] Use `python3 -m logics_manager flow progress task task_040_toast_osd_and_network_service_hardening.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_040_toast_osd_and_network_service_hardening.md` after implementation.

# Validation
- Toast timers (shot.sh --set notifications.toastTimeout=3000 --notify-count 5 --burst 8 -i 1, PROBE logs in NotifToast): unfixed main 25 delegate creations, last toast gone at +16.6s; fix 5 creations, each expires 3.0s after creation. maxToasts=2 + 4 notifications: 4 creations, newest 2 shown. Focused output (new shot.sh --outputs 2 --exec, mmsg get all-layers): main put toast B on HEADLESS-2 after focus moved to HEADLESS-1; fix puts B on HEADLESS-1 and A stays on HEADLESS-2. Network (fake nmcli on PATH, monitor exits at once, harness calls connectWithPassword): main 5108 monitor spawns in 20s and argv 'dev wifi connect Cafe Wifi password <pw>'; fix 5 spawns at +0/1/3/7/15s, argv '--ask dev wifi connect Cafe Wifi', secret received on stdin then EOF. Qt6 qmllint: only known false positives. qml-reviewer: blocking (shared toast window jumped screens) fixed by per-screen Variants windows, re-verified.
- command: `shot.sh toast burst + 2-output A/B; fake-nmcli harness A/B; qmllint; qml-reviewer` | result: passed | date: 2026-09-28
- Finish workflow executed on 2026-09-28.
- Linked backlog/request close verification passed.

# Report
- Landed on archeotech-shell main as 436dc27 (shell.qml, Services/Networking/Network.qml, VPN.qml, scripts/shot.sh). Toasts: one PanelWindow per screen (Variants, like Osd), each with its own ListModel of uid rows; a toast joins the focused output's window and never moves. OSD was already focused-output only (Osd.qml:14). nmcli monitors: backoff 1s->30s, reset after 10s up; Network monitor lines debounced 300ms. Wi-Fi PSK: nmcli --ask with the secret on stdin, stdin closed after the write. shot.sh gains --outputs N and --exec CMD. Owner check pending: joining a real password-protected network from the Wi-Fi panel (the fake nmcli cannot prove real nmcli reads the piped secret). Side finding, not fixed: MangoService _scheduleRestart never backs off (each timer resets interval to 500 on trigger, so every retry waits 1s).
- Finished on 2026-09-28.
- Linked backlog item(s): `item_108_toast_osd_and_network_service_hardening`
- Related request(s): `req_005_2026_09_28_audit_upgrade_program`

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC2 -> This task. Proof: three audit-verified bugs fixed in archeotech-shell 436dc27 - toast timer resets (A/B 25 vs 5 delegate creations, per-toast 3.0s expiry), toasts on the wrong output (2-output A/B via mmsg get all-layers), nmcli monitor respawn spin (5108 vs 5 spawns/20s) - and the Wi-Fi secret moved off argv. Other AC2 bugs and the golden matrix are sibling items.
