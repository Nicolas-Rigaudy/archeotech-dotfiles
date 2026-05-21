#!/usr/bin/env bash
# Outputs: name|branch|dirty_count (one line per git repo found)

scan_dir() {
    local dir="$1"
    [ -d "$dir" ] || return
    for d in "$dir"/*/; do
        [ -d "$d/.git" ] || continue
        name=$(basename "$d")
        branch=$(git -C "$d" branch --show-current 2>/dev/null || echo "?")
        dirty=$(git -C "$d" status --short 2>/dev/null | wc -l | tr -d ' ')
        echo "$name|${branch:-detached}|$dirty"
    done
}

scan_dir "$HOME/Projects"
scan_dir "$HOME/Documents/repos"
