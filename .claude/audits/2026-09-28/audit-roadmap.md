# Archeotech roadmap, planning corpus and dev-process audit

Date: 2026-09-28. Read-only audit. Sources: `logics/roadmap/road_001_archeotech_shell.md`, `logics/backlog/*`, `logics/tasks/*`, `logics/request/*`, `logics/product/*`, `logics/architecture/*`, `.claude/claude.md`, `.claude/PLANNING.md`, `logics/instructions.md`, git history of `archeotech-dotfiles` and `archeotech-shell`, and read-only `logics-manager status | health | lint --require-status | audit --group-by-doc | release status`.

---

## 0. TL;DR

- The roadmap has too many milestones for one developer. Its numbers and its order disagree: 0.265 and 0.30 both sit before 0.27. Its "v1 = public, community-ready" bar needs a plugin ecosystem, a second compositor, a testing pipeline, a motion system and a distribution story all before a tag. At the net rate the corpus is actually shrinking, that tag is about 20 weeks away (roughly Feb 2027). With cuts it could be about 6 weeks away (mid-November 2026).
- Delivery pace is high: about 26 shell commits a week, and more than 30 a week in the last four active weeks. But roughly half of it is look-and-feel iteration: sheen, shadows, 3D and glass passes, re-tuning panel sizes. About 20% went into the flagship Grimdark pack, which the roadmap schedules for after 1.0 and `prod_001` lists as a non-goal. Real foundations (tests, packaging, the plugin install path) got under 10%.
- Scope keeps growing. Items 087 to 100 (14 new items) were added in about 3 weeks while about 20 closed, so the corpus shrank by only about 2 items a week.
- The corpus lints OK but fails `audit` with 50 blocking issues. Almost all of them are noise:
  - 43 come from two Obsolete orchestration tasks that still link open items.
  - 12 are "missing code anchor" warnings: the audit looks for shell-repo paths inside the dotfiles repo.
- The real cost of the process is bookkeeping. Since 2026-08-17, 82 of about 98 dotfiles commits are `[MD]` logics updates, with 360 logics file touches against 59 other file touches. task_030 alone got 10 progress commits in 2 days.
- Process risks:
  - 69 shell commits and 53 dotfiles commits are not pushed.
  - The shell repo has uncommitted builder work (`EditOverlay.qml` +211/-134 lines, `WidgetPalette.qml` staged for deletion).
  - Two internal HANDOFF docs sit in the *public* shell repo's `docs/`, and both are stale.
  - Nothing has been committed since 2026-09-11 (17 days).
  - CI only lints bash, py and JSON. There are zero tests.
- Recommendation: collapse the roadmap to 4 milestones with hard exit criteria. Put a golden-screenshot suite *first*, because it pays back on every later item and is also how the README screenshots get made. Freeze new scope. Defer motion, creative applets, the plugin refactors, the dashboard and builder extras, and all personal dotfiles items.

---

## 1. Roadmap soundness

### 1.1 Numbering and sequence

The Mermaid chain in `road_001` is `0.25 -> 0.26 -> 0.265 -> 0.30 -> 0.27 -> 0.28 -> 0.29 -> 1.0`. The roadmap's own rule says "Deliver milestones in ascending version order unless dependencies force a documented exception", and no exception is written down. 0.30 was placed after 0.265 because motion is "user #2 priority". Its number was never changed, so the number and the position disagree. 0.265 exists only because a milestone had to fit between 0.26 and 0.27.

**Verdict:** the version labels are planning sequence numbers, not releases. `release status` reports `not_configured`, and no 0.2x tag exists. Renumber to integers or to named milestones (see §5), or at least put 0.30 after 1.0, where its content belongs.

### 1.2 Status per milestone (items and requests listed in `road_001`)

