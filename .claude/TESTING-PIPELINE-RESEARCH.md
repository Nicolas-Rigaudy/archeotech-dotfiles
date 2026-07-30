# Testing & Dev Pipeline Research

**Goal:** ship + test archeotech-shell features faster and with higher quality before it
goes public; cut the redundant back-and-forth; let Claude *visually verify* its own
changes so "done" means done; and eventually run AI persona-testers over the UI.

**Method:** incremental, block-by-block. Each block is grounded in *this* machine's real
setup (verified with commands, not generic advice) and written here as it's done, so
nothing is lost to a session crash.

**Environment (verified 2026-07-30):**
- Shell: `qs -c archeotech` → `~/.config/quickshell/archeotech` → `~/Projects/archeotech-shell`.
- Compositors installed: `mango` (MangoWC, wlroots) + `Hyprland`. Both honor `WLR_BACKENDS=headless`.
- Capture: `grim` + `slurp` present. Software render: `WLR_RENDERER=pixman` + Qt `offscreen` plugin.
- QML toolchain: `qmltestrunner`, `qml`, `qmlscene`, `qmlformat` all present.
- Missing: synthetic-input tools (`wtype`/`ydotool`/`wlrctl`) — drive state via IPC instead (`mmsg`, `qs ipc`).
- Sandbox note: Claude's `$HOME` is the `digital` profile; the real config is under `/home/corvus`.
  Run harness with `HOME=/home/corvus` so `qs -c archeotech` resolves.

---

## Block 1 — Visual verification loop  ✅ PROVEN (2026-07-30)

**Claim:** the shell can be rendered on a headless nested compositor and captured to a PNG,
with no physical display — so a tool (Claude) or CI can *see* the real rendered output.

**Proof:** ran `WLR_BACKENDS=headless mango -s '<startup>'` where the startup launched
`qs -c archeotech` and, after settle, `grim shot.png`. Result: a valid **1280×720 PNG of the
full shell** — top bar, music widget, clock, tray icons, wallpaper — pixel-correct. Software
rendering (pixman) was enough; no GPU required.

**How it works:**
- `mango -s <cmd>` runs `<cmd>` as a startup inside a fresh nested session; that session gets
  its own `WAYLAND_DISPLAY`, so `grim` (run *inside* it) grabs the nested output, never the
  real screen.
- `qs -c archeotech` loads the live config; `qs -p <file.qml>` can load a single file (→ Block 2).
- Headless default output is `HEADLESS-1` @ 1280×720; `wlr-randr --output HEADLESS-1
  --custom-mode WxH` can resize (not yet verified).

**Reusable script:** `archeotech-shell/scripts/shot.sh` (written, NOT yet re-run after the
safety fix). `shot.sh [out.png]`, `shot.sh --qml <file> [out]`, `-w <settle-seconds>`.

**⚠️ SAFETY (learned the hard way today):** teardown must kill the nested compositor by its
captured PID, **never** `pkill -x mango` / `pkill quickshell` — those match the *real* session
compositor/shell and log you out, losing all work. `shot.sh` now kills only `$MANGO_PID`.
See memory `never-kill-mango-by-name`.

**Open items for Block 1:**
- [ ] Re-run `shot.sh` after the safety fix to confirm the generalized script works (needs user OK).
- [ ] Verify custom resolution via `wlr-randr` (to shoot at real monitor sizes).

---

## Block 1b — Temporal capture (motion/speed/jitter) + its HARD LIMITS  (2026-07-30)

**Why this matters most:** the pre-1.0 push is about *motion & feel* (M3 motion tokens,
launcher enter/exit, liquid glass). A static PNG (Block 1) verifies static state ONLY — it
says nothing about duration, easing, smoothness, or jitter.

**Tooling on this machine (verified):** `ffmpeg` ✅, `grim` ✅ (single-shot only), `wf-recorder`
❌, `wl-screenrec` ❌, OBS ❌. No wlroots video recorder installed yet.

**What headless capture CAN verify — *correctness* of motion:**
- **grim burst loop** (shot every ~20–50ms during an animation) → coarse frame sequence.
  Confirms: animation played, start/end states, approx duration/sequencing, and *gross
  oscillation* (e.g. the `layer.enabled` hover-jitter bug flips frames back and forth).
  NOT true 60fps (grim per-shot startup cost).
- **Declared spec is static** — QML durations/easing are literals in `Commons/Appearance.qml`
  + `Commons/Anim.qml`. "Is the duration/curve what I intended" needs zero runtime.

