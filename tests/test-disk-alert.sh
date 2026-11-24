#!/usr/bin/env bash
# Tests for scripts/disk-alert.sh and scripts/disk-report.sh (item_176/177).
# Temp state dir, stub notifier, fake report JSON and a temp $HOME: nothing
# reaches the desktop and the real $HOME is not scanned.
# shellcheck disable=SC2016,SC2034,SC2329  # check() evals its single-quoted conditions
set -uo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
export UPDATE_STATE_DIR=$TMP/state
export NOTIFY_CMD=$TMP/notify-stub
export XDG_CONFIG_HOME=$TMP/config
SENT=$TMP/sent.log
printf '#!/bin/sh\necho "$@" >>%q\n' "$SENT" >"$NOTIFY_CMD"
chmod +x "$NOTIFY_CMD"
mkdir -p "$XDG_CONFIG_HOME"

ALERT=$ROOT/scripts/disk-alert.sh
REPORT=$ROOT/scripts/disk-report.sh
fails=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; fails=$((fails + 1)); fi; }
sent_count() { [[ -f $SENT ]] && wc -l <"$SENT" || echo 0; }
reset() { rm -rf "$UPDATE_STATE_DIR" "$SENT"; }

# fake <free_pct> [metadata_free] [unallocated]
fake() {
    local G=$((1024 * 1024 * 1024))
    jq -n --argjson p "$1" --argjson m "${2:-$((3 * G))}" --argjson u "${3:-$((10 * G))}" --argjson G "$G" '{
        root: {size: (200 * $G), free: (2 * $p * $G), free_pct: $p, used_pct: (100 - $p),
               btrfs_metadata_free: $m, btrfs_unallocated: $u},
        entries: [
          {group: "known", label: "pacman package cache", bytes: (8 * $G)},
          {group: "known", label: "Downloads", bytes: (3 * $G)},
          {group: "known", label: "snapshots: 82", bytes: null},
          {group: "known", label: "paru clones and builds", bytes: (5 * $G)},
          {group: "known", label: "cache: zen", bytes: $G},
          {group: "home", label: "$HOME/.cdx", bytes: (70 * $G)}
        ]}' >"$TMP/report.json"
}
export DISK_ALERT_FAKE_JSON=$TMP/report.json

# --- alert levels -------------------------------------------------------------
fake 30
out=$("$ALERT")
check "AC1: plenty free sends nothing" '[[ $(sent_count) -eq 0 && $out == ok:* ]]'

fake 12
out=$("$ALERT" --dry-run)
check "AC1: dry run prints the warning" '[[ $out == "would notify [disk-warn]: Disk space low: "* ]]'
check "AC1: dry run sends nothing" '[[ $(sent_count) -eq 0 ]]'
check "message names the top three known consumers, biggest first" \
    '[[ $out == *"Top: pacman cache 8.0G, paru 5.0G, Downloads 3.0G. Details: disk-report.sh"* ]]'
check "home-group dirs are not in the message" '[[ $out != *cdx* ]]'
body=${out#*Disk space low: }
check "body stays short enough for a 3-line toast" '[[ ${#body} -le 120 ]]'

"$ALERT" >/dev/null
check "AC1: warning fires once" '[[ $(sent_count) -eq 1 ]] && grep -q "Disk space low" "$SENT"'
check "warning is sent normal urgency as System" 'grep -q -- "-a System -u normal" "$SENT"'
out=$("$ALERT")
check "AC1: second run the same day stays silent" '[[ $(sent_count) -eq 1 && $out == suppressed:* ]]'

reset; fake 6
"$ALERT" >/dev/null
check "critical below DISK_CRIT_PCT, sent critical" 'grep -q -- "-u critical" "$SENT" && grep -q "Disk almost full" "$SENT"'

reset; fake 30 $((512 * 1024 * 1024)) $((1024 * 1024))
out=$("$ALERT" --dry-run)
check "critical when btrfs metadata is tight with nothing unallocated" \
    '[[ $out == *"[disk-critical]"* && $out == *"metadata nearly full"* ]]'
fake 30 $((512 * 1024 * 1024)) $((20 * 1024 * 1024 * 1024))
out=$("$ALERT" --dry-run)
check "low metadata with room to grow is fine" '[[ $out == ok:* ]]'

# --- thresholds ---------------------------------------------------------------
reset; fake 12
out=$(DISK_WARN_PCT=10 "$ALERT" --dry-run)
check "env DISK_WARN_PCT overrides the default" '[[ $out == ok:* ]]'
printf 'DISK_WARN_PCT = 20\nDISK_CRIT_PCT=12\nrm -rf /tmp/x\n' >"$XDG_CONFIG_HOME/disk-alert.conf"
out=$("$ALERT" --dry-run)
check "config file sets the thresholds" '[[ $out == *"[disk-critical]"* ]]'
out=$(DISK_CRIT_PCT=5 "$ALERT" --dry-run)
check "env wins over the config file" '[[ $out == *"[disk-warn]"* ]]'
rm "$XDG_CONFIG_HOME/disk-alert.conf"
DISK_WARN_PCT=abc "$ALERT" >/dev/null 2>&1
check "a bad threshold is rejected (exit 2)" '[[ $? -eq 2 ]]'

# --- disk-report on a temp $HOME ---------------------------------------------
unset DISK_ALERT_FAKE_JSON
H=$TMP/home
mkdir -p "$H/Downloads" "$H/.cache/bigapp" "$H/Projects"
head -c 2000000 /dev/zero >"$H/Projects/blob"
head -c 1000 /dev/zero >"$H/Downloads/a.pdf"
start=$(date +%s)
J=$(HOME=$H XDG_CACHE_HOME='' "$REPORT" --json)
took=$(( $(date +%s) - start ))
check "AC2: --json is valid JSON" 'jq -e .root.free <<<"$J" >/dev/null'
check "AC2: runs under 30 s" '[[ $took -lt 30 ]]'
check "AC2: every entry carries a cleanup command" '[[ $(jq "[.entries[] | select((.cleanup // \"\") == \"\")] | length" <<<"$J") -eq 0 ]]'
check "known consumers are listed" '[[ $(jq -r "[.entries[] | select(.group == \"known\") | .label] | join(\",\")" <<<"$J") == *"pacman package cache"*"Downloads"* ]]'
check "largest home dir comes first" '[[ $(jq -r "[.entries[] | select(.group == \"home\")][0].label" <<<"$J") == "\$HOME/Projects" ]]'
T=$(HOME=$H "$REPORT")
check "human report has the same labels as --json" \
    '[[ $T == *"pacman package cache"* && $T == *"\$HOME/Projects"* && $T == *"Nothing was deleted"* ]]'
R=$("$REPORT" --json --root)
check "--root is instant and has no entries" '[[ $(jq ".entries | length" <<<"$R") -eq 0 && $(jq .root.free_pct <<<"$R") =~ ^[0-9]+$ ]]'
"$REPORT" --root >/dev/null 2>&1
check "--root without --json is rejected" '[[ $? -eq 2 ]]'

echo
(( fails == 0 )) && echo "all passed" || echo "$fails failed"
exit $(( fails > 0 ))