| Milestone | Done | Ready | Draft / In progress | Comment |
|---|---|---|---|---|
| 0.25 Stability | 5 | 0 | 0 | Complete. The exit signal (dock/undock/resume cycle) was hardware-confirmed (item_005 closed 2026-09-07). |
| 0.26 Extensibility/Coherency/Polish | 14 | 16 | 1 (item_087) | 31 entries. This is a grab-bag, not a milestone. |
| 0.265 Theming engine | 1 (item_081) | 2 (req_001, item_078) | 1 (item_091) | The engine is done. The HUD kit and accent work are optional. |
| 0.30 Polish/Liveliness | 0 | 1 (item_079) | 5 (req_002, req_004, 085, 086, 088) | Two Draft *requests* will each split into 4 or more items. This is the biggest scope bomb. |
| 0.27 Plugins | 1 (066) | 4 | 0 | The manifest is done. Install, index, refactors and the pack distribution model are not. |
| 0.28 Testing | 1 (067 shot.sh) | 4 | 0 | The harness exists. Goldens, CI and tests do not. |
| 0.29 Hyprland | 2 (070, 071) | 2 (072, 084) | 0 | The facade and config port are done. The Lua migration and docs are not. |
| 1.0 Distribution | 2 (073, 074) | 5 | 0 | Path audit verified: 0 `/home/corvus` in code, only in 2 internal docs. install.sh is done. |
| post-1.0 | 1 | 23 | 2 (+item_083 "In progress 0%") | Includes item_082 at 60%, which was actually worked on in August. |

Items that exist but are **not on the roadmap**: item_080, 092, 093, 094, 095, 096, 097, 098, 099, 100 (and 014, which is Obsolete). Most of them were added during September builder and faces work. That shows the roadmap is no longer the place where scope gets decided.

### 1.3 Scope creep evidence

- **Flagship pack before 1.0.** On 2026-08-24 and 2026-09-01/02 there were about 40 shell commits on Shadow Spears/Grimdark: rivets, bevels, copper, Cinzel, console housings, and an IP-safe rename. item_082 is at 60% and item_083 is "In progress", yet both sit in post-1.0. `prod_001` says in so many words: *"Non-goal: building named theme personalities (40k/...) before the liquid-glass base is settled."* This is the biggest divergence between plan and practice. It is not necessarily wrong, because the pack shows off the engine. But it needs an explicit decision.
- **The builder expanded three times.** item_022 (DnD) was followed by item_097 (WYSIWYG), item_099 (UX overhaul + library), item_096 (grouping) and item_098 (N containers per side, which needs a config migration). item_098 is framed as "the endgame". It is a data-model change, and it should not land in the release before 1.0.
- **Faces.** req_003, item_100 and task_030 went from request to Done in 2 days (2026-09-09 to 09-11). That is a good slice. But it had 20+ commits of re-tuning (for example panel size 220 -> 250 -> 272, and launcher 440 -> 680 then 600 -> 380 -> 450).
- **Motion (req_002) and creative applets (req_004)** are research-derived wish lists. They cover morph drivers, motion personalities, UI sound, Canvas hero-viz, a Kanban board, Digital Wellbeing and a whiteboard. A strong 1.0 needs none of them.

### 1.4 Stale, duplicate and obsolete candidates

- **Verification chores filed as backlog items (38 days untouched):** item_001 (day/night schedule), 002 (light themes pass), 003 (VSCode regen), 004 (sparse settings panes). Convert them into golden scenarios under item_068, or into one pre-release QA checklist item.
- **Picker micro-polish (38 days):** item_006, 007, 009 (and 010, the cache path). Merge them into one "picker feel" item. Keep 010 before 1.0, because a stranger's machine should use the freedesktop thumbnail path.
- **Personal dotfiles, not shell product:** item_023, 024, 025, 027, 028, 029, 030, 031, 032, 033, and 052 to 061 (the ten "Someday" items). These are about 22 items in the shell roadmap's post-1.0 bucket. Move them to a separate dotfiles roadmap, or mark them Obsolete and keep the list in one doc. They inflate the "open workflow docs: 71" count and the stale count.
- **item_086 GRUB theme** is machine config, so it belongs in dotfiles, not the shell roadmap.
- **item_092 Mermaid diagrams for ADRs:** process-only work. Close it and accept the audit warning.
- **item_062 desktop widget layer:** deferred since "Sprint 21" and has Low priority. Move it post-1.0.
- **item_069 AI persona testers (UXAgent port):** a research project dressed as a backlog item. Kill it or reduce it to a checklist or skill (see §4).
- **item_019 theme-applier plugins refactor and item_020 core->plugin extraction:** internal refactors. 1.0 needs a *stable plugin API and an install path* (item_065), not extraction. Defer both.
- **item_084 Hyprland config to Lua:** a port of a port. Defer. 0.29's exit signal is already largely met by item_070 and item_071.
- **Umbrellas:** req_000 is still `Draft` while it anchors the whole product. prod_001 and prod_002 are `Proposed`. task_001 and task_002 are `Obsolete` but still carry DoD checkboxes and links to 43 open items.
- **Inconsistent state:** item_083 says `In progress`, 0%, while its code landed on 2026-08-24. item_082 says `Ready` at 60%.

