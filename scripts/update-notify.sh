#!/usr/bin/env bash
# update-notify.sh: the one desktop notification entry point for the update
# jobs (req_013 / item_171). At most one notification per kind per day, so a
# job that fails every run does not repeat the same alert.
#
#   update-notify.sh [--dry-run] <kind> <message...>
#
# kind     a slug naming what needs the owner: tool-failed (user-tool job),
#          disk-warn / disk-critical (disk-alert.sh; critical is sent critical).
#          Kinds ending in -failed are sent critical (red, stays until dismissed).
#          System update notices are arch-update's own and do not come here.
# --dry-run  print the notification instead of sending it; leaves the state
#            untouched, so a rehearsal never eats the day's real notice.
#
# State: $UPDATE_STATE_DIR (default ~/.local/state/archeotech-updates)/notified.json
#   { "<kind>": { "date": "YYYY-MM-DD", "at": "<ISO time>", "message": "..." } }
# Tests point UPDATE_STATE_DIR at a temp dir and NOTIFY_CMD at a stub.
set -euo pipefail

STATE_DIR=${UPDATE_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/archeotech-updates}
NOTIFIED=$STATE_DIR/notified.json
NOTIFY_CMD=${NOTIFY_CMD:-notify-send}

usage() { echo "usage: ${0##*/} [--dry-run] <kind> <message...>" >&2; exit 2; }

dry_run=0
if [[ ${1:-} == --dry-run ]]; then dry_run=1; shift; fi
(( $# >= 2 )) || usage
kind=$1; shift
message="$*"
[[ $kind =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "${0##*/}: bad kind '$kind' (use a-z, 0-9, -)" >&2; exit 2; }

# Failures go out critical: the shell draws them with a red border and keeps
# them until dismissed (once a day at most, so they never pile up).
urgency=normal
app=Updates
case $kind in
    tool-failed)   title="Tool update failed"; icon=dialog-error ;;
    # disk-alert.sh (item_176)
    disk-warn)     title="Disk space low";     icon=drive-harddisk; app=System ;;
    disk-critical) title="Disk almost full";   icon=dialog-warning; app=System; urgency=critical ;;
    *)             title="Updates: $kind";     icon=system-software-update ;;
esac
[[ $kind == *-failed ]] && urgency=critical

today=$(date +%F)
mkdir -p "$STATE_DIR"
[[ -s $NOTIFIED ]] || echo '{}' >"$NOTIFIED"

# One writer at a time: two jobs finishing together must not both send.
exec 9>"$STATE_DIR/.notified.lock"
flock 9

last=$(jq -r --arg k "$kind" '.[$k].date // ""' "$NOTIFIED")
if [[ $last == "$today" ]]; then
    echo "suppressed: $kind already notified today ($today)"
    exit 0
fi

if (( dry_run )); then
    echo "would notify [$kind]: $title: $message"
    exit 0
fi

"$NOTIFY_CMD" -a "$app" -u "$urgency" -i "$icon" "$title" "$message"

tmp=$(mktemp "$STATE_DIR/.notified.XXXXXX")
jq --arg k "$kind" --arg d "$today" --arg at "$(date -Is)" --arg m "$message" \
    '.[$k] = {date: $d, at: $at, message: $m}' "$NOTIFIED" >"$tmp"
mv "$tmp" "$NOTIFIED"
echo "sent: $kind"
