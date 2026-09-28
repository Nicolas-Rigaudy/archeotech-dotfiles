#!/bin/bash
################################################################################
# archeotech-live.sh — keep the LIVE bar on a pinned checkout of the shell.
#
# By default ~/.config/quickshell/archeotech points at the dev checkout, so every
# saved edit hot-reloads straight onto the running bar — including half-finished
# work and edits made by agents in a session. This script moves the live bar onto
# a separate git worktree that only changes when you promote a commit to it.
#
#   archeotech-live.sh status           # where the live bar points, and at what
#   archeotech-live.sh init             # create the live worktree, point the bar at it
#   archeotech-live.sh promote [ref]    # move the live bar to <ref> (default: main)
#   archeotech-live.sh follow           # point the bar back at the dev checkout
#
# After init or follow, press SUPER+SHIFT+R once so the shell restarts from the
# new path. promote needs no reload: the running shell hot-reloads the files that
# changed in the live worktree.
#
# The live worktree is a detached checkout, so it never holds uncommitted work:
# only committed code reaches the bar. Uncommitted edits in the dev checkout stay
# off the bar until you commit and promote them.
#
# Env overrides (for tests): ARCHEOTECH_HOME (real home), ARCHEOTECH_SHELL (dev
# checkout), ARCHEOTECH_LIVE (live worktree path).
################################################################################
set -euo pipefail

REAL_HOME="${ARCHEOTECH_HOME:-$(getent passwd "$(id -un)" | cut -d: -f6)}"
DEV="${ARCHEOTECH_SHELL:-$REAL_HOME/Projects/archeotech-shell}"
LIVE="${ARCHEOTECH_LIVE:-$DEV.live}"
LINK="$REAL_HOME/.config/quickshell/archeotech"

die() { echo "archeotech-live: $*" >&2; exit 1; }
target() { [ -L "$LINK" ] && readlink -f "$LINK" || echo "(not a symlink)"; }
short() { git -C "$1" rev-parse --short HEAD 2>/dev/null || echo "?"; }

[ -d "$DEV/.git" ] || [ -f "$DEV/.git" ] || die "dev checkout not found: $DEV"

relink() {
    mkdir -p "$(dirname "$LINK")"
    [ -e "$LINK" ] && [ ! -L "$LINK" ] && die "$LINK exists and is not a symlink; refusing to replace it"
    ln -sfn "$1" "$LINK"
}

case "${1:-status}" in
    status)
        t="$(target)"
        if [ "$t" = "$(readlink -f "$LIVE" 2>/dev/null)" ]; then
            ahead=$(git -C "$DEV" rev-list --count "$(short "$LIVE")..main" 2>/dev/null || echo "?")
            echo "live bar: PINNED at $(short "$LIVE") ($LIVE); main is $ahead commit(s) ahead"
        elif [ "$t" = "$(readlink -f "$DEV")" ]; then
            echo "live bar: FOLLOWING the dev checkout ($DEV) — every save hot-reloads onto the bar"
        else
            echo "live bar: $t"
        fi
        ;;
    init)
        if [ ! -e "$LIVE" ]; then
            git -C "$DEV" worktree add --detach "$LIVE" main >/dev/null
            echo "created live worktree $LIVE at $(short "$LIVE")"
        fi
        relink "$LIVE"
        echo "live bar now points at $LIVE ($(short "$LIVE")). Press SUPER+SHIFT+R once to restart the shell from it."
        ;;
    promote)
        ref="${2:-main}"
        [ -e "$LIVE" ] || die "no live worktree yet; run: archeotech-live.sh init"
        [ -z "$(git -C "$LIVE" status --porcelain)" ] || die "live worktree has local changes; refusing to overwrite them"
        git -C "$LIVE" checkout -q --detach "$ref" || die "unknown ref: $ref"
        echo "live bar promoted to $(short "$LIVE") ($(git -C "$LIVE" log -1 --format=%s))"
        ;;
    follow)
        relink "$DEV"
        echo "live bar follows the dev checkout again. Press SUPER+SHIFT+R once."
        ;;
    *)
        sed -n '4,17p' "$0" | sed 's/^# \{0,1\}//'
        exit 2
        ;;
esac
