# Archeotech — Claude Code tooling & AI-workflow audit (2026-09-28)

Scope: `~/Projects/archeotech-shell` (public Quickshell/QML shell, 123 QML files / ~18.7k lines, 207 commits),
`~/Projects/archeotech-dotfiles` (private config + `logics/` planning corpus, 311 commits).
Read-only audit. Evidence comes from config files, git history, and the 44 session transcripts under
`$HOME/.claude/projects/-home-corvus-Projects-archeotech-dotfiles/` (9,222 Bash calls, 884 Edits, 750 Reads).

---

## 0. Headline findings

1. **The safety rules exist only as prose, and one repo doc still teaches the forbidden pattern.**
   `.claude/claude.md` says never `grim` the live output and never drive the live shell's IPC. But
   `archeotech-shell/docs/SHELL_VISUAL_DEV.md` still tells the agent to `export HOME=/home/corvus
   XDG_RUNTIME_DIR=/run/user/1000 WAYLAND_DISPLAY=wayland-0`, then `qs -c archeotech ipc call dashboard open`
   and `grim`. The transcripts contain **114 direct live `grim` calls and 84 live `qs -c archeotech ipc`
   calls** (all 2026-08-26 → 09-04, the last 2 on 09-04, the day the rule was written). Nothing enforces the
   rule, so it holds only as long as the model reads and follows the prose.
