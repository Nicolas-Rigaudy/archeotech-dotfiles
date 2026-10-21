## task_069_glass_themed_system_tray_context_menu_tooltip - Glass-themed system-tray context menu + tooltip
> From version: 1.0.0
> Schema version: 1.0
> Status: Ready
> Understanding: 90%
> Confidence: 85%
> Progress: 80%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: glass, themed, system, tray, context, menu, tooltip
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_039_glass_themed_system_tray_context_menu_tooltip`

# Acceptance criteria
- AC2: Tray items open a glass-themed context menu and show a hover tooltip

# Plan
- [ ] Use `python3 -m logics_manager flow progress task task_069_glass_themed_system_tray_context_menu_tooltip.md --progress <n>%` during multi-wave work.
- [ ] Run `python3 -m logics_manager flow finish task task_069_glass_themed_system_tray_context_menu_tooltip.md` after implementation.

# Validation
- command: tests/py (new test_tray_menu.py), tests/run.sh, qmllint-ci unchanged; headless renders against a fake StatusNotifierItem (tests/tools/fake-sni.py via shot.sh --exec + `ipc call popup open tray`) in dark and light, with a submenu expanded (cr-0w/local/state/night/shots/039-tray) | result: renders pass; NOT verified in a real session | date: 2026-10-21

# Report
- Landed b364805 on shell branch night/roadmap-next. TrayMenu (PopupWindow, grabFocus) + TrayMenuList draw the DBusMenu with the card material: separators, disabled rows, check/radio marks, icons (only when the theme has them), submenus expanded in place, Esc/click-away close. The window opens once its entries arrive (a popup cannot grow after it is shown). Hover shows the bar's usual hover card with the item's tooltip title/description. tests/tools/fake-sni.py is a fake tray app for renders. Found on the way: a self-instantiating inline component removes the whole widget ("instantiated recursively"), so submenus load by URL, guarded by a test.
- NEEDS THE OWNER (by hand, on the live bar): right-click a real tray icon. Headless renders cannot grab input, so the popup's real positioning under the icon, click-away dismissal and the focus grab are unverified; keyboard up/down navigation inside the menu is not built. If the real menu misbehaves the one-line revert is restoring QsMenuAnchor in TrayWidget.qml.

# Links
- Request: `req_005_2026_09_28_audit_upgrade_program`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