### 1.5 Is "v1 = public, community-ready" realistic?

The v1 exit signal is "A fresh-Arch install by a stranger produces a working shell ... with a plugin/theme contribution path". That is realistic **if** "community-ready" means documented APIs plus a way to install a pack or plugin from a git URL. It is not realistic if it also means motion personalities, creative applets, a 3-compositor facade, AI persona testers and a curated community catalog.

Count what the current plan still needs before 1.0: about 16 Ready items in 0.26, 3 in 0.265, 6 in 0.30 (and the two Draft requests will expand), 4 in 0.27, 4 in 0.28, 2 in 0.29 and 5 in 1.0. That is about 40 items, and more once the requests expand. Real closure is about 6 to 8 items a week at the September peak, but the corpus shrinks by only about 2 a week once new items are counted. So the current plan puts 1.0 about **20 weeks** out.

The trimmed plan in §5 has about 18 pre-1.0 items. At 4 to 6 items a week that is **5 to 6 weeks**.

---

## 2. Delivery velocity and where the time went

### 2.1 Commit cadence

**archeotech-shell** (created 2026-07-09 by the repo split; 207 commits; last commit 2026-09-11):

| ISO week | W28 | W29 | W30 | W31 | W32-33 | W34 | W35 | W36 | W37 | W38-39 |
|---|---|---|---|---|---|---|---|---|---|---|
| commits | 12 | 7 | 42 | 7 | 0 | 31 | 27 | 32 | 49 | 0 |

The average is about 26 a week over 8 active weeks. Work comes in bursts: W30 was the polish rollout, W37 was builder and faces. There were 2-week gaps in W32-33 and again now. The commit mix is 76 `chg[QML]`, 40 `fix[QML]` and 36 `new[QML]`. At 40 of about 200, fixes run at roughly 1 in 5.

**archeotech-dotfiles** (311 commits since 2025-11-28): the steady state before the split was 5 to 20 a week. Since the logics migration (2026-08-20) it is dominated by `[MD]` bookkeeping: 60 `chg[MD]` and 22 `new[MD]` out of about 98 commits since 2026-08-17.

### 2.2 Items closed

- 32 backlog items and 28 tasks are `Done`. Several tasks were recorded as already delivered when the corpus was bootstrapped on 2026-08-20 (task_004, 006, 008, 010, 012, 014, all named "...delivered"). Real closure after the migration is about 20 items between 2026-09-01 and 09-11, most of them in W36-37.
- Per milestone: 0.25 is 5/5, 0.26 is 14/31, 0.265 is 1/4, 0.27 is 1/5, 0.28 is 1/5, 0.29 is 2/4, 1.0 is 2/7, and 0.30 is 0/6.

### 2.3 Where the time went (shell commit subjects, approximate and overlapping)

| Bucket | Share | Examples |
|---|---|---|
| Look and feel (sheen, shadow, 3D, glass, flat mode, padding, SegmentedControl, GlassButton) | ~45-50% | the whole 07-20..07-22 polish rollout, 08-17..08-19, 09-04..09-07 flat mode and coherency slices |
| Theming engine + flagship pack | ~20% | 08-22..09-02 (adr_027 Layers A-D, then about 25 commits of Shadow Spears iteration) |
| Builder + faces | ~15% | 09-07..09-10 |
| Services, stability, foundations | ~10% | CompositorService facade, UPower/Pipewire/udev/gdbus event-driven services, shot.sh |
| Docs | ~10% | API docs, handoffs |

