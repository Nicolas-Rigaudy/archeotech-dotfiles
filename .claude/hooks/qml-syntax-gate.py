#!/usr/bin/env python3
"""PreToolUse(Write|Edit) gate for .qml files.

Shell QML hot-reloads onto the owner's live bar the moment it is saved, so a
syntax error would break their desktop. This applies the pending edit to a temp
copy OUTSIDE the watched tree, runs Qt6 qmllint on it, and blocks the save only
on [syntax] errors (imports cannot resolve from the temp dir, so everything else
is ignored here; qml-lint.py reports the rest after the save).
"""
import json
import os
import subprocess
import sys
import tempfile

QMLLINT = os.environ.get("QMLLINT", "/usr/lib/qt6/bin/qmllint")

ev = json.load(sys.stdin)
ti = ev.get("tool_input", {})
path = ti.get("file_path", "")
if not path.endswith(".qml") or not os.path.exists(QMLLINT):
    sys.exit(0)

if ev.get("tool_name") == "Write":
    new = ti.get("content", "")
else:
    try:
        new = open(path, encoding="utf-8").read()
    except OSError:
        sys.exit(0)  # new file via Edit is impossible; let the tool report it
    for e in ti.get("edits") or [ti]:
        old_s, new_s = e.get("old_string", ""), e.get("new_string", "")
        if old_s not in new:
            sys.exit(0)  # the Edit tool itself will fail; nothing to gate
        new = new.replace(old_s, new_s, -1 if e.get("replace_all") else 1)

with tempfile.NamedTemporaryFile("w", suffix=".qml", delete=False, encoding="utf-8") as f:
    f.write(new)
    tmp = f.name
try:
    r = subprocess.run([QMLLINT, tmp], capture_output=True, text=True, timeout=20)
finally:
    os.unlink(tmp)

errs = [l.replace(tmp, os.path.basename(path)) for l in (r.stdout + r.stderr).splitlines()
        if "[syntax]" in l]
if errs:
    print("QML syntax error: this save would break the LIVE bar on hot-reload. Fix before saving:\n"
          + "\n".join(errs[:10]), file=sys.stderr)
    sys.exit(2)
sys.exit(0)
