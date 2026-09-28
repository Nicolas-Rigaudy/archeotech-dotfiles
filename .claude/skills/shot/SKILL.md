---
name: shot
description: Render the Archeotech shell headlessly and safely, never touching the live session. Use to see any visual change - the full shell, a named panel state, a theme/pack/mode matrix with a contact sheet, or one component via a harness.
---
# /shot - isolated shell renders

`scripts/shot.sh` (archeotech-shell) runs a nested headless mango with a fake HOME,
a private runtime dir and its own D-Bus, so nothing it does reaches the live bar or
the real config. No `HOME=` prefix is needed any more.

1. **Pick the tree.** `--root <dir>` renders any checkout or worktree; default is the
   repo the script lives in. When editing in a worktree, always pass `--root`.
2. **Single render**
   ```bash
   /home/corvus/Projects/archeotech-shell/scripts/shot.sh --root R \
     [--state launcher|dashboard|settings:<pane>|media|wallpaper|notifications|editmode] \
     [--theme <themes/ dir>] [--pack base|grimdark|...] [--flat 0|1] OUT.png
   ```
3. **Matrix.** Loop the flags, then build ONE contact sheet and read only that:
   ```bash
   for t in archeotech-macchiato archeotech-latte; do for p in base grimdark; do
     shot.sh --root R --theme $t --pack $p --state dashboard "$D/$t-$p.png"; done; done
   magick montage "$D"/*.png -tile 2x -geometry 640x360+4+4 -label '%t' "$D/sheet.png"
   ```
   Runs are independent, so two can run in parallel; keep it to two or three at once.
4. **Popups with no IPC state** (hover cards, tray menu): write a small harness QML to
   the scratchpad (never the repo root) and render it with `--qml <path>`.
5. **Judge with the `visual-verifier` agent** (pass PNG paths and the criteria). Do not
   self-grade renders.
6. **On FAILED** rerun with `--keep` and read `<run dir>/log/qs.log` and `mango.log`.

Never: bare `grim`, `qs ipc` without `--pid`, `qs -c archeotech`, launching `mango`
yourself, or theme-switch against the real HOME. The guard hook blocks these.