**What headless CANNOT verify — *quality* of motion (the boundary):**
- Perceived smoothness, real fps, dropped frames, GPU-load jitter, blur/glass perf.
- **Reason:** headless = `WLR_RENDERER=pixman` *software* rendering. Its frame timing is
  unrelated to the real Intel/Mesa GPU under real load. A perfect headless recording proves
  nothing about real-world smoothness.

**Consequence for the whole pipeline:** automated headless = motion *correctness*; motion
*feel* must come from (a) recording the **real live session** (needs `wf-recorder`, one
`pacman -S` away) or (b) **human / persona eyes**. This is a real division of labor, not a
gap to engineer away — it's where Block 6 (personas) + the user's own eyes stay essential.

---

## Block 2 — Isolate the STATE, not the file  (2026-07-30)

**Finding that flips the plan:** widgets import `"../../Commons"`, `"../../Services/*"` and
depend on singletons (`Appearance`, `ColorScheme`, services). So `qs -p SingleWidget.qml` in
true isolation is impractical — the file needs the whole context/singleton graph. Chasing
single-file "stories" (Storybook-style) = high effort, low fidelity.

**Better, and cheaper:** run the *full* shell (`qs -c archeotech`) headless (Block 1) and drive
it into the target STATE via IPC — no synthetic input needed (we have none anyway).

**Drivers available (verified):**
- **`qs ipc`** — the shell registers `IpcHandler` targets in `shell.qml`: `theme`,
  `notifications`, `launcher`, `settings`, `dashboard`, `wallpaper`, `media`, `editmode`,
  `osd`. So e.g. `qs -c archeotech ipc call launcher toggle` opens the launcher; likewise
  settings/dashboard/etc. This reaches almost every panel state from the CLI.
- **`mmsg`** (MangoWC IPC) — compositor state: `-s` set tags/layout, `-d <cmd>,<args>` dispatch,
  `-w` watch events, `-O` outputs. Drives workspace/focus/layout around the shell.

**Recipe:** headless mango → `qs -c archeotech` → `qs ipc call <target> <fn>` → settle → `grim`.
Deterministic, no clicking.

**Cheap next step (deferred, read-only):** read the `IpcHandler` bodies in `shell.qml` to list
the exact callable functions/args per target → a state cookbook.

---

## Block 3 — Visual regression / diffing  (2026-07-30)

**Tool: already installed** — ImageMagick `compare` + `magick`. No new dep.
`compare -metric AE golden.png candidate.png diff.png` → pixel-delta count + a highlighted diff.

**Flow:** commit golden PNGs per (component, state, theme); on change, shoot the same state
(Block 2) and diff; fail if delta > threshold; publish `diff.png`.

**Nondeterminism is the whole battle** — clock, date, battery %, audio %, wallpaper all change
frame-to-frame. Handle by, in order of preference:
1. **Crop to the component under test** (Block 2 gives you the exact panel) — smallest surface.
2. **Freeze inputs** — a test profile: fixed theme, static wallpaper, clock hidden/pinned.
3. **Mask regions** — `magick` rectangles over known-dynamic zones before compare.

**Renderer drift caveat:** goldens MUST be generated by the *same* headless pixman path they're
compared against — pixman vs GPU AA differs, so a GPU-made golden would false-positive. Keep a
small AA tolerance.

**Motion angle:** diff consecutive frames of a Block-1b burst → oscillation (jitter) shows up as
frames flip-flopping; diff frame-N vs an expected keyframe to check an animation reached its end
state.

---

## Block 4 — QML logic tests (qmltestrunner)  (2026-07-30)

**Status: greenfield** — `qmltestrunner` present, zero tests exist. Run headless with
`QT_QPA_PLATFORM=offscreen qmltestrunner -input tests/` (QtTest `TestCase`).

**Good targets (deterministic, no compositor):** `ShellConfig._normEntry` (bare-string ↔
`{id,config}` shim), theme/accent resolution (`ColorScheme._resolveAccent`, `variant|accent`
dedup), JSON config parsing, panel-side resolution logic.

**Honest limit:** singletons that import `Quickshell.Io` / services won't load under plain-Qt
qmltestrunner. So unit-testable = logic depending only on QtQuick/JS. Where valuable, extract
pure JS functions so they're testable without Quickshell. Not everything is unit-testable
without a Quickshell-aware runner — don't pretend otherwise.

---

## Block 5 — CI/CD for a public shell  (2026-07-30)

**Current CI** (`.github/workflows/ci.yml`): bash `-n` syntax, `py_compile`, JSON validation.
It explicitly punts on QML: *"Full QML linting requires Quickshell (not packaged on CI
runners)... Placeholder to wire up once a Quickshell CI image is available."* (`release.yml`
also exists.)

