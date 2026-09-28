#!/bin/bash
# Stop hook (non-blocking): one-line dirty summary for both repos, excluding the
# theme-switch churn paths that are routinely dirty and never committed.
CHURN='gtk-[34]\.0/settings\.ini|kitty/current-theme\.conf|rofi/colors\.rasi|mango/config\.conf|environment\.d/cursor\.conf|fish_variables'
SHELL_REPO="${ARCHEOTECH_SHELL:-/home/corvus/Projects/archeotech-shell}"
DOT="${CLAUDE_PROJECT_DIR:-/home/corvus/Projects/archeotech-dotfiles}"
s=$(git -C "$SHELL_REPO" status --short 2>/dev/null | wc -l)
d=$(git -C "$DOT" status --short 2>/dev/null | grep -cvE "$CHURN")
printf '{"systemMessage":"archeotech: shell dirty=%s, dotfiles dirty (excl. theme churn)=%s"}\n' "$s" "$d"
