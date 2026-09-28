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
#   archeotech-live.sh preview <wt|br>  # point the bar at a worktree (path, or the
#                                       # branch checked out in one), uncommitted work included
#   archeotech-live.sh back             # end a preview: back to the pinned live worktree
#
# After init, follow, preview or back, press SUPER+SHIFT+R once so the shell
# restarts from the new path; from then on saves in that tree hot-reload. promote
# needs no reload: the running shell hot-reloads the files that changed in the
# live worktree.
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

# Common git dir of a checkout, absolute, so worktrees of one repo compare equal.
common() { (cd "$1" 2>/dev/null && readlink -f "$(git rev-parse --git-common-dir 2>/dev/null)") || true; }

# Resolve a preview argument to a worktree path: a directory, or a branch name
# that some worktree of the dev repo has checked out.
resolve_preview() {
    if [ -d "$1" ]; then
        readlink -f "$1"
        return
    fi
    git -C "$DEV" worktree list --porcelain | awk -v ref="refs/heads/$1" '
        /^worktree /{wt=substr($0, 10)} $0 == "branch " ref {print wt; exit}'
}

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
        elif [ ! -d "$t" ]; then
            echo "live bar: BROKEN — points at $t, which no longer exists; run: archeotech-live.sh back (or follow)"
        elif [ -n "$(common "$t")" ] && [ "$(common "$t")" = "$(common "$DEV")" ]; then
            br=$(git -C "$t" branch --show-current 2>/dev/null); dirty=$(git -C "$t" status --porcelain | wc -l)
            echo "live bar: PREVIEW of $t (${br:-detached} at $(short "$t"), $dirty uncommitted change(s)); end it with: archeotech-live.sh back"
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
    preview)
        [ -n "${2:-}" ] || die "usage: archeotech-live.sh preview <worktree-path|branch>"
        wt="$(resolve_preview "$2")"
        [ -n "$wt" ] || die "no worktree of $DEV has branch '$2' checked out (and it is not a directory)"
        [ -n "$(common "$wt")" ] && [ "$(common "$wt")" = "$(common "$DEV")" ] \
            || die "$wt is not a worktree of $DEV"
        [ -f "$wt/shell.qml" ] || die "$wt has no shell.qml; not a shell checkout"
        relink "$wt"
        echo "live bar now previews $wt ($(short "$wt"), uncommitted work included). Press SUPER+SHIFT+R once; run 'archeotech-live.sh back' when done."
        ;;
    back)
        [ -e "$LIVE" ] || die "no live worktree to go back to; run: archeotech-live.sh init (or follow)"
        relink "$LIVE"
        echo "live bar back on the pinned worktree $LIVE ($(short "$LIVE")). Press SUPER+SHIFT+R once."
        ;;
    *)
        sed -n '4,22p' "$0" | sed 's/^# \{0,1\}//'
        exit 2
        ;;
esac
