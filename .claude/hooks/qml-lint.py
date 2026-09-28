#!/usr/bin/env python3
"""PostToolUse(Write|Edit) Qt6 qmllint on the edited .qml file.

Runs the real Qt6 linter (/usr/bin/qmllint is the Qt5 one and checks nothing
here) and feeds high-signal findings back to Claude. The singleton-noise
categories (missing-property, unqualified, import warnings caused by the
Commons singletons lacking a qmldir) are dropped until that qmldir lands.
"""
import json
import os
import subprocess
import sys

QMLLINT = os.environ.get("QMLLINT", "/usr/lib/qt6/bin/qmllint")
KEEP = ("[syntax]", "[incompatible-type]", "[unused-imports]", "[duplicated-name]",
        "[read-only-property]", "[deprecated]", "[unresolved-alias]", "[missing-enum-entry]")

ev = json.load(sys.stdin)
path = ev.get("tool_input", {}).get("file_path", "")
if not path.endswith(".qml") or not os.path.exists(path) or not os.path.exists(QMLLINT):
    sys.exit(0)

r = subprocess.run([QMLLINT, os.path.basename(path)], cwd=os.path.dirname(path),
                   capture_output=True, text=True, timeout=30)
hits = [l for l in (r.stdout + r.stderr).splitlines() if any(k in l for k in KEEP)]
if hits:
    print(f"qmllint (Qt6) on {path}:\n" + "\n".join(hits[:15]), file=sys.stderr)
    sys.exit(2)  # PostToolUse: exit 2 feeds stderr back to Claude (file already saved)
sys.exit(0)