2. **`shot.sh` is not isolated from the live session.** It starts `mango` **without `-c`**. Run with the
   documented `HOME=/home/corvus`, that loads the **real** `~/.config/mango/config.conf`, whose `exec-once`
   lines start a *second* `quickshell -c archeotech`, run `qs -c archeotech ipc call dashboard openAuto`
   (selected by config name, over the **shared** `XDG_RUNTIME_DIR`, so it can reach the live bar),
   `gnome-keyring-daemon`, `awww-daemon` + `wallpaper-set.sh --restore`, the cliphist watchers,
   `swayidle/config.sh` and `monitor-hotplug.sh`. The latest `/tmp/archeotech-shot-mango.log` confirms that
   exec-once ran inside the nested session (awww socket, portals activated, Xwayland `X0` bind clash). The
   nested shell also writes the real `~/.local/share/archeotech/state.json` and `~/.config/archeotech/*`.
   Logs go to fixed `/tmp/archeotech-shot-*.log` paths, so parallel runs overwrite each other (seen today:
   the current log belongs to another agent's fake-HOME run).
3. **The `qmllint` on PATH is the Qt5 one.** `/usr/bin/qmllint` belongs to `qt5-declarative` 5.15: a syntax
   verifier that prints nothing on these files and exits in 7 ms. The real linter is
   `/usr/lib/qt6/bin/qmllint` (6.11.2, about 0.1 s per file, about 4.4 s for the whole repo). Sessions ran
   `qmllint` 151 times, probably getting the Qt5 binary. The CI comment says "run qmllint locally against
   Qt 6.11", which never happens by default.
4. **The live bar is the working tree.** `~/.config/quickshell/archeotech -> ~/Projects/archeotech-shell`,
   so every agent save hot-reloads onto the user's desktop. That one coupling is behind most of the
   fragility rules ("keep every save valid", "no debug visuals", "reload race", "can't render a worktree").
5. **Bookkeeping costs are high.** In dotfiles, 135 of 311 commits are `chg/new[MD]`; since 09-01 it is
   61 of 74 (82%). Each shell wave has a matching `task_0xx NN%` doc commit. `logics-manager` accounts for
   571 of 9,222 Bash calls (6%). It is useful as cross-session memory, but it runs per wave rather than per
   task.
6. **Underused Claude Code features.** There are no project hooks, agents, skills, commands, permission
   allowlist or statusline in either repo. There are 0 worktrees, 0 `qmltestrunner` calls and 0 `rtk` calls.
   19 Agent calls in total, all generic Explore or general-purpose agents.

---

## 1. Claude Code config inventory

### Profiles (two exist, and only one is active)
| Location | Status | Contents |
|---|---|---|
| `$HOME/.claude` = `/home/corvus/.cdx/profiles/corvus/claude-home/.claude` | **ACTIVE** (via `cdx`) | `settings.json`: model opus, effort high, `cdx notify` hooks on Stop/StopFailure/Notification/PermissionRequest, plugin `ui-ux-pro-max`. 8 logics skills (`implement-task`, `corpus`, `closeout-repair`, `lifecycle-ops`, `project-health`, `review-project`, `roadmap-deliver`, `groom-issues`, about 28 KB). **No CLAUDE.md, no rtk hook, no statusline, no permissions.** |
| `/home/corvus/.claude` | **inactive profile**, but its `CLAUDE.md` still loads as an ancestor-dir file | `CLAUDE.md` (`@RTK.md`), `settings.json` with the **rtk PreToolUse hook** and a statusline pointing at *another* profile (`.cdx/profiles/digital/...ponytail-statusline.sh`). **48 `logics-*` agents + 48 `logics-*` commands** from an old global kit that never load in the active profile. `settings.local.json` holds unrelated Steam/Battle.net allow rules. |

### Project config
- `archeotech-dotfiles/.claude/`: knowledge MDs only. No `settings.json`, `agents/`, `skills/`, `commands/` or hooks.
- `archeotech-shell/.claude/`: does not exist, and **`.claude/` is in the shell `.gitignore`** (public repo).
  Any Claude tooling should therefore live in **dotfiles `.claude/`**. That works because every session
  starts with cwd = dotfiles (the transcripts only exist under that project key) and hooks apply to every
  tool call whatever the target path.
- `AGENTS.md` (dotfiles) = `@LOGICS.md`.

### Always-loaded context (per session, dotfiles cwd)
| File | Bytes |
|---|---|
| `/home/corvus/.claude/CLAUDE.md` + `RTK.md` | 8 + 964 |
| `CLAUDE.md` | 718 |
| `.claude/claude.md` | 11,707 |
| `LOGICS.md` | 3,356 |
| **Total** | **about 16.7 KB, about 4.5k tokens** |

Plus skill descriptions: 8 logics skills, 7 ui-ux-pro-max skills and the built-ins. The size is fine; the
problem is **contradictions and staleness**, not bloat. The large docs (`ANALYSIS.md` 172 KB,
`PROJECT_HISTORY.md` 69 KB, `TROUBLESHOOTING.md` 58 KB) load on demand, which is correct. `TROUBLESHOOTING.md`
at 58 KB is too big to read whole; it needs an index or headings for Grep.

### Contradictions and stale facts
| # | Where | Problem |
|---|---|---|
| C1 | `shell/docs/SHELL_VISUAL_DEV.md` vs `.claude/claude.md` | The doc tells the agent to grim the live output and IPC the live shell; claude.md forbids both. **Worst item: the doc that is loaded when doing visual work is the wrong one.** |
| C2 | `claude.md` ("run shot.sh as `HOME=/home/corvus`") vs `shell/docs/FLAGSHIP_HANDOFF.md` ("build a fake HOME… launch mango with `HOME=$FAKE`") | Opposite advice. The fake-HOME recipe is the safe one, but it only exists as prose plus a scratchpad dir that gets wiped. |
| C3 | `RTK.md`: "All other commands are automatically rewritten by the Claude Code hook" | The hook is only in the inactive profile, and the transcripts show 0 `rtk` calls. It either costs tokens for nothing or should be installed. Note the rtk hook returns `permissionDecision: allow`, which auto-approves any rewritten command. |
| C4 | `claude.md`: "Quickshell **0.3.0** … native Pipewire… not yet adopted" | `qs --version` = **0.3.1**; commit `b4ea764` moved audio to native `Quickshell.Services.Pipewire`. |
| C5 | `claude.md`: "check syntax (shellcheck etc.)" | `shellcheck` is not installed; the `qmllint` on PATH is Qt5 (finding 3). |
| C6 | `.claude/PLANNING.md` | "Backlog (61 items)", "25 ADRs"; the real counts are 100 backlog docs and 31 ADRs. |
| C7 | `implement-task` skill ("commit as you go, one commit per logical step"; "do not stop until tests and lint pass"; "never two tasks against the same repo") vs `FLAGSHIP_HANDOFF.md` ("don't commit until the owner approves") vs claude.md ("you may create commits") | Three commit policies. The shell has no tests, so the skill's "until tests pass" clause is always vacuous. The skill also assumes one repo, but here code goes in shell and docs in dotfiles. |
| C8 | `FLAGSHIP_HANDOFF.md` / `FRAME_CORNER_HANDOFF.md` in the **public** shell `docs/` | Dated 2026-08-26, marked "Delete once merged"; claims "nothing since c0ceedc is committed" (false now). Private session workflow is sitting in a public repo. |
| C9 | shell CI | Validates a `drawer-config.json` that doesn't exist; the QML lint step is a placeholder. |
| C10 | `/home/corvus/.claude/settings.json` statusline | Points into the `digital` profile's plugin cache. It is dead config that confuses anyone reading it. |

---

## 2. Project tooling

| Tool | State | Gaps |
|---|---|---|
| `scripts/shot.sh` | Good core: nested headless mango, pid-scoped teardown, `qs ipc --pid`, `dbus-run-session`, `--state`, `--burst`, `--notify`, `--qml`. | (a) no `-c` for mango, so it sources the real autostart (finding 2); (b) real HOME, so it writes real state/config and reads whatever pack or config is live, which makes renders non-deterministic; (c) shared `XDG_RUNTIME_DIR`, so a name-selected `qs ipc` can reach the live bar; (d) fixed `/tmp` log and default out paths, not parallel-safe; (e) renders whatever `~/.config/quickshell/archeotech` points at, not the current worktree; (f) no `--pack/--theme/--material/--side` knobs, so matrices need ad-hoc fake homes; (g) fixed 8 s sleep instead of a readiness signal; (h) pixman means no blur, so glass and blur looks can't be verified; (i) hover and click popups need throwaway `_xharness.qml` at the repo root, and those files **hot-reload onto the live bar's directory**. |
| `scripts/theme-switch.py` (620 lines) | 11 appliers | No `--dry-run`/`--home`/`--no-reload`. `apply_quickshell` runs `qs -c archeotech ipc call theme reload` (live), `apply_mango` runs `mmsg dispatch reload_config` (live, cycles the kb layout), `apply_kitty` does `pkill -USR1 kitty`. It can't be exercised safely by an agent. |
| `install.sh` (both repos) | Stow-based | No `--check` mode. |
| CI shell `ci.yml` | `bash -n`, `py_compile`, JSON validation | No shellcheck, no qmllint (Qt6 plus the Quickshell qmltypes are available in Arch containers: `pacman -S quickshell qt6-declarative`), no render smoke test. |
| CI dotfiles `compositor-config.yml` | Hyprland parse only | No mango config check (`mango -p -c` exists: "Check configuration file error"). |
| Linters locally | `/usr/lib/qt6/bin/{qmllint,qmlformat,qmlls,qmltestrunner}`, `magick`/`compare`, `grim`, `mango`, `qs` present | No `.qmllint.ini`, no `qmldir` files (27 `pragma Singleton` types). The full-repo Qt6 baseline is noisy: 2,013 `missing-property`, 511 `unqualified`, 38 `signal-handler-parameters`, 33 `import`, 23 `incompatible-type`. Most `missing-property` noise comes from singletons that qmllint can't resolve without `qmldir` `singleton` lines. |
| Tests | None | No goldens, no logic tests, no fixtures. |

**What's missing for fast, safe, verifiable iteration:** (1) a render path that can't affect the live
session and renders *this* checkout deterministically; (2) a pre-save syntax gate so a broken save can't
reach the live bar; (3) cheap automatic lint feedback; (4) goldens plus image diff so "does it still look
right" doesn't depend on the model's eye; (5) decoupling the live bar from the dev tree.

---

## 3. logics-manager workflow: cost vs value

**Value.** It is the only durable cross-session memory: ADRs (31), backlog (100), tasks (30), acceptance
criteria, and closeout proof. The CLI protects indicators and lineage. `context-pack` and `read-doc` give
bounded reads. Keep it.

**Cost.**
- 82% of recent dotfiles commits are doc bookkeeping. Every shell wave gets a twin `task_030 wave N` commit,
  so history reads as a changelog of the changelog.
- About 570 CLI calls across the sessions, plus lifecycle traps documented in claude.md (`bootstrap` deletes
  `.claude/`; `flow close task` cascades).
- `implement-task` is generic (single repo, "tests must pass", commit per step) and doesn't know the
  two-repo split or the "owner eyeballs before commit" gate.
- Handoffs live in two places: `shell/docs/*_HANDOFF.md` (public, stale) and logics task docs.
  `context-packs/` holds 1 doc, so the built-in handoff mechanism is barely used.

**Recommendations.**
- **Cadence:** update logics docs at *task* checkpoints (start, owner-approved milestone, closeout), not per
  micro-wave. Use `flow progress` with no commit and fold doc changes into the closeout commit. Target: at
  most 2 `[MD]` commits per task.
- **Tweak lane:** a pure visual tweak (padding, color, 1–3 commits, no new behavior) gets a shell commit only
  and no logics doc. Write this rule into claude.md.
- **Project-scoped `implement-shell-task` skill** (dotfiles `.claude/skills/`) that overrides the generic one
  for this repo. It knows code goes in shell and docs in dotfiles, and runs lint → shot → visual-verifier →
  *ask owner* → commit shell → closeout → one `[MD]` commit.
- **Handoffs → `logics/context-packs/` or the task doc's own notes.** Delete `FLAGSHIP_HANDOFF.md` and
  `FRAME_CORNER_HANDOFF.md` from the public repo (after moving anything still true).
- A `/wrap` end-of-session skill that runs the checklist from claude.md mechanically: dirty-tree summary
  (excluding theme churn paths), logics progress/closeout, docs touched, the commit message drafted in the
  house format, no push.

---

## 4. Underused Claude Code capabilities, applied concretely

### 4.1 Hooks (the largest gain: turns prose rules into enforcement)
- **PreToolUse `Bash` guard.** Blocks `pkill`/`killall` of quickshell, qs or mango; `qs … ipc` without
  `--pid`; bare `grim`; `mango` without `WLR_BACKENDS=headless`; `git push`; `git add -A|--all|.`;
  `logics-manager bootstrap`; `theme-switch.py` without a fake HOME.
- **PreToolUse `Write|Edit` QML syntax gate.** Applies the edit to a temp copy, runs Qt6 qmllint, and blocks
  on syntax errors *before* the save hot-reloads onto the live bar.
- **PostToolUse `Write|Edit` on `.qml`.** Qt6 qmllint filtered to high-signal categories (`syntax`,
  `incompatible-type`, `missing-type`, `import` for unresolved files, `unused-imports`), fed back as context.
- **PreToolUse `Write` guard** on `_*harness.qml` at the shell repo root: redirect harnesses to the scratchpad.
- **Stop hook (non-blocking):** prints the dirty files in both repos (excluding theme-churn paths) and
  "QML edited since last shot: yes/no".

### 4.2 Custom subagents (dotfiles `.claude/agents/`)
- `visual-verifier`: takes PNG paths plus the acceptance criteria and returns a critical verdict. It keeps
  image tokens out of the main context and puts FLAGSHIP rule 3 ("ACTUALLY LOOK… hairline changes are
  invisible = not real") into the agent's own instructions.
- `qml-reviewer`: reviews a diff against the locked constraints (no `layer.enabled` around interactive
  content, `CurveRenderer` for AA, no hardcoded colors, no fire-and-forget toggles, `Quickshell.execDetached`,
  filename-convention widgets, `stateMap` by `screen.name`, WIDGET_API contract).
- `theme-matrix-renderer`: runs the shot matrix (packs × states × material) and returns a contact sheet plus
  diffs against goldens.

### 4.3 Project skills (dotfiles `.claude/skills/`)
- `/shot`: a safe wrapper around the patched `shot.sh`, with a matrix mode and a contact sheet.
- `/verify`: lint changed QML → shot the affected states → visual-verifier → summary.
- `implement-shell-task`, `/wrap`: see section 3.

### 4.4 Git worktrees plus parallel agents
Once `shot.sh --root` renders any checkout, each task can get a worktree
(`git -C ~/Projects/archeotech-shell worktree add ../archeotech-shell.wt/task_031 -b task_031`). Agents then
iterate *without* hot-reloading the live bar, and two tasks can run in parallel, which the `implement-task`
"never two tasks in one repo" rule currently forbids. Keep agent cwd = dotfiles so the instructions load
(the shell `.claude/` is gitignored, so worktrees won't contain it), and pass the worktree path explicitly.

### 4.5 Permissions allowlist (cuts prompts; the `cdx notify` PermissionRequest hook shows prompts do interrupt)
Read-mostly commands that recur in the transcripts: `git status/log/diff/show`, `logics-manager status|sync
read-doc|sync context-pack|lint|audit|health|flow list`, Qt6 qmllint, `magick compare/identify/montage`, and
the shot wrapper. Put an explicit `deny` list alongside it (backed up by the hook, because prefix rules are
easy to sidestep with `cd x && …`).

### 4.6 MCP / plugins
Hold back. Claude already reads PNGs natively and `magick compare` covers image diff, so no screenshot or
image MCP is needed. GitHub: `gh` CLI is enough for a solo repo that is never pushed by Claude. One possibly
worthwhile addition is **qmlls** (`/usr/lib/qt6/bin/qmlls`) as an LSP plugin for go-to-definition and
diagnostics across 123 QML files, if the installed Claude Code supports LSP plugins (verify first).
Consider *removing* `ui-ux-pro-max`'s 7 web/brand skills from this project's context if they're unused for
QML work.

### 4.7 Statusline
Show shell branch and dirty count (excluding theme-churn paths), dotfiles dirty count, the active logics
task (`logics-manager status` cached), and where the live symlink points (`live@<sha>` vs `DEV TREE`).

### 4.8 Scheduled / background
A weekly read-only `project-health` run plus stale-doc detection (compare the claude.md facts section with
`qs --version`, `git log`, and `ls logics/*` counts), writing a single request doc. Low priority.

### 4.9 Visual regression and logic tests
- **Goldens:** `tests/visual/goldens/<pack>/<state>.png`, rendered by `shot.sh` against a fixture HOME
  (fixed config, pack and wallpaper; clock masked or frozen via a `ARCHEOTECH_FIXTURE=1` env var read by the
  clock and sysinfo services). Compare with
  `magick compare -metric AE -fuzz 3% a.png b.png diff.png`, with a threshold per state. Pixman-rendered, so
  goldens are pixman-specific (fine for regression; blur stays a live eyeball item).
- **Logic tests:** `qmltestrunner` can't load the Quickshell runtime, so the most practical path is
  `qs -p tests/Runner.qml` under the nested headless mango. That is a `ShellRoot` that runs assertion
  functions over `Commons/*` token resolution, `ShellConfig` parsing and PackRegistry merge logic, then calls
  `Qt.exit(failures)`. Pure JS helpers can instead be split into `.mjs` and tested with `node --test`.

---

## 5. Prioritized plan

| Pri | Item | Effort | Why |
|---|---|---|---|
| **P0** | A. PreToolUse Bash guard hook | S | Hard-enforces the rules that were broken about 200 times |
| **P0** | B. Isolate `shot.sh` (fake HOME + private XDG_RUNTIME_DIR + minimal `mango -c` + mktemp run dir + `--root`) | M | Removes the live-session leak and makes renders deterministic and parallel-safe |
| **P0** | C. Fix contradictory and stale docs (rewrite SHELL_VISUAL_DEV.md to shot-only, retire the handoffs, update claude.md facts, resolve RTK) | S | The agent follows whichever doc it read last |
| **P0** | D. Qt6 qmllint pre-save syntax gate + post-edit lint hook | S | Keeps broken saves off the live bar and gives free feedback |
| P1 | E. Decouple live bar: `~/.config/quickshell/archeotech -> ~/Projects/archeotech-shell.live` (a `main` worktree) + `archeotech-live {promote,follow,pin,status}` script | S | Ends hot-reload-to-desktop fragility; enables worktrees |
| P1 | F. `/shot` skill + `visual-verifier` agent | S | Standard, cheap and critical visual checks |
| P1 | G. Permissions allowlist/denylist in dotfiles `.claude/settings.json` + `env` for the real HOME | S | Fewer prompts |
| P1 | H. `qml-reviewer` agent | S | Checks diffs against the locked-architecture constraints |
| P1 | I. `implement-shell-task` + `/wrap` skills; lighter logics cadence and a tweak lane | M | Cuts the 82% doc-commit ratio |
| P1 | J. `theme-switch.py --home DIR --no-reload --dry-run` | S | Makes theme work testable in isolation |
| P2 | K. Shot matrix + contact sheet + goldens/VR | L | Regression safety across packs and states |
| P2 | L. `qs -p tests/Runner.qml` logic tests | M | Tests for token resolution, config and pack merge |
| P2 | M. qmllint baseline: generate `qmldir` singleton entries or `.qmllint.ini`, then CI job in an Arch container; shellcheck in CI; `mango -p` in dotfiles CI | M | Real static checks |
| P2 | N. Worktree-per-task + parallel agents (after B+E) | M | Throughput |
| P2 | O. Statusline; clean the inactive `/home/corvus/.claude` (48 agents/commands, dead statusline); drop unused plugin skills | S | Less confusion |
| P2 | P. qmlls LSP plugin; weekly scheduled health agent | S | Nice to have |

---

## 6. Example contents for the top items

### A. Guard hook: `archeotech-dotfiles/.claude/hooks/guard-bash.py`
```python
#!/usr/bin/env python3
"""PreToolUse(Bash) guard: hard-blocks commands that can touch the LIVE session
or violate repo git rules. Exit 2 = block; stderr is shown to Claude."""
import json, re, sys

cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
c = " ".join(cmd.split())            # normalise whitespace / newlines

RULES = [
  (r"\b(pkill|killall)\b[^|;&]*\b(quickshell|qs|mango|Hyprland)\b",
   "Never kill the user's shell/compositor. Ask the user to press SUPER+SHIFT+R."),
  (r"\bqs\b(?![^|;&]*--pid)[^|;&]*\bipc\b",
   "qs ipc without --pid can drive the LIVE bar. Use scripts/shot.sh --state … instead."),
  (r"(^|[;&|(]\s*)grim\b",
   "Direct grim captures the user's real output. Use scripts/shot.sh (headless) instead."),
  (r"(^|[;&|]\s*)(\S+=\S+\s+)*mango\b(?![^|;&]*WLR_BACKENDS=headless)",
   "Only launch mango via scripts/shot.sh (headless, isolated config)."),
  (r"\bgit\b[^|;&]*\bpush\b", "Never git push; leave it to the user."),
  (r"\bgit\b[^|;&]*\badd\s+(-A|--all|\.(\s|$))",
   "Stage explicit paths; theme-switch churn must stay unstaged."),
  (r"\blogics-manager\s+bootstrap\b",
   "bootstrap deletes .claude/; ask the user first."),
  (r"theme-switch\.(py|sh)(?![^|;&]*--home)",
   "theme-switch reloads the LIVE compositor/shell. Use --home <fakehome> --no-reload."),
]
for pat, why in RULES:
    if re.search(pat, c):
        print(f"BLOCKED by archeotech guard: {why}\n  cmd: {cmd[:200]}", file=sys.stderr)
        sys.exit(2)
sys.exit(0)
```
The grim and mango rules are allowed *inside* `shot.sh`, because the hook only sees the top-level command
string, not the script body.

### A+D. `archeotech-dotfiles/.claude/settings.json` (project, versioned)
```json
{
  "env": {
    "ARCHEOTECH_REAL_HOME": "/home/corvus",
    "ARCHEOTECH_SHELL": "/home/corvus/Projects/archeotech-shell",
    "QMLLINT": "/usr/lib/qt6/bin/qmllint"
  },
  "permissions": {
    "allow": [
      "Bash(git status:*)", "Bash(git log:*)", "Bash(git diff:*)", "Bash(git show:*)",
      "Bash(git -C /home/corvus/Projects/archeotech-shell status:*)",
      "Bash(git -C /home/corvus/Projects/archeotech-shell log:*)",
      "Bash(git -C /home/corvus/Projects/archeotech-shell diff:*)",
      "Bash(logics-manager status:*)", "Bash(logics-manager health:*)",
      "Bash(logics-manager lint:*)", "Bash(logics-manager audit:*)",
      "Bash(logics-manager sync read-doc:*)", "Bash(logics-manager sync context-pack:*)",
      "Bash(logics-manager sync search-docs:*)", "Bash(logics-manager flow list:*)",
      "Bash(/usr/lib/qt6/bin/qmllint:*)",
      "Bash(magick identify:*)", "Bash(magick compare:*)", "Bash(magick montage:*)",
      "Bash(/home/corvus/Projects/archeotech-shell/scripts/shot.sh:*)"
    ],
    "deny": [
      "Bash(git push:*)", "Bash(pkill:*)", "Bash(killall:*)",
      "Bash(logics-manager bootstrap:*)", "Bash(grim:*)"
    ]
  },
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "python3 \"$CLAUDE_PROJECT_DIR/.claude/hooks/guard-bash.py\"" }] },
      { "matcher": "Write|Edit|MultiEdit",
        "hooks": [{ "type": "command", "command": "python3 \"$CLAUDE_PROJECT_DIR/.claude/hooks/qml-syntax-gate.py\"" }] }
    ],
    "PostToolUse": [
      { "matcher": "Write|Edit|MultiEdit",
        "hooks": [{ "type": "command", "command": "python3 \"$CLAUDE_PROJECT_DIR/.claude/hooks/qml-lint.py\"" }] }
    ],
    "Stop": [
      { "hooks": [{ "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/stop-summary.sh\"" }] }
    ]
  }
}
```
Merge with, don't replace, the profile-level `cdx notify` hooks, which live in the user profile and keep
working. If the rtk hook is re-enabled in the active profile, note that it auto-*allows*; a hook `deny`
still takes precedence.

### D. `qml-syntax-gate.py` (sketch)
```python
#!/usr/bin/env python3
# PreToolUse(Write|Edit): simulate the save on a temp copy; block only on SYNTAX errors
# (imports can't resolve outside the tree, so ignore everything else here).
import json, os, subprocess, sys, tempfile
ev = json.load(sys.stdin); ti = ev.get("tool_input", {})
path = ti.get("file_path", "")
if not path.endswith(".qml"): sys.exit(0)
if ev.get("tool_name") == "Write":
    new = ti.get("content", "")
else:
    old = open(path).read() if os.path.exists(path) else ""
    edits = ti.get("edits") or [ti]
    new = old
    for e in edits:
        new = new.replace(e["old_string"], e["new_string"], -1 if e.get("replace_all") else 1)
with tempfile.NamedTemporaryFile("w", suffix=".qml", delete=False) as f:   # OUTSIDE the watched tree
    f.write(new); tmp = f.name
r = subprocess.run([os.environ.get("QMLLINT", "/usr/lib/qt6/bin/qmllint"), tmp],
                   capture_output=True, text=True)
os.unlink(tmp)
errs = [l for l in (r.stdout + r.stderr).splitlines() if "[syntax]" in l or "Error:" in l]
if errs:
    print("QML syntax error; this save would break the LIVE bar on hot-reload:\n" +
          "\n".join(errs[:10]), file=sys.stderr)
    sys.exit(2)
```
`qml-lint.py` (PostToolUse) runs Qt6 qmllint in place with `--json -`, keeps the categories `syntax,
incompatible-type, missing-type, unused-imports, import` (dropping the singleton-noise `missing-property` /
`unqualified` until `qmldir` is fixed), and exits 2 with a compact list so Claude sees it. Target runtime is
about 0.1 s.

### B. `shot.sh` isolation patch (sketch)
```bash
# --- new flags ---------------------------------------------------------------
ROOT=""; PACK=""; FIXTURE=""; KEEP=0
#   --root <dir>     render THIS checkout/worktree (default: repo containing shot.sh)
#   --pack <id>      force appearance.activePack in the fake config
#   --fixture <dir>  seed fake HOME from a fixture tree (deterministic goldens)
#   --keep           keep the run dir for debugging
ROOT="${ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
REAL_HOME="${ARCHEOTECH_REAL_HOME:-/home/corvus}"

RUN="$(mktemp -d "${TMPDIR:-/tmp}/archeotech-shot.XXXXXX")"
FAKE="$RUN/home"; RT="$RUN/rt"; mkdir -p "$RT"; chmod 700 "$RT"
trap '[ "$KEEP" = 1 ] || rm -rf "$RUN"' EXIT
mkdir -p "$FAKE"/.config/{quickshell,archeotech,mango} "$FAKE"/.local/share/archeotech "$FAKE"/.cache
ln -s "$ROOT" "$FAKE/.config/quickshell/archeotech"            # render THIS tree
# read-only inputs from the real home (fonts/icons/wallpapers), never writable state
for d in .local/share/fonts .local/share/icons .config/archeotech/wallpapers; do
  [ -e "$REAL_HOME/$d" ] && mkdir -p "$(dirname "$FAKE/$d")" && ln -s "$REAL_HOME/$d" "$FAKE/$d"
done
if [ -n "$FIXTURE" ]; then cp -r "$FIXTURE/." "$FAKE/"
else  # snapshot (copy, not symlink) so the nested shell can't clobber real config
  for f in config.json theme.json shell-config.json; do
    [ -f "$REAL_HOME/.config/archeotech/$f" ] && cp "$REAL_HOME/.config/archeotech/$f" "$FAKE/.config/archeotech/"
  done
fi
[ -n "$PACK" ] && python3 - "$FAKE/.config/archeotech/config.json" "$PACK" <<'PY'
import json,sys,os; p,k=sys.argv[1:]; c=json.load(open(p)) if os.path.exists(p) else {}
c.setdefault("appearance",{})["activePack"]=k; json.dump(c,open(p,"w"))
PY
# minimal compositor config: NO exec-once, no autostart
cat > "$RUN/mango.conf" <<'EOF'
borderpx=0
border_radius=0
gappoh=0
gappov=0
EOF
# logs and default output live in the run dir → parallel-safe
LOGQ="$RUN/qs.log"; LOGM="$RUN/mango.log"; OUT="${OUT:-$RUN/shot.png}"

env -i PATH="$PATH" HOME="$FAKE" XDG_RUNTIME_DIR="$RT" \
    XDG_CONFIG_HOME="$FAKE/.config" XDG_DATA_HOME="$FAKE/.local/share" \
    XDG_CACHE_HOME="$FAKE/.cache" XDG_STATE_HOME="$FAKE/.local/state" \
    WLR_BACKENDS=headless WLR_HEADLESS_OUTPUTS=1 WLR_RENDERER=pixman \
  timeout … dbus-run-session -- mango -c "$RUN/mango.conf" -s "$STARTUP" >"$LOGM" 2>&1 &
```
Effects: the private `XDG_RUNTIME_DIR` means even `qs -c archeotech ipc` *inside* nested can only see the
nested instance, and the Wayland and awww sockets can't collide. `env -i` drops the live
`WAYLAND_DISPLAY`/`DBUS_SESSION_BUS_ADDRESS`. Real state and config are never written. `--root` makes
worktrees renderable. Replace the fixed `sleep $WAIT` with a poll for a readiness line in `$LOGQ`
(`Configuration Loaded`) plus a short settle. Add `--harness <file>` so popup harnesses live in `$RUN`, not
the repo root; relative imports then need `import "file://$ROOT/Commons"`, or copy the harness beside a
symlinked tree inside `$RUN`. Afterwards, `HOME=/home/corvus` is no longer required, and that advice should
be removed from claude.md.

### E. Live/dev decoupling (`scripts/archeotech-live`)
```bash
# one-time: git -C ~/Projects/archeotech-shell worktree add ~/Projects/archeotech-shell.live main
# archeotech-live promote   → git -C …shell.live merge --ff-only main   (user-initiated hot reload)
# archeotech-live follow    → symlink ~/.config/quickshell/archeotech → dev tree (old behaviour)
# archeotech-live pin       → symlink → .live worktree
# archeotech-live status    → prints target + sha (statusline reads this)
```
When pinned, agent edits never touch the desktop. The owner's "see it live" becomes an explicit
`archeotech-live promote` (or `follow` during an eyeballing session). The guard hook can block `follow` and
`promote` so that only the user runs them.

### F. `visual-verifier` agent: `.claude/agents/visual-verifier.md`
```markdown
---
name: visual-verifier
description: Critically judge Archeotech shell renders against acceptance criteria. Use after any visual QML change; give it PNG paths (from /shot) and the AC. Returns PASS/FAIL per criterion with pixel-region evidence.
tools: Read, Bash
model: sonnet
---
You review headless renders (pixman: NO blur; judge glass by tint/edges only).
Rules:
- Open every PNG with Read. For small details, crop first: `magick in.png -crop WxH+X+Y +repage -scale 400% crop.png`.
- Judge "does it read as the goal", not "did something change". A 1px hairline that is invisible at 100% = FAIL.
- If a golden exists, run `magick compare -metric AE -fuzz 3% golden.png new.png diff.png` and look at diff.png.
- Never run grim, qs ipc, or anything outside scripts/shot.sh.
Output: a table {criterion | PASS/FAIL | evidence (file + region)} and a one-line verdict. No praise.
```

### F. `/shot` skill: `.claude/skills/shot/SKILL.md` (outline)
```markdown
---
name: shot
description: Render the Archeotech shell headlessly and safely (never the live session). Use to see any visual change: full shell, a named state, a pack/state matrix, or one component via a harness.
---
1. Pick the tree: `--root` = the worktree being edited (default main checkout).
2. Single: `scripts/shot.sh --root R [--pack P] [--state S] OUT.png`
   Matrix: for P in packs/*, S in {none,launcher,dashboard,settings:appearance,notifications}
   → then `magick montage *.png -tile 5x -geometry +4+4 sheet.png` (read ONE image, not 20).
3. Popups with no IPC: write the harness to the scratchpad (never the repo root), `--qml`.
4. Hand the PNGs + AC to the `visual-verifier` agent; don't self-grade.
5. On FAILED: read `$RUN/qs.log` (rerun with `--keep`).
Never: grim, qs ipc without --pid, HOME=/home/corvus theme-switch, mango outside shot.sh.
```

### H. `qml-reviewer` agent (frontmatter + checklist)
```markdown
---
name: qml-reviewer
description: Review a QML diff in archeotech-shell against the locked architecture and ADRs before commit. Use with `git -C <tree> diff` output or a commit range.
tools: Read, Grep, Glob, Bash
model: sonnet
---
Check, citing file:line:
- interactive content inside `layer.enabled` (swallows hover) → must use Shape.CurveRenderer
- hardcoded colors / sizes instead of Appearance tokens
- fire-and-forget shell toggles instead of bound state (design rule 6)
- process launches not via Quickshell.execDetached
- widget file naming (Widgets/Bar/<Id>Widget.qml) + configSchema per docs/WIDGET_API.md
- per-screen state not keyed by screen.name
- new Process/poll loops without visibility gating (leak/CPU; see pactl leak history)
- run $QMLLINT on changed files; report only new warnings vs `git stash`-free baseline (lint HEAD copy in /tmp)
Report: blocking / should-fix / nit. Do not edit files.
```

### C. Doc fixes (concrete)
- `shell/docs/SHELL_VISUAL_DEV.md`: delete the "Environment for every grim / IPC call" and "drive by IPC,
  then grim" sections. Replace them with `shot.sh --state` and `--harness`; keep the tokens and gotchas.
- Move the still-valid content of `FLAGSHIP_HANDOFF.md` and `FRAME_CORNER_HANDOFF.md` into the relevant
  logics task/backlog notes, then delete them from the public repo.
- `.claude/claude.md`: Quickshell 0.3.1 + native Pipewire adopted; "qmllint = `/usr/lib/qt6/bin/qmllint`
  (the `/usr/bin` one is Qt5)"; drop "shot.sh needs HOME=/home/corvus" once B lands; one commit policy
  ("commit only after owner OK on visual milestones; logic/doc fixes may commit directly"); the tweak-lane
  rule.
- `.claude/PLANNING.md`: drop the hardcoded counts.
- RTK: either install the rtk hook in the active cdx profile, or remove `@RTK.md` from
  `/home/corvus/.claude/CLAUDE.md`.
- Archive or remove the inactive `/home/corvus/.claude/{agents,commands}` (96 logics-kit files) and its
  dead statusline.

### Stop-summary hook (`stop-summary.sh`, non-blocking)
```bash
#!/bin/bash
CHURN='gtk-[34].0/settings.ini|kitty/current-theme.conf|rofi/colors.rasi|mango/config.conf|environment.d/cursor.conf|fish_variables'
s=$(git -C "$ARCHEOTECH_SHELL" status --short | wc -l)
d=$(git -C "$CLAUDE_PROJECT_DIR" status --short | grep -vE "$CHURN" | wc -l)
echo "{\"systemMessage\":\"archeotech: shell dirty=$s, dotfiles dirty(excl. theme churn)=$d\"}"
```