**Rework patterns:**
- Three explicit reverts: "revert polish slice to known-good — regressions in live session" (07-10), the flat-mode surfaceRaised revert (09-06), and the liquid-glass blur revert.
- Flat-mode intent was redefined after it was delivered (item_012, which led to adr_029).
- Panel dimensions were re-tuned several times in single sessions.
- `Commons/Appearance.qml` is touched in 24 commits. It is the token hotspot, and every look change goes through it without any regression check.

These are the symptoms of a loop with no automated visual check: change it, look at the live bar, change it again. item_069 describes exactly this: "claimed done but wrong".

---

## 3. Corpus health (read-only diagnostics)

- **`lint --require-status`:** OK.
- **`status`:** 71 open workflow docs. 15 Ready backlog items have no task. 3 Draft requests (req_000, req_002, req_004).
- **`health`:** 169 docs, 135 workflow docs, 15 issue signals, **71 stale docs (14+ days untouched, many at 38 days)**.
- **`audit --group-by-doc`:** **FAILED, with 50 blocking issues and 125 warnings.**

| Finding | Count | Real issue? |
|---|---|---|
| BLOCKING `task_links_open_backlog` | 43 | **Noise.** task_001 and task_002 (both Obsolete) link items that are still open. The fix is to drop those links, or accept them. |
| BLOCKING `task_dod_unchecked` | 2 | Same two Obsolete tasks. |
| BLOCKING `backlog_orphan_no_request` | 2 | item_083 and item_095 have no request. Real but trivial. |
| BLOCKING `task_missing_backlog_ref` | 1 | task_002. |
| BLOCKING `ac_no_linked_backlog` | 1 | req_001 has ACs but no linked items, even though item_081 was delivered for it. The link is missing. |
| BLOCKING `companion_doc_missing_mermaid` | 1 | adr_029. |
| WARN `ai_context_ungroomed` | 42 | Generated boilerplate that was never groomed. Low value for a solo dev. |
| WARN `companion_doc_missing_primary_link` | 25 | ADRs 001-025 were migrated from DECISIONS without links. |
| WARN `companion_doc_missing_mermaid` | 17 | ADRs. item_092 exists only to fix this. |
| WARN `ac_duplicate_proof` | 16 | Generated AC proofs copy-pasted in migrated items. |
| WARN `code_anchor_path_missing` | 12 | **False positive caused by the two-repo split.** ADRs cite `Commons/Appearance.qml` and similar paths, which exist in `archeotech-shell` while the audit resolves them against the dotfiles repo. |

- **`release status`:** `not_configured`. None of the 0.2x labels is tied to a tag or a contract.

### 3.1 Is the process overhead worth it?

Partly. It is clearly worth it for three things:
- ADRs: 31 decisions, which stop the "rediscover every session" problem.
- A single backlog as the source of truth.
- Grooming a request into a backlog item and a task for multi-wave work. task_030 went from groomed to Done in 2 days, which is a good pattern.

It is not worth it in these places:
- **Commit granularity.** Progress percentages get committed separately from code: 10 `task_030 ...` MD commits in 2 days. That is about one bookkeeping commit per code commit, which roughly doubles the commit and review surface.
- **Audit gate noise.** 50 blocking issues that nobody acts on train everyone to ignore the audit. Once it cannot fail meaningfully, it is no longer a gate.
- **Migrated boilerplate.** 42 ungroomed AI Context sections and 16 duplicate-proof warnings. The corpus looks large (169 docs) but much of it is placeholder text.
- **Personal backlog mixed with product backlog.** About 22 Someday and dev-workflow items inflate the counts and the stale list.
- **Duplicate trackers.** `docs/POLISH_ROLLOUT.md` (18 commits, later removed), `.claude/PROJECT_HISTORY.md`, the HANDOFF docs and the logics corpus all tracked progress at different times.

**Suggested tightening:**
- Make one logics commit per task wave or closeout, not per progress tick.
- Clear the audit to zero blocking issues once (drop the stale links, close or settle the umbrella docs). Then treat a blocking finding as a real gate.
- Move personal items out of the shell roadmap.
- Stop hand-grooming AI Context. Accept the warning, or suppress it.

---

## 4. Dev process with AI

### 4.1 Current verification loop

`scripts/shot.sh` is solid. It runs a nested headless mango at 1280x720 with a pid-scoped teardown and an isolated D-Bus. It has `--state` for driving IPC, `--burst` for motion, `--qml` for isolated components, and `--notify`. Its gaps:

