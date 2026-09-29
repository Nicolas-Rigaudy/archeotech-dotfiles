---
name: shell-item
description: Implement one archeotech-shell backlog item end to end the way the 2026-09-28 sessions did - logics task, isolated worktree, A/B proof against unfixed main, qml-reviewer, land on main by path, closeout. Use when asked to implement/fix/build a shell item (item_1xx etc.).
---
# /shell-item - one shell item, proven and landed

One item per run. Nothing touches the live bar until the verified change lands on
`main` (and if `archeotech-live.sh status` says PINNED, not even then).

1. **Task.** `logics-manager flow promote backlog-to-task <item>`; read the item
   (`logics-manager sync read-doc <item>`) and its evidence in
   `.claude/audits/2026-09-28/`. Fill the task's AI Context and Plan (replace the
   `(unfilled …)` lines), then `logics-manager flow start <task> --owner claude`.
2. **Worktree.** `git -C ~/Projects/archeotech-shell worktree add -q -b fix/<item> ~/Projects/archeotech-shell.wt/<item> main`.
   Edit ONLY there. Temporary `console.log("PROBE-…")` lines are fine in the worktree
   (never committed); grep `PROBE` to zero before committing.
3. **Prove the bug, then the fix (A/B).** Render unfixed main and the worktree with
   `scripts/shot.sh` (see `/shot`): `--root <wt>`, `--keep` (logs in
   `<run>/log/qs.log`, intercepted live scripts in `<run>/log/stubs.log`),
   `--set key=value`, `--shell-config f.json`, `--notify-count N`, `--burst N -i S`,
   `--fresh` (stranger's first boot), `--theme/--pack/--flat`. Components with no
   IPC state: a `--qml` harness in the scratchpad (absolute imports need `file:`;
   Appearance colours are undefined outside the full shell, so test behaviour in the
   full shell where possible). Measure, don't eyeball: counts from probes, crops
   stacked with `magick`. Before landing, `scripts/golden.sh --root <wt>` must pass
   except for scenarios the item intends to change (regenerate those with
   `<wt>/scripts/golden.sh --update --only`: the WORKTREE's copy, since golden.sh
   writes into the checkout the script lives in, and main's copy would overwrite
   main's goldens), and land the PNGs with the fix, plus `tests/run.sh`.
4. **Lint + review.** Qt6 `/usr/lib/qt6/bin/qmllint` (the hooks run it on Edit/Write;
   Python/sed edits bypass the pre-save gate, so lint those by hand). Known false
   positives: singleton `missing-property` / `Cannot assign binding of type X to
   QObject` (no qmldir yet). Then the `qml-reviewer` agent on the worktree diff;
   apply its should-fixes, re-verify.
5. **Land by path.** Commit on the branch with `git commit -m "…" -- <paths>`, then
   on main: `rtk proxy git -C <wt> diff <base> HEAD -- <paths> | git apply` (the RTK hook
   rewrites a bare `git diff` to a compact summary, which `git apply` rejects), `git add` new
   files, `git commit -m "…" -- <paths>` (the owner may have WIP or staged work on
   main — never a bare commit), check `git diff --quiet <branch> HEAD -- <paths>`,
   then `git worktree remove` + `git branch -D`. Message style: `fix[QML]: …`.
6. **Close out** (each step is a CLI call; never hand-edit indicators/status/lineage):
   `sync append-note <task> --section validation` (the real commands and numbers),
   `--section report`; `flow repair ac-traceability req_005_…` (writes placeholder
   lines for all six request ACs — into EVERY task of the request, including closed
   ones: `git status logics` afterwards and `git checkout --` the already-committed
   tasks it touched) then rewrite this task's `# AC Traceability` to the one AC it
   actually proves; `flow repair gates <task>`; `flow progress task <task>
   --progress 100%`; `flow closeout <task> --validation-command "…"
   --validation-result passed --lint`; `flow close backlog <item>`; commit `logics/`.
   An item whose acceptance needs the owner (e.g. a live reload) stays In progress
   with a decision note saying what is pending.

Also never let `flow repair links` loose without reading its diff: on
2026-09-28 it rewrote prod_001's header (Status -> Settled, 60-item backlog list cut
to one). Restore anything it changes outside the chain you are working on.

Never: run theme-switch, grim, `qs ipc` without `--pid`, `qs -c archeotech`, mango,
pkill — the guard hook blocks these; if it blocks something legitimate, fix the
guard and add a case to `.claude/hooks/test_guard_bash.py`.
