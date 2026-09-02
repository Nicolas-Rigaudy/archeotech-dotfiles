## task_016_compositorservice_facade_mango_hyprland_service_extraction - CompositorService facade + Mango/Hyprland service extraction
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Implementation delivery
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Owner: corvus
> Indicators reviewed: 2026-09-02 14:41:47

# AI Context
- Summary: (unfilled: replace before this doc is used)
- Keywords: compositorservice, facade, mango, hyprland, service, extraction
- Use when: (unfilled: replace before this doc is used)
- Skip when: (unfilled: replace before this doc is used)

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_070_compositorservice_facade_mango_hyprland_service_extraction`

# Acceptance criteria
- AC1: No QML file calls `mmsg` directly outside `MangoService.qml`; all 11 former call sites go through `CompositorService`.
- AC2: `HyprlandService` implements the same facade API as `MangoService` using `Quickshell.Hyprland` where available.
- AC3: Switching the active compositor at startup changes which service backs `CompositorService` with no widget-level code changes.

# Plan
- [x] Use `python3 -m logics_manager flow progress task task_016_compositorservice_facade_mango_hyprland_service_extraction.md --progress <n>%` during multi-wave work.
- [x] Run `python3 -m logics_manager flow finish task task_016_compositorservice_facade_mango_hyprland_service_extraction.md` after implementation.

# Validation
- (no validation recorded yet)
- command: `qmllint (facade+backends+8 call sites, clean); headless shot.sh renders — mango backend shows workspace tags, HYPRLAND_INSTANCE_SIGNATURE-forced render selects HyprlandService with MangoService inert + no QML errors; grep-verified mmsg isolated to MangoService.qml and API parity` | result: passed | date: 2026-09-02
- Finish workflow executed on 2026-09-02.
- Linked backlog/request close verification passed.

# Report
- Not started.
- Finished on 2026-09-02.
- Linked backlog item(s): `item_070_compositorservice_facade_mango_hyprland_service_extraction`
- Related request(s): `req_000_archeotech_shell_dotfiles`

# Links
- Request: `req_000_archeotech_shell_dotfiles`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC4 -> This task. Proof: Added CompositorService.qml facade + extracted MangoService.qml (self-gated so inert under Hyprland) + new HyprlandService.qml on Quickshell.Hyprland; routed all MangoWC call sites (Osd, ShellPane, shell.qml, TitleWidget, WorkspacesWidget, LayoutPickerBody, WindowBrackets) through the facade. AC1: mmsg now appears only in MangoService.qml (grep-verified). AC2: both backends expose identical 9-method+focusedOutput surface (grep-verified); HyprlandService loaded error-free under a forced-Hyprland render. AC3: headless render with HYPRLAND_INSTANCE_SIGNATURE set selected HyprlandService (hyprland-socket warning), MangoService stayed inert (no mmsg), shell rendered unchanged with no QML errors; default render still shows mango workspace tags. qmllint clean; live session survived. Implemented in archeotech-shell 074235e + a38d858. Source: `074235e`