**The unlock:** Block 1 proved the shell renders headless via **pixman software rendering — no
GPU**. So a real QML+render CI stage works today in an **Arch container** (`container:
archlinux:latest`, `pacman -S quickshell mango grim qt6-*`). **No Xvfb** (wlroots headless
backend). This retires their placeholder.

**Proposed CI stages (staged, cheapest first):**
1. `qmlformat --check` — formatting gate (tool present).
2. `qmllint` against Quickshell types (needs QS in the image).
3. `qmltestrunner` — Block 4 logic tests.
4. **Headless render smoke** — Block 1: shell boots + renders with no QML error; upload PNG artifact.
5. **Visual diff** — Block 3 vs committed goldens; upload `diff.png` on failure.

**Verify later:** that `quickshell` is installable in the CI container (repo vs AUR) — the only
open risk in this block.

---

## Block 6 — AI persona-tester system  (2026-07-30)

**Analogy (user's colleague):** AI agents with personas playtested a game for fun/confusion.
Same idea, applied to the shell's UX.

**Architecture — reuses Blocks 1–2, adds no new capture tech:**
- **Sensors (what a persona perceives):** (1) screenshot of the current state (Block 1/2);
  (2) the declared structure/labels (QML tree, config); (3) optionally the **accessibility
  tree** — Qt exposes AT-SPI, a persona can read roles/names (verify a11y works headless).
- **Actuators:** `qs ipc call` + `mmsg` — the exact state-drivers from Block 2. Most flows need
  no pixel-clicking.
- **Personas = system prompts** with a task each, e.g.: first-time non-technical user
  ("find how to change the wallpaper"); keyboard-only power user; low-vision (contrast/scale);
  impatient skimmer. Each returns **structured findings**: confusion points, discoverability,
  contrast/legibility, layout balance, naming clarity → triaged into ROADMAP/ANALYSIS.

**Honest limits (from Block 1b):** personas judge *static* UX well — clarity, layout, contrast,
discoverability, wording. They CANNOT judge motion *feel* from a still; for motion, feed a
frame-burst (coarse) or keep it human. Perceived smoothness stays human + hardware.

**Token discipline (user is limit-sensitive):** each persona run costs LLM tokens. Keep the
fleet small and targeted — run specific personas on specific flows on demand, never a blanket
sweep. Same "block by block, don't burn tokens" rule, applied to the pipeline itself.

---

## Block 7 — Everyday verify-before-done loop  (2026-07-30)

**Purpose:** kill the "Claude said done but the output was wrong and it didn't check" pattern.

**The rule (what I do before claiming a visual change is done):**
1. Drive the affected component to its state via IPC (Block 2).
2. `shot.sh` it (Block 1).
3. Diff vs golden (Block 3) *or* paste the image inline for you to eyeball.
4. Only then say "done" — **with the image attached**, so you see the real result immediately
   instead of discovering it's wrong later.

**For motion changes:** I state the declared duration/curve I set (Block 1b, static) and
explicitly flag that *feel* needs your eyes or a hardware recording — I never claim smoothness
I can't see.

**Guardrails baked in:** harness never kills by name (memory `never-kill-mango-by-name`); a
verify run is one shot, not a fleet, unless you ask for more.

---

## External research — sources, confirmations & corrections  (2026-07-30)

Blocks 1–7 above were grounded in *this machine* + my own reasoning. This section is the
actual web research (targeted searches, not a deep-research harness), noting where sources
**confirm** the draft and where they **correct** it.

### 1. Peer shells barely test — you're already ahead
- **Caelestia** (`caelestia-dots/shell`), the leading Quickshell shell: CMake/Ninja build only;
  no documented CI workflows, no `tests/`, no qmllint/qmlformat. Manual review.
- **Noctalia** ecosystem: the `noctalia-appmenu` component is the most mature example found —
  `qmllint` in CI with SARIF upload, integration tests per PR, reproducible Rust-bridge builds
  with attestation. But it's a small sidecar, not the shell.
- **Takeaway:** prior art *for Quickshell shells specifically* is thin. Your existing `ci.yml`
  (bash/py/JSON validation) already **exceeds** the leading peer; the headless render + visual
  diff pipeline would put archeotech-shell ahead of the ecosystem. The real best-practice prior
  art lives in the broader Qt/QML world (below), not peer shells.
- Sources: [caelestia-dots/shell](https://github.com/caelestia-dots/shell),
  [noctalia-appmenu](https://github.com/yolo-labz/noctalia-appmenu),
  [Quickshell topic](https://github.com/topics/quickshell).

### 2. CORRECTION — the "you need Xvfb / offscreen is X11-only" advice does NOT apply here
- Standard Qt/QML CI wisdom: the Qt `offscreen` platform is **X11-only** and unreliable, so use
  **Xvfb** (virtual framebuffer) for headless GUI tests.
  [Qt Forum: headless GUI testing](https://forum.qt.io/topic/109767/headless-gui-testing-with-qt),
  [Qt Forum: offscreen OpenGL error](https://forum.qt.io/topic/159263/opengl-error-when-trying-to-use-qt_qpa_platform-offscreen).
- **Why it doesn't apply to Block 1:** that advice assumes a *standalone Qt app* owning its own
  window. Quickshell is a Wayland **client** — Block 1 proved it renders into a headless
  **wlroots compositor** (mango + pixman), producing a real PNG, with **no Xvfb and no Qt
  offscreen plugin**. The headless *compositor* is the display. This is a case where grounding
  in the actual stack beat the textbook answer — and it's empirically validated (the 1280×720
  shot), not asserted.
- **BUT the caveat bites Block 4:** `qmltestrunner -platform offscreen` *is* a standalone Qt
  process (not a Wayland client), so the X11/offscreen limitation can hit it. Fallback: run
  qmltestrunner inside the headless compositor, or under Xvfb, if `offscreen` errors on OpenGL.

### 3. CONFIRMATION — QML visual/snapshot regression is an established pattern (Block 3)
- Ben Lau, **"QML Snapshot Testing with TDD"** + the `benlau/testable` runner — direct prior art
  for screenshot/snapshot testing in QML.
  [Medium](https://medium.com/e-fever/qml-snapshot-testing-with-tdd-aba81441c52),
  [benlau/testable](https://github.com/benlau/testable).
- **Spix** (KDAB) — Qt/QML GUI automation + lightweight visual regression *without altering app
  logic*; the notable alternative to my IPC-driving if we ever need real input simulation.
  [KDAB](https://www.kdab.com/automating-repetitive-gui-interactions-in-embedded-development-with-spix/).
- **Squish** — the commercial Qt/QML standard (heavyweight baseline).
  [alternatives list](https://testdriver.ai/articles/top-72-alternatives-to-squish-for-desktop-embedded-qml-qt-web-testing).
- My ImageMagick `compare` golden-diff is a legit low-tech choice; `odiff`/`dssim` exist if
  anti-aliasing noise makes AE thresholds flaky.

### 4. CONFIRMATION — qmltestrunner mechanics (Block 4)
- Qt Quick Test: `test_`-prefixed JS functions in a `TestCase`; run with **`-platform
  offscreen`** for CI; `-import` for import paths; `-functions` lists tests; single functions
  runnable by name. QtTest gives **no dependency isolation** → "test one thing, fresh objects"
  (matches my extract-pure-functions caveat).
  [Qt Quick Test docs](https://doc.qt.io/qt-6/qtquicktest-index.html).

### 5. CORRECTION — persona UX testing is NOT novel; there's a 2024–25 research line (Block 6)
- **UXAgent** (arXiv [2502.12561](https://arxiv.org/abs/2504.09407), CHI 2025 EA,
  [ACM](https://dl.acm.org/doi/10.1145/3706599.3719729)) — **Persona Generator + LLM Agent +
  Universal Browser Connector** → thousands of simulated personas interacting with a design.
  This is almost exactly your colleague's idea, formalized. Architecture to borrow directly.
- **PerceptUI** ([arXiv](https://arxiv.org/html/2606.05697)) — persona-conditioned UI/UX
  evaluation predicting how a specific user answers interface questions, with rationales.
- **Agent A/B** ([arXiv](https://arxiv.org/html/2504.09723)) — LLM-agent A/B testing on live UIs.
- **UXBench** ([arXiv](https://arxiv.org/pdf/2606.16262)) — measures the **actionability** of
  LLM-generated UX critiques. Directly relevant: it's the yardstick for "are the persona
  findings useful, or noise?" — use it to keep findings triageable (and cheap).
- **All are web/DOM-based.** The desktop-shell port = swap the "Universal Browser Connector" for
  your **screenshot + a11y-tree + `qs ipc`** actuators. So Block 6 = adapt UXAgent's
  architecture to a Wayland shell, with UXBench's actionability lens as the quality gate.

---

## Deferred, cheap, read-only next steps (when you want them)
- [ ] Read `shell.qml` `IpcHandler` bodies → exact state-cookbook (Block 2).
- [ ] Re-run the safety-fixed `shot.sh` once, with you watching (Blocks 1/2 live proof).
- [ ] Confirm `quickshell` installs in an Arch CI container (Block 5's only risk).
- [ ] Confirm Qt AT-SPI accessibility tree is readable headless (Block 6 sensor).
- [ ] `wf-recorder` decision for real-hardware motion recording (Block 1b).
