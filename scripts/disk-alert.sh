#!/usr/bin/env bash
# disk-alert.sh: warn before / fills up (req_017 / item_176). Run hourly by
# disk-alert.timer. A full btrfs root breaks pacman, builds and snapper.
#
#   disk-alert.sh [--dry-run]
#
# Levels (percent of / still free; df and the btrfs free estimate, lower wins):
#   disk-warn      free <= DISK_WARN_PCT  (default 15)
#   disk-critical  free <= DISK_CRIT_PCT  (default 8), or btrfs metadata has
#                  under 1 GiB free with no unallocated space left to grow into
# Notifications go through update-notify.sh: once a day per kind at most.
# The message (kept to ~3 toast lines) names the free space and the top three
# consumers; disk-report.sh prints the cleanup command for each.
#
# Thresholds: env DISK_WARN_PCT / DISK_CRIT_PCT, or the same KEY=value lines
# in ${XDG_CONFIG_HOME:-~/.config}/disk-alert.conf (env wins).
# --dry-run prints the notification instead of sending it (state untouched).
# Tests: DISK_ALERT_FAKE_JSON=<file> replaces the disk-report.sh call.
set -euo pipefail

dry=()
case ${1:-} in
    --dry-run) dry=(--dry-run) ;;
    "") ;;
    *) echo "usage: ${0##*/} [--dry-run]" >&2; exit 2 ;;
esac

here=$(dirname "$(readlink -f "$0")")
conf=${XDG_CONFIG_HOME:-$HOME/.config}/disk-alert.conf
env_warn=${DISK_WARN_PCT:-}
env_crit=${DISK_CRIT_PCT:-}
if [[ -r $conf ]]; then
    # Only the two known keys, never sourced (a config file is not a script).
    while IFS='=' read -r k v; do
        v=${v//[[:space:]\"\']/}
        case $k in
            DISK_WARN_PCT) DISK_WARN_PCT=$v ;;
            DISK_CRIT_PCT) DISK_CRIT_PCT=$v ;;
        esac
    done < <(grep -E '^[[:space:]]*DISK_(WARN|CRIT)_PCT=' "$conf" | tr -d ' \t')
fi
warn=${env_warn:-${DISK_WARN_PCT:-15}}
crit=${env_crit:-${DISK_CRIT_PCT:-8}}
[[ $warn =~ ^[0-9]+$ && $crit =~ ^[0-9]+$ ]] || { echo "${0##*/}: thresholds must be whole percents (warn=$warn crit=$crit)" >&2; exit 2; }

# The free-space check is instant (--root); the full scan for the top
# consumers (up to ~25 s) only runs when a notice is due.
if [[ -n ${DISK_ALERT_FAKE_JSON:-} ]]; then
    report() { cat "$DISK_ALERT_FAKE_JSON"; }
else
    report() { "$here/disk-report.sh" --json "$@"; }
fi

json=$(report --root)
read -r free_pct free_b meta_b unalloc_b < <(jq -r '.root | "\(.free_pct) \(.free) \(.btrfs_metadata_free // -1) \(.btrfs_unallocated // -1)"' <<<"$json")

meta_tight=0
gib=$((1024 * 1024 * 1024))
(( meta_b >= 0 && meta_b < gib && unalloc_b >= 0 && unalloc_b < gib )) && meta_tight=1

kind=""
if (( free_pct <= crit || meta_tight )); then kind=disk-critical
elif (( free_pct <= warn )); then kind=disk-warn
fi
if [[ -z $kind ]]; then
    echo "ok: / ${free_pct}% free (warn at ${warn}%, critical at ${crit}%)"; exit 0
fi

[[ -n ${DISK_ALERT_FAKE_JSON:-} ]] || json=$(report)
h() { numfmt --to=iec --format='%.1f' "$1"; }
# Short labels: the shell's toast and notification center show 3 lines of body.
top=$(jq -r '[.entries[] | select(.group == "known" and .bytes != null)]
             | sort_by(-.bytes) | .[:3]
             | map(.label | sub("pacman package cache"; "pacman cache")
                          | sub("paru clones and builds"; "paru")
                          | sub("systemd journal"; "journal")) as $l
             | [$l, map(.bytes)] | transpose | map("\(.[0]) \(.[1])") | .[]' <<<"$json" \
      | while read -r line; do
            b=${line##* }; printf '%s %s, ' "${line% *}" "$(h "$b")"
        done)
msg="/ has $(h "$free_b") free (${free_pct}%)."
(( meta_tight )) && msg+=" btrfs metadata nearly full."
msg+=" Top: ${top%, }. Details: disk-report.sh"

"$here/update-notify.sh" "${dry[@]}" "$kind" "$msg"
