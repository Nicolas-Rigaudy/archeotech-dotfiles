#!/usr/bin/env python3
"""PreToolUse(Bash) guard for archeotech work.

Hard-blocks commands that can touch the owner's LIVE desktop session or break
the repo git rules (see .claude/claude.md "Durable feedback"). Exit 2 blocks the
call; stderr is shown to Claude. Commands inside scripts/shot.sh are not seen
here (the hook only sees the top-level command line), so shot.sh's own nested
mango/grim/qs-ipc calls stay allowed.
"""
import json
import re
import sys

cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
c = " ".join(cmd.split())  # normalise whitespace / newlines
# git rules match with quoted strings blanked, so a commit message that mentions
# "push" or "-a" is not mistaken for the flag; kill/ipc/grim rules keep the full
# line so `bash -c "pkill qs"` is still caught.
unquoted = re.sub(r"'[^']*'|\"(?:[^\"\\]|\\.)*\"", "''", c)

# A command-position anchor: start of line or after ; & | ( && || $( `
AT = r"(?:^|[;&|(`]\s*|\$\(\s*)(?:\w+=\S*\s+)*"

RULES = [
    (r"\b(pkill|killall)\b[^|;&]*\b(quickshell|qs|mango|Hyprland|awww-daemon)\b",
     "Never kill the user's shell/compositor. Ask the user to press SUPER+SHIFT+R."),
    (AT + r"(?:qs|quickshell)\b(?![^|;&]*--pid)[^|;&]*\bipc\b",
     "qs ipc without --pid can drive the LIVE bar. Use scripts/shot.sh --state ... instead."),
    (AT + r"grim\b",
     "grim captures the user's real screen. Use scripts/shot.sh (isolated, headless)."),
    (AT + r"mango\b(?!\s+-[hvp]\b)",
     "Only launch mango via scripts/shot.sh (headless, isolated config)."),
    (AT + r"(?:qs|quickshell)\s+(?:-c\s+archeotech|--config\s+archeotech)\b(?![^|;&]*\bipc\b)",
     "Launching a second archeotech shell on the live session. Use scripts/shot.sh."),
    (r"\bgit\b[^|;&]*\bpush\b",
     "Never git push; leave pushing to the user."),
    (r"\bgit\b[^|;&]*\badd\s+(?:[^|;&]*\s)?(-A|--all|\.)(?=\s|$|[;&|])",
     "Stage explicit paths only; theme-switch churn must stay unstaged."),
    (r"\bgit\b[^|;&]*\bcommit\b[^|;&]*\s-[a-zA-Z]*a[a-zA-Z]*(?=\s|$)",
     "git commit -a stages theme churn. Commit explicit paths (git commit -- <paths>)."),
    (r"\blogics-manager\s+bootstrap\b",
     "logics-manager bootstrap deletes .claude/; ask the user first."),
]

for pat, why in RULES:
    target = unquoted if pat.startswith(r"\bgit\b") else c
    if re.search(pat, target):
        print(f"BLOCKED by archeotech guard: {why}\n  cmd: {cmd[:200]}", file=sys.stderr)
        sys.exit(2)

# theme-switch rewrites tracked configs and reloads the LIVE compositor/shell,
# unless HOME points somewhere other than the real home.
if re.search(r"theme-switch\.(py|sh)\b", c):
    m = re.search(r"\bHOME=(\S+)", c)
    if not m or m.group(1).rstrip("/") in ("/home/corvus", "~", "$HOME"):
        print("BLOCKED by archeotech guard: theme-switch applies to the LIVE session. "
              "Ask the user, or run it with HOME=<fake home> for an isolated test.\n"
              f"  cmd: {cmd[:200]}", file=sys.stderr)
        sys.exit(2)

sys.exit(0)
