## task_030_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: Done
> Understanding: 90%
> Confidence: 85%
> Progress: 100%
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-10 16:16:54
> Owner: corvus

# AI Context
- Summary: Implement swappable faces on the shell's LARGE content surfaces (dashboard cards / panels) where layout genuinely varies and config can't express it. Primary seam = `DashCard._content`; reference targets = SystemStatus card (bars/gauges/compact) + MediaPanel (full/compact). Bar-widget faces are a secondary reuse of the same contract. Value-gated by a Wave-0 gauges spike. Verify headless via `HOME=/home/corvus ./scripts/shot.sh --state dashboard|media`.
- Keywords: swappable, faces, DashCard, SystemStatus, MediaPanel, gauges, WidgetRegistry, ConfigForm
- Use when: implementing the variant resolver, the face picker, or the reference faces.
- Skip when: theme-pack restyle (req_001); new widget types; DnD builder mechanics (item_022); motion (req_002).

# Implementation seams (archeotech-shell repo)
- PRIMARY surface — **dashboard cards / panels** (where faces earn their keep; config can't express these layout differences):
  - `Modules/Dashboard/panels/DashCard.qml` — shared card shell with a `default property alias _content: inner.data` slot. The face contract plugs in here: the card component owns the data + a content `Loader` whose `source` is the selected face; faces are pure presentation bound to the card's props.
  - `Modules/Dashboard/panels/SystemStatus.qml` — reference card A. Owns `cpu/ram/disk/bat` + the `Process` poller + a `StatRow` component (today's `bars` face). Split its presentation into faces `bars`/`gauges`/`compact`; keep the data/poller on the card.
  - `Modules/Shell/Panels/Content/MediaPanel.qml` — reference target B (bound to `MprisService`); faces `full`/`compact`.
  - `Modules/Shell/Panels/Content/Dashboard.qml` composes the cards; drive open via `shot.sh --state dashboard` / `--state media`.
- SECONDARY surface — bar widgets (reuse the same pattern, lower value):
  - `Services/Shell/WidgetRegistry.qml` — `widgetFile(id,isStrip)` + `_builtinSchemas`/`resolveConfig`; add `variantsFor`/`defaultVariant` + variant-aware resolve.
  - `Modules/Shell/Sides/WidgetLoader.qml` — `_applyOptional()` on `onConfigChanged` is the live hot-update seam; `Modules/Settings/Widgets/ConfigForm.qml` + `Modules/Shell/Builder/EditOverlay.qml` host the face-picker row.
- adr_010 (bar registry convention) · adr_022 (per-instance config). Verify with `HOME=/home/corvus ./scripts/shot.sh` (isolated nested session; never the live shell).

# Definition of Done (DoD)
- [x] The backlog scope is implemented.
- [x] Acceptance criteria are covered.
- [x] Validation passes.
- [x] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

# Backlog
- `item_100_swappable_widget_faces_and_skins`

# Acceptance criteria
- AC1: A host-agnostic face contract — a face declares `{id,file,label,constraints}`; a host resolves declared faces + renders the selected one via a content `Loader`, falling back to the default on unknown/absent id. Proven first on `DashCard._content`; the same pattern reusable by the bar `WidgetRegistry`. Verify: ≥2 declared faces resolve by id with clean default fallback.
- AC2: Face selection persists + hot-swaps live without a full remount (swap only the inner content source; keep the data-bearing shell + props mounted). Cards → minimal dashboard/card settings key (relates item_046); bar widgets → reserved `__face` per-instance config (adr_022) via ConfigForm/EditOverlay. Verify in isolation with `HOME=/home/corvus ./scripts/shot.sh`: switching a face updates the rendered surface and survives reload.
- AC3: Two multi-face reference targets on large surfaces: (a) **SystemStatus card** — `bars` / `gauges` / `compact` over the same cpu/ram/disk/bat data; (b) **MediaPanel** — `full` / `compact`. Verify each face renders headless via `HOME=/home/corvus ./scripts/shot.sh --state dashboard|media`.

# Plan
- Wave 0 — SPIKE (value proof, throwaway-friendly): build the **SystemStatus `gauges` face** and render it beside today's `bars` face headless (`shot.sh --state dashboard`) — WITHOUT changing the live default (default stays `bars`, live dashboard untouched). Decision gate: if the gauges swap reads as genuinely useful, proceed; if not, drop the framework rather than build it. [in progress this session]
- Wave 1 — Face contract on `DashCard` (AC1): give `DashCard` (or the card component) a `face` property + a content `Loader` that resolves declared faces `{id,file,label,constraints}` from a small per-card face list, defaulting cleanly. Keep the data/poller on the card component; faces are pure presentation bound to card props. This is the primary, high-value seam.
- Wave 2 — Reference faces (AC3): SystemStatus → `bars` (extract today's `StatRow` layout) + `gauges` (radial arcs) + `compact` (sparkline); MediaPanel → `full` + `compact`. Each face self-contained. Verify headless via `shot.sh --state dashboard|media`.
- Wave 3 — Persist + live swap (AC2): persist the card face choice in a minimal dashboard/card settings key (relates item_046, don't build the full grid); swap only the inner content source so the card shell + data props stay mounted (no flicker/reset). Confirm persistence across reload.
- Wave 4 — Picker UI (AC2): expose the face choice in the dashboard's edit affordance; then (secondary) wire the same contract into the bar path — `WidgetRegistry.variantsFor`/`defaultVariant` + `__face` in per-instance config + a face-picker row in `ConfigForm.qml` / `EditOverlay.qml`.
- Wave 5 — Docs + closeout: update `docs/WIDGET_API.md` (face contract) + adr_010; record validation, then `logics-manager flow finish task`.
- [x] Use `logics-manager flow progress task task_030_swappable_widget_faces_and_skins.md --progress <n>%` during multi-wave work.
- [x] Run `logics-manager flow finish task task_030_swappable_widget_faces_and_skins.md` after implementation.

# Validation
- Wave 0 SPIKE (value gate): rendered bars-vs-gauges preview headless — gauges confirmed genuinely useful on a roomy card (structurally different tree config can't express). User approved proceeding.
- Wave 1 (face contract + first faces): implemented in `archeotech-shell` (commit on `main`): `DashCard` gained a `faces`/`face` contract + inner `faceLoader`; `SystemStatus` now delegates presentation to faces `bars` (default, extracted verbatim) + `gauges`.
  - Regression: `shot.sh --state dashboard` (default) renders SystemStatus bars identical to pre-change; all other cards unaffected → backward-compatible contract confirmed.
  - Gauges: temporarily selected `face:"gauges"`, `shot.sh --state dashboard` rendered 2×2 radial gauges with live data, fully themed via Commons, no QML errors; reverted to default before commit.
  - `--qml` harness can't resolve the `Commons` singleton (only the full `-c` config does) — verified via the real config instead.
- Faces verified headless via shot.sh --state dashboard|media: SystemStatus gauges/bars/sparkline + MediaPanel full/compact each render; persistence load-path verified (config-inject → fresh session loads face); user-approved live 2026-09-10. No QML errors; config stays clean.
- Finish workflow executed on 2026-09-10.
- Linked backlog/request close verification passed.

# Report
- In progress (55%). Wave 0 (value gate) + Wave 1 (DashCard face contract) + Wave 2 SystemStatus half landed and verified headless.
  - SystemStatus now ships FOUR faces: `gauges` (default), `bars`, `sparkline` (auto-scaled trend), `compact` (dense numbers).
  - Polling: 1s cadence, visibility-gated (`running: _dashOpen`) — zero idle cost; history buffer (_histMax 60) feeds the sparkline. Chose in-memory + fast-warm over disk persistence (matches reference shells per ANALYSIS §20; they don't persist stat history).
  - Sparkline auto-scales to each series' own min/max with a span floor (flat series stay centered, not amplified).
- Wave 3 (persist) + Wave 4 (picker) DONE, then reworked on user UX feedback:
  - Switched from a header cycle-pill to **swipe the card body** (DragHandler, ≥40px horizontal, guarded against stray/warp events) + **page-dots** (tap a dot to jump). No header chrome — keeps the card uncluttered. Incoming face slides in (faceEnter). Choice persists under `dashboard.faces.<title>` in `Persistence.Config`, restores on load.
  - Verified persistence LOAD headlessly (inject config → fresh session loads that face; page-dot reflects it; config restored). Swipe/tap gesture itself isn't headless-testable (shot.sh injects no input); logic + persistence round-trip verified.
  - Found + fixed: headless renders were spuriously persisting a face (stray pointer event) — added no-op/relevance guards to `_selectFace` + the DragHandler; cleaned the user's real config; confirmed post-render config stays clean.
  - `sparkline` reworked to fill the card height (faceLoader fillHeight) so charts read as real trends, not stranded thin lines; cleaner line + end-dot + soft fill.
  - `compact` dropped (deleted the file) — a fixed-height bento card can't shrink, so compact can't earn its keep until item_046 (variable card sizes). Recoverable from git.
- SystemStatus now ships 3 faces: gauges (default) / bars / sparkline.
- UX polish round (user feedback): fixed sparkline OVERFLOW (its implicit height now ≈ gauges so switching never grows the card / overlaps the toolbar); livelier sparkline (span floor 12→6, buffer 60→40, ~1.3s/sample while open); added **touchpad two-finger swipe** (WheelHandler, accumulate + cooldown) alongside drag-swipe; replaced the fade transition with a **real two-loader carousel** (outgoing slides out while incoming slides in). Static render + config-clean + no-errors verified headless; the carousel MOTION and swipe/touchpad GESTURES can't be headless-tested (no input injection) — pending user live check.
- SystemStatus reference target (AC3-a) COMPLETE + user-verified live: gauges/bars/sparkline faces, drag-swipe + two-finger VERTICAL scroll (MangoWC drops horizontal scroll to layer surfaces — matched the proven Carousel.qml handler: vertical axis, pixelDelta for touchpad) + page-dot tap, two-loader carousel slide (stable order via bound current face), persisted choice, live 1s poll while dashboard open.
- AC3-b MediaPanel + FaceHost extraction DONE: extracted a reusable `Modules/Shell/FaceHost.qml` (the host-agnostic face contract — faces list + persistence + carousel slide + drag-swipe + vertical-scroll + page-dots) and used it for BOTH surfaces. MediaPanel now ships `full` (art+info+seek+transport) and `compact` (small art + inline transport) faces, persisted under `media.face`, verified rendering headless (forced available). Then MIGRATED `DashCard` onto FaceHost (−163 lines, no behaviour change — SystemStatus gauges/sparkline re-verified identical). AC1's "host-agnostic, reusable" claim is now literally proven (one component, two very different hosts).
- Pending: secondary bar-widget path (optional, lower value); Wave 5 docs (WIDGET_API + adr_010) + closeout.
- Finished on 2026-09-10.
- Linked backlog item(s): `item_100_swappable_widget_faces_and_skins`
- Related request(s): `req_003_swappable_widget_faces_and_skins`

# Links
- Request: `req_003_swappable_widget_faces_and_skins`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)

# AC Traceability
- request-AC1 -> This task. Proof: one shared `Modules/Shell/FaceHost.qml` resolves declared faces by id with clean default fallback, embedded in BOTH `DashCard` (SystemStatus) and `MediaPanel` — literally host-agnostic (adr_030). Each face resolves + renders headless via `shot.sh --state dashboard|media`.
- request-AC2 -> This task. Proof: choice persists in `Persistence.Config` (`dashboard.faces.<title>` / `media.face`), restored on load — verified headless (injected a face into config → fresh session came up on it, page-dot reflects it); live swap is a bound-Loader carousel, no full remount. User-verified live.
- request-AC3 -> This task. Proof: two reference targets shipped — SystemStatus (`gauges`/`bars`/`sparkline`) + MediaPanel (`full`/`compact`, panel resizes via `implicitPerp`); each face rendered headless via shot.sh and approved live.
