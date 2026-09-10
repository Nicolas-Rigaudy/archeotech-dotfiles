## task_030_swappable_widget_faces_and_skins - Swappable widget faces and skins
> From version: 1.0.0
> Schema version: 1.0
> Status: In progress
> Understanding: 90%
> Confidence: 85%
> Progress: 55%
> Complexity: Medium
> Theme: Widgets
> Reminder: Update status/understanding/confidence/progress and linked request/backlog references when you edit this doc.
> Indicators reviewed: 2026-09-10 10:18:33
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
- [ ] The backlog scope is implemented.
- [ ] Acceptance criteria are covered.
- [ ] Validation passes.
- [ ] Meaningful waves followed ADR 009: affected docs updated and the repo left commit-ready without automatic commits.

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
- [ ] Use `logics-manager flow progress task task_030_swappable_widget_faces_and_skins.md --progress <n>%` during multi-wave work.
- [ ] Run `logics-manager flow finish task task_030_swappable_widget_faces_and_skins.md` after implementation.

# Validation
- Wave 0 SPIKE (value gate): rendered bars-vs-gauges preview headless — gauges confirmed genuinely useful on a roomy card (structurally different tree config can't express). User approved proceeding.
- Wave 1 (face contract + first faces): implemented in `archeotech-shell` (commit on `main`): `DashCard` gained a `faces`/`face` contract + inner `faceLoader`; `SystemStatus` now delegates presentation to faces `bars` (default, extracted verbatim) + `gauges`.
  - Regression: `shot.sh --state dashboard` (default) renders SystemStatus bars identical to pre-change; all other cards unaffected → backward-compatible contract confirmed.
  - Gauges: temporarily selected `face:"gauges"`, `shot.sh --state dashboard` rendered 2×2 radial gauges with live data, fully themed via Commons, no QML errors; reverted to default before commit.
  - `--qml` harness can't resolve the `Commons` singleton (only the full `-c` config does) — verified via the real config instead.

# Report
- In progress (55%). Wave 0 (value gate) + Wave 1 (DashCard face contract) + Wave 2 SystemStatus half landed and verified headless.
  - SystemStatus now ships FOUR faces: `gauges` (default), `bars`, `sparkline` (auto-scaled trend), `compact` (dense numbers).
  - Polling: 1s cadence, visibility-gated (`running: _dashOpen`) — zero idle cost; history buffer (_histMax 60) feeds the sparkline. Chose in-memory + fast-warm over disk persistence (matches reference shells per ANALYSIS §20; they don't persist stat history).
  - Sparkline auto-scales to each series' own min/max with a span floor (flat series stay centered, not amplified).
- Pending: MediaPanel `full`/`compact` (AC3 second reference target); then Wave 3 persist face choice, Wave 4 picker UI.

# Links
- Request: `req_003_swappable_widget_faces_and_skins`
- Product brief(s): (none yet)
- Architecture decision(s): (none yet)
