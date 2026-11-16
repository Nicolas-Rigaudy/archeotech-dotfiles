#!/usr/bin/env bash
# update-state.sh: writes versions.json, the installed-versions file the update
# jobs keep and crow (cr-0w req_045) reads without running any updater
# (req_013 / item_171). Format: docs/UPDATES.md.
#
#   update-state.sh record <tool> <version> <method> <ok|failed>
#   update-state.sh forget <tool>     drop a tool that is no longer followed
#   update-state.sh show              print versions.json
#   update-state.sh path              print its path
#
# <version> may be "unknown" when a failed run could not read it; the last
# known version is then kept.
# shellcheck disable=SC2016  # $vars inside single quotes are jq variables
set -euo pipefail

STATE_DIR=${UPDATE_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/archeotech-updates}
VERSIONS=$STATE_DIR/versions.json

usage() { sed -n '6,9s/^# \{0,1\}//p' "$0" >&2; exit 2; }

init() {
    mkdir -p "$STATE_DIR"
    [[ -s $VERSIONS ]] || echo '{"schema": 1, "updated_at": null, "tools": {}}' >"$VERSIONS"
}

# write <jq filter> [jq args...]: locked, atomic rewrite of versions.json.
write() {
    local filter=$1; shift
    exec 9>"$STATE_DIR/.versions.lock"
    flock 9
    local tmp
    tmp=$(mktemp "$STATE_DIR/.versions.XXXXXX")
    jq "$@" --arg now "$(date -Is)" "$filter | .updated_at = \$now" "$VERSIONS" >"$tmp"
    mv "$tmp" "$VERSIONS"
}

cmd=${1:-}; shift || true
case $cmd in
    record)
        (( $# == 4 )) || usage
        tool=$1 version=$2 method=$3 result=$4
        [[ $result == ok || $result == failed ]] || { echo "${0##*/}: result must be ok or failed" >&2; exit 2; }
        init
        # last_update moves only when the installed version changes.
        write '
            (.tools[$t] // {}) as $old
            | ($old.version // null) as $prev
            | (if $v == "unknown" then $prev else $v end) as $ver
            | .tools[$t] = {
                version: $ver,
                method: $m,
                last_update: (if $ver != $prev and $ver != null then $now else ($old.last_update // null) end),
                last_run: $now,
                last_result: $r
              }' \
            --arg t "$tool" --arg v "$version" --arg m "$method" --arg r "$result"
        ;;
    forget)
        (( $# == 1 )) || usage
        init
        write 'del(.tools[$t])' --arg t "$1"
        ;;
    show) init; jq . "$VERSIONS" ;;
    path) echo "$VERSIONS" ;;
    *) usage ;;
esac
