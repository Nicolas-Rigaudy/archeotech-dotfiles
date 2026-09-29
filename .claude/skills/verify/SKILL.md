---
name: verify
description: Verify-before-done checklist for an archeotech-shell change. Use before claiming any shell item is done - lint, review, isolated renders across dark/light/packs, independent visual verdict.
---
# /verify - before calling a shell change done

Run every step; report each result. A step you skip is reported as skipped, not passed.

1. **Scope.** List the changed files: `git -C <tree> diff --stat [base]`.
2. **Lint.** `/usr/lib/qt6/bin/qmllint` on each changed `.qml`; any `[syntax]`,
   `[incompatible-type]` or new `[unused-imports]` must be fixed.
3. **Review.** Hand the diff to the `qml-reviewer` agent. Blocking findings must be
   fixed before continuing.
4. **Render.** With `/shot`, render every state the change touches in at least:
   dark (archeotech-macchiato), light (archeotech-latte), flat mode, and the grimdark pack.
   Build one contact sheet.
4b. **Goldens + tests.** `scripts/golden.sh --root <tree>` (the whole matrix, ~3 min)
   and `tests/run.sh`. A FAIL on a scenario the change was *meant* to alter: look at
   `<run>/diff/<name>.diff.png`, then `golden.sh --root <tree> --update --only
   '<those>'` and commit the new goldens with the change. A FAIL anywhere else is a
   regression.
5. **Judge.** Give the contact sheet and the acceptance criteria to the
   `visual-verifier` agent. Any FAIL goes back to step 1.
6. **Live safety.** Confirm nothing ran against the live session (no grim, no qs ipc
   without --pid) and the real `~/.config/archeotech` is untouched.
7. **Record.** Put the commands you actually ran and their results in the task's
   Validation section via `logics-manager sync append-note <task> --section validation`.

Only then move the task toward Done.