1. **HOME-sensitive.** It needs `HOME=/home/corvus`. This is documented in three places, which shows it keeps biting.
2. **Full-shell mode uses `qs -c archeotech`**, which resolves the `~/.config/quickshell/archeotech` symlink to the *main checkout*. So you can't render a git worktree. That blocks running agents in parallel.
3. **Hover and click popups have no IPC.** They need a throwaway `_<x>harness.qml` at the repo root, written and deleted in every session (`docs/SHELL_VISUAL_DEV.md`). These harnesses are never committed, so each session rebuilds them.
4. **There are no goldens and no diffing.** "Verified" means one person looked at one PNG.
5. **The live bar hot-reloads from the main checkout.** Every save lands on the real session, and the 07-10 revert was a regression that shipped live. Editing in the main checkout is the risky path.
6. **CI** (`.github/workflows/ci.yml`) runs only `bash -n`, `py_compile` and JSON validation. There is a placeholder comment for QML. `qmltestrunner` is installed but unused, and there are zero tests.

### 4.2 Session handoff

- `archeotech-shell/docs/FLAGSHIP_HANDOFF.md` (138 lines) and `docs/FRAME_CORNER_HANDOFF.md` (259 lines, modified and uncommitted) are **internal session notes in the public repo's `docs/`**. They are stale: "ACTIVE WORK (2026-08-26)". FLAGSHIP_HANDOFF says "do NOT commit until they OK it", which conflicts with the later commits. Both mention `/home/corvus` paths.
- The logics task docs are already the better handoff surface: status, progress, AC proof. Keep one short `HANDOFF` note *in the logics task* (a "Next step / Open threads" section), not as separate files in docs.
- The working tree has uncommitted builder work (`Modules/Shell/Builder/EditOverlay.qml`, `SegmentedControl.qml`, and `WidgetPalette.qml` staged for deletion). No logics doc owns it. It is probably item_096 or item_098. Because nobody pushed for 17 days, 69 commits exist only on this laptop.

### 4.3 Target AI-heavy workflow (proportionate for one dev plus agents)

1. **Spec-first task with eval-style acceptance checks.** Each task carries machine-checkable ACs, for example `scenario: launcher-open @ pack=neutral flavor=macchiato -> golden launcher.png (AE < 0.5%)`, a `qmltestrunner` test id, or a grep invariant such as "no `#hex` literal outside `Appearance.qml`". "Done" means all checks pass, with the images linked in the task.
2. **Scenario-driven golden suite (item_068, minimal version).**
   - A `tests/scenarios/*.json` file describes theme/pack/flavor, `--state`, an optional harness QML and a crop rectangle.
   - `scripts/golden.sh` runs `shot.sh` for each scenario and compares with `magick compare -metric AE -fuzz 2%` against `tests/goldens/*.png`.
   - It writes `diff-*.png` and an HTML contact sheet.
   - To remove nondeterminism: static wallpaper, a hidden or frozen clock, fixed fonts, and software rendering (pixman).
   - Start with about 12 scenarios: bar at each of the 4 sides, launcher, settings:appearance, dashboard, media full and compact, notification toast, OSD, flat vs glass, and light theme (this absorbs item_002).
3. **Committed component harnesses.** Move the throwaway `_harness.qml` files into `tests/harness/` with a shared mock `holderRoot`. That makes hover popups (calendar, wifi/bt, hover cards, tray menu) scenario-addressable.
4. **Worktree-parallel agents.** Add `--path <dir>` to `shot.sh` (use `qs -p <dir>/shell.qml` instead of `-c archeotech`), and make it take HOME from an argument or fall back to a fixed default. Then:
   - Each backlog item gets `git worktree add ../as-wt/<item>` plus one agent.
   - The agent edits there, which **never hot-reloads onto the live bar**. This also fixes the live-session-safety rule by construction.
   - It renders its scenarios through `--path` and opens a branch with its diffs.
   - The human reviews contact sheets and merges.
   - Independent items (tray menu, cache path, docs) can run 2 or 3 at a time.
