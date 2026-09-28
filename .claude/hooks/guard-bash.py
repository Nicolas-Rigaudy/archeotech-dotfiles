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
# Heredoc bodies are data fed to a program's stdin (a Python edit script, a file
# being written), not commands this shell runs; drop them before matching.
# `bash <<EOF` / `sh <<EOF` bodies ARE scripts, so those are kept.
def _strip_heredocs(text):
    def repl(m):
        return m.group(0) if re.search(r"\b(?:ba|z)?sh\s*$", m.group(1)) else m.group(1) + "<<HEREDOC"
    return re.sub(r"([^\n]*?)<<-?\s*['\"]?(\w+)['\"]?[^\n]*\n.*?\n\s*\2\b", repl, text, flags=re.S)
cmd_body = _strip_heredocs(cmd)
c = " ".join(cmd_body.split())  # normalise whitespace / newlines
# Rules match with quoted strings blanked, so prose inside a commit message or a
# logics note ("don't push", "pkill") is not mistaken for a command. The inner
# script of `bash -c '...'` / `sh -c "..."` is checked too, so wrapping a
# forbidden command in a shell string does not slip past.
QUOTED = r"'([^']*)'|\"((?:[^\"\\]|\\.)*)\""
unquoted = re.sub(QUOTED, "''", c)
inner = [a or b for a, b in re.findall(r"\b(?:ba|z)?sh\s+-c\s+(?:" + QUOTED + ")", c)]
targets = [unquoted] + inner

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
    if any(re.search(pat, t) for t in targets):
        print(f"BLOCKED by archeotech guard: {why}\n  cmd: {cmd[:200]}", file=sys.stderr)
        sys.exit(2)

# Running theme-switch always touches the LIVE session: it rewrites tracked
# configs under $HOME and, whatever $HOME is, sends SIGUSR1 to every kitty by
# process name. Only EXECUTING it is blocked (command position, optionally via an
# interpreter); reading or grepping the file is fine. Renders go through shot.sh,
# which stubs it.
TS_EXEC = AT + r"(?:(?:python3?|bash|sh)\s+)?\S*theme-switch\.(?:py|sh)\b"
if any(re.search(TS_EXEC, t) for t in targets):
    print("BLOCKED by archeotech guard: theme-switch applies to the LIVE session "
          "(configs + a kitty signal, even with a fake HOME). Ask the user; for "
          f"renders use scripts/shot.sh, which stubs it.\n  cmd: {cmd[:200]}", file=sys.stderr)
    sys.exit(2)

sys.exit(0)
