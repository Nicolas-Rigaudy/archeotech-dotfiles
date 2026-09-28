#!/usr/bin/env python3
"""Regression cases for guard-bash.py. Run: python3 .claude/hooks/test_guard_bash.py"""
import json
import os
import subprocess
import sys

HOOK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "guard-bash.py")

BLOCK = [
    "pkill quickshell", "killall -9 mango", "qs -c archeotech ipc call dashboard open",
    "cd x && qs ipc call bar toggle", "grim /tmp/x.png", "sleep 1; grim -o eDP-1 out.png",
    "mango -s foo", "WLR_BACKENDS=headless mango", "qs -c archeotech", "git push",
    "git -C ../x push origin main", "git add -A", "git add .", "git add logics .",
    "git commit -am wip", "git commit -a -m x", "logics-manager bootstrap",
    "theme-switch.py catppuccin", "HOME=/home/corvus theme-switch.py x",
    'bash -c "pkill quickshell"', "sh -c 'grim out.png'", "bash -c 'theme-switch.py nord'",
    "HOME=/tmp/fh theme-switch.py x", "python3 scripts/theme-switch.py --family nord",
    "~/.local/bin/theme-switch.sh archeotech-latte",
]
ALLOW = [
    "git status", "git add logics .claude/PLANNING.md", "git add ./scripts/shot.sh",
    "git commit -q -m 'fix: add -a flag doc' -- x", 'git commit -m "don\'t push yet" -- x',
    "git commit --amend --no-edit", "grep -rn grim scripts/", "qs ipc --pid 123 call settings open",
    "./scripts/shot.sh --state launcher out.png", "mango -h",
    "grep -n pkill scripts/theme-switch.py", "cat scripts/theme-switch.sh | head",
    "cat logics/x.md | grep push", "echo mango", "rg 'qs -c archeotech' docs",
    'logics-manager sync append-note t --text "blocks pkill/killall shell, qs ipc, grim, theme-switch on the real HOME"',
]


def rc(cmd):
    p = subprocess.run([sys.executable, HOOK], input=json.dumps({"tool_name": "Bash", "tool_input": {"command": cmd}}),
                       capture_output=True, text=True)
    return p.returncode


fails = [f"should block: {c}" for c in BLOCK if rc(c) != 2] + [f"should allow: {c}" for c in ALLOW if rc(c) != 0]
print("\n".join(fails) or f"ok: {len(BLOCK)} blocked, {len(ALLOW)} allowed")
sys.exit(1 if fails else 0)