5. **CI in an Arch container.** `archlinux:latest` plus quickshell from a pinned package (AUR build cached as an artifact, or chaotic-aur), mango or cage headless, then `qmllint` -> `qmltestrunner` (pure JS logic: `ShellConfig._normEntry`, accent resolution, pack token merge) -> golden diff, uploading `diff.png` on failure. If the Quickshell-in-CI build takes more than about 1 day, run `golden.sh` locally as a pre-commit or pre-push hook first.
6. **Replace item_069 (AI persona testers)** with a "verify-before-done" skill or checklist the agent must run:
   - render the affected scenarios;
   - attach the before/after images to the task;
   - list the ACs with their evidence;
   - have a separate reviewer sub-agent judge the image against the AC text for static UX: contrast, overflow, clipping.

   This is about 5% of the UXAgent effort and delivers most of the value.
7. **Bookkeeping automation.** Commit a logics progress update in the same commit as the code wave, or once at closeout.

---

## 5. Proposed restructured roadmap

Principles:
- Four pre-1.0 milestones, each with an exit test you can check mechanically.
- The testing harness comes first, because it speeds up everything after it and produces the README screenshots.
- A scope freeze: any new idea goes to `post-1.0` unless it blocks an exit criterion.

### M1 — "Safety net" (target 0.3, about 1.5 weeks)
Scope:
- Push both repos.
- Resolve the uncommitted builder WIP: commit it to a branch or park it with a logics doc.
- Move the HANDOFF docs out of the public repo.
- Add `shot.sh --path` and a HOME fallback.
- Build the golden suite with about 12 scenarios and `tests/harness/`.
- Add a first set of `qmltestrunner` logic tests (3 to 5).
- Make `qmllint` run locally as a pre-push hook. Do Arch-container CI if Quickshell builds cleanly within a day; otherwise make it M2's first item.
- Clear the audit to 0 blocking issues.

Items: item_068 (minimal), items 001-004 folded in as scenarios, item_069 rewritten as the verify-before-done checklist.

**Exit:** `scripts/golden.sh` passes on main. One real visual change has been made through a worktree with diffs attached. The audit reports 0 blocking issues. Both repos are pushed.

### M2 — "Coherent core, feature freeze" (target 0.4, about 2 weeks)
Only the items a stranger would notice as broken or inconsistent:
- item_017 panel keybinds/dismissal consistency
- item_039 glass tray menu + tooltip
- item_045 edit-mode stragglers
- item_049 dashboard system-notes data reliability (High)
- item_010 freedesktop thumbnail cache
- item_064 holder-aware and vertical widgets, **only if** a golden scenario shows vertical sides are broken; otherwise defer
- item_091 accent for all families
- item_088 bar container styles, *only* if it can be done in 1 or 2 days, as the single liveliness feature. Otherwise defer.

**Exit:** every golden scenario passes in glass, flat and light. No hardcoded colour outside the tokens (a grep check in CI). The 0.26 list is closed or deferred.

### M3 — "Installable by a stranger" (target 0.9 / RC, about 2 weeks)
- item_075 variant symlinks
- item_076 API/INSTALL/CONTRIBUTING docs
- item_072 COMPOSITOR_SUPPORT.md
- item_065 plugin/pack install by git URL + plugins.json index (minimal: clone, validate the manifest against minShellVersion, enable)
- item_021 reduced to a "how to publish a pack" doc + 1 or 2 official packs (neutral glass + HUD demo)
- item_034 cut to "no machine-specific assumptions" plus one example profile
- a fresh-Arch VM or container install test (scripted)
- item_040 onboarding: a first-run defaults screen only

**Exit:** the scripted fresh-Arch install renders the shell and passes the goldens on both MangoWC and Hyprland. A third-party pack installs from a URL and switches live.

### M4 — "1.0 launch" (about 1 week)
- item_077: README screenshots and a demo GIF generated from the golden scenarios (`--burst`), the v1.0.0 tag, and GitHub metadata.
- Configure `logics-manager release` and record evidence.
- **Decision point on the flagship pack:** either finish item_082/083 to "showcase" quality as the launch hero (it is 60% done, and it is the r/unixporn hook), or ship 1.0 with neutral glass plus HUD and make Grimdark 1.1. Recommendation: ship it as a **bundled preview pack** only if a 3-day timebox gets it screenshot-ready; otherwise keep it for 1.1.

**Exit:** the tag is published and the install test is green.

### Post-1.0 (ordered)
- **1.1 Identity:** flagship Grimdark pack (item_082/083), HUD framing kit (item_078), named personalities (item_051).
- **1.2 Motion:** req_002, trimmed to the single interruptible morph driver plus motion personalities with preview. Drop UI sound unless someone asks for it.
- **1.3 Builder depth:** item_096 grouping, item_098 N containers (with a config migration and ADR), item_046/047 dashboard grid/projects, item_062 desktop widgets, item_087 settings deep-dive.
- **1.4 Applets:** req_004 (pick 1 or 2: Canvas hero-viz, Kanban), item_079 cava, item_085 idle/screensaver, item_018 lock customization, item_013 loadouts.
- **Later:** item_019/020 plugin refactors, item_084 Hyprland Lua, item_089 Niri/Sway, item_090 Zen chrome, picker polish (006/007/009).

### Kill, move or close
- **Move to a dotfiles roadmap, or close:** item_023-033, item_052-061, item_086.
- **Close:** item_092 (accept the warning). Replace item_069 with the checklist. Settle req_000 and prod_001/002 through the CLI. Drop the task_001/002 links.
- **Merge:** items 001-004 into item_068 scenarios, items 006/007/009 into one picker-feel item.

### First two weeks (concrete)

**Days 1-2 (hygiene):**
1. Decide what happens to the uncommitted `EditOverlay.qml` / `WidgetPalette.qml` / `SegmentedControl.qml` work: commit to a `wip/builder-containers` branch, or stash it and record the state in item_098.
2. Move `docs/FLAGSHIP_HANDOFF.md` and `docs/FRAME_CORNER_HANDOFF.md` into the dotfiles `.claude/`, or into a "Next step" section of item_082/083.
3. Push both repos (the user does this).
4. Clean up the corpus with the CLI:
   - remove the task_001/002 links;
   - link item_081 to req_001;
   - give item_083 and item_095 a request;
   - fix item_083's status (In progress at 0%);
   - move or close the personal items;
   - renumber the roadmap.

   Target: `audit` at 0 blocking.

**Days 3-4 (worktree-safe rendering):**
1. `shot.sh --path <dir>` using `qs -p`, with a HOME fallback.
2. Move the harness template into `tests/harness/` with a mock `holderRoot`.
3. Do one dry run: `git worktree add`, edit, render, confirm the live bar is untouched.

**Days 5-7 (golden suite v1):**
1. `tests/scenarios/*.json` with 12 scenarios, and `scripts/golden.sh` (compare + contact sheet).
2. Freeze the nondeterministic inputs (wallpaper, clock, fonts).
3. Generate and commit the goldens.
4. Wire it as a pre-push hook.

**Days 8-9 (logic tests + CI):**
1. Extract pure JS from `ShellConfig` normalisation, accent resolution and pack token merge. Add 3 to 5 `qmltestrunner` tests.
2. Try the Arch-container CI job, with a 1-day timebox.
3. Add a grep invariant: no hex colour outside tokens.

**Day 10 (process):**
1. Write the verify-before-done checklist as a project skill or section in `.claude/claude.md`.
2. Adopt the rule "one logics commit per wave or closeout".

**Days 11-14 (first M2 items, 2 in parallel through worktrees + agents):**
- item_039 tray menu and item_017 dismissal consistency, each with golden scenarios attached and closed out through `flow finish`.
- Measure: items closed, re-tune commits per item. The target is fewer than 3 fix commits per item.

---

## Appendix: key numbers

- Shell repo: 207 commits (2026-07-09..09-11). 69 unpushed. 123 QML files, about 18.7k lines. Hotspot: `Commons/Appearance.qml` (24 commits).
- Dotfiles: 311 commits. 53 unpushed. `.claude/*.md` totals about 6.3k lines, including an 886-line PROJECT_HISTORY.
- Corpus: 100 backlog items (32 Done, 1 Obsolete, 1 In progress, 13 Draft, the rest Ready). 30 tasks (28 Done, 2 Obsolete). 5 requests. 2 product briefs. 31 ADRs.
