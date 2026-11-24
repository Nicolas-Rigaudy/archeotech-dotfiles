#!/usr/bin/env bash
# disk-report.sh: where the space on / went and the safe command to get some
# back (req_017 / item_177). Read-only: it prints cleanup commands, it never
# runs them. Runs as the user; root-only paths it cannot read show as "?".
#
#   disk-report.sh            human report
#   disk-report.sh --json     same entries as JSON (disk-alert.sh reads it)
#   disk-report.sh --json --root   free space only, no scans (instant)
#
# Groups:
#   known  the usual suspects: pacman cache, paru builds, ~/.cache dirs,
#          journal, ~/Downloads, snapper snapshots
#   home   the largest dirs one level under $HOME (overlaps "known")
# Not covered: per-snapshot exclusive sizes. They need btrfs quotas
# (`sudo btrfs quota enable /`), which slow snapshot deletion; left off.
#
# Env: DISK_REPORT_TIMEOUT  seconds for the $HOME scan (default 25); a scan
#      that times out reports what it has and says so.
set -uo pipefail

json=0
root_only=0
for arg in "$@"; do
    case $arg in
        --json) json=1 ;;
        --root) root_only=1 ;;
        -h|--help) sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "usage: ${0##*/} [--json [--root]]" >&2; exit 2 ;;
    esac
done
(( root_only && ! json )) && { echo "${0##*/}: --root needs --json" >&2; exit 2; }

HOME_TIMEOUT=${DISK_REPORT_TIMEOUT:-25}
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# --- free space -------------------------------------------------------------
read -r size_b used_b avail_b pct < <(df -B1 --output=size,used,avail,pcent / | awk 'NR==2 {sub("%","",$4); print $1, $2, $3, $4}')
# btrfs: df's "avail" can mislead once every chunk is allocated; the
# estimate from `btrfs filesystem usage` is what new data can really use,
# and metadata free is what keeps snapshots and pacman working.
meta_free_b=""
unalloc_b=""
if [[ $(findmnt -no FSTYPE /) == btrfs ]]; then
    usage=$(btrfs filesystem usage -b / 2>/dev/null)
    est=$(awk -F: '/Free \(estimated\)/ {split($2, a, " "); print a[1]}' <<<"$usage")
    [[ $est =~ ^[0-9]+$ ]] && avail_b=$est
    unalloc_b=$(awk -F: '/Device unallocated/ {split($2, a, " "); print a[1]}' <<<"$usage")
    meta_free_b=$(btrfs filesystem df -b / 2>/dev/null | awk -F'[=, ]+' '/^Metadata/ {for (i=1;i<=NF;i++) {if ($i=="total") t=$(i+1); if ($i=="used") u=$(i+1)}; print t-u}')
fi

entries=()   # group<TAB>label<TAB>path<TAB>bytes<TAB>cleanup
add() { entries+=("$1"$'\t'"$2"$'\t'"$3"$'\t'"$4"$'\t'"$5"); }
home_partial=0

# --- sizes ------------------------------------------------------------------
if (( ! root_only )); then
# size <path> -> bytes, or "?" when unreadable (root-only dirs as the user)
size() {
    [[ -e $1 ]] || { echo 0; return; }
    local out
    out=$(timeout 15 du -sxb "$1" 2>/dev/null | cut -f1)
    [[ $out =~ ^[0-9]+$ ]] && echo "$out" || echo "?"
}

# The $HOME scan is the slow part (about 20 s): start it first, in the background.
( timeout "$HOME_TIMEOUT" du -xb --max-depth=1 "$HOME" 2>/dev/null >"$TMP/home"; echo $? >"$TMP/home.rc" ) &
home_pid=$!

add known "pacman package cache" /var/cache/pacman/pkg "$(size /var/cache/pacman/pkg)" \
    "sudo paccache -rk2 && sudo paccache -ruk0"
paru_dir=${XDG_CACHE_HOME:-$HOME/.cache}/paru
add known "paru clones and builds" "$paru_dir" "$(size "$paru_dir")" "paru -Sc"
add known "systemd journal" /var/log/journal "$(size /var/log/journal)" \
    "sudo journalctl --vacuum-size=500M"
add known "Downloads" "$HOME/Downloads" "$(size "$HOME/Downloads")" \
    "downloads-tidy.sh --dry-run, then delete what is no longer needed"

# ~/.cache: one line per big dir (paru has its own line above). Caches are
# rebuilt on demand, so removing one costs a slower first run, nothing more.
cache=${XDG_CACHE_HOME:-$HOME/.cache}
if [[ -d $cache ]]; then
    while IFS=$'\t' read -r b p; do
        [[ $p == "$cache" || $p == "$paru_dir" ]] && continue
        (( b >= 300*1024*1024 )) || continue
        name=${p#"$cache"/}
        add known "cache: $name" "$p" "$b" "rm -rf ~/.cache/$name  (close the app first)"
    done < <(timeout 15 du -xb --max-depth=1 "$cache" 2>/dev/null | sort -rn | head -8)
fi

# Snapshots: count only (sizes need quotas, see header).
snap_note=""
if command -v snapper >/dev/null; then
    snaps=$(snapper --csvout -c root list --columns type 2>/dev/null | tail -n +2)
    if [[ -n $snaps ]]; then
        n_all=$(grep -c . <<<"$snaps")
        n_pp=$(grep -cE '^(pre|post)$' <<<"$snaps")
        snap_note="$n_all ($n_pp pre/post)"
        add known "snapshots: $snap_note" "/.snapshots" "?" \
            "sudo snapper -c root cleanup number && sudo snapper -c root cleanup timeline"
    fi
fi

wait "$home_pid"
[[ $(cat "$TMP/home.rc" 2>/dev/null) == 0 ]] || home_partial=1
while IFS=$'\t' read -r b p; do
    [[ $p == "$HOME" ]] && continue
    add home "\$HOME/${p#"$HOME"/}" "$p" "$b" "du -xh --max-depth=1 '$p' | sort -h | tail"
done < <(sort -rn "$TMP/home" | grep -v $'\t'"$HOME\$" | head -10)
fi

# --- output -----------------------------------------------------------------
if (( json )); then
    { (( ${#entries[@]} )) && printf '%s\n' "${entries[@]}"; } | jq -R -s \
        --argjson size "$size_b" --argjson used "$used_b" --argjson avail "$avail_b" \
        --argjson pct "$pct" --arg meta "$meta_free_b" --arg unalloc "$unalloc_b" \
        --argjson partial "$home_partial" '
        {
          generated: (now | todate),
          root: {size: $size, used: $used, free: $avail, used_pct: $pct,
                 free_pct: (($avail * 100 / $size) | floor),
                 btrfs_metadata_free: ($meta | tonumber? // null),
                 btrfs_unallocated: ($unalloc | tonumber? // null)},
          home_scan_partial: ($partial == 1),
          entries: [ split("\n")[] | select(length > 0) | split("\t")
                     | {group: .[0], label: .[1], path: .[2],
                        bytes: (.[3] | tonumber? // null), cleanup: .[4]} ]
        }'
    exit 0
fi

h() { [[ $1 =~ ^[0-9]+$ ]] && numfmt --to=iec --format='%.1f' "$1" || echo "?"; }

printf '/ : %s free of %s (%s%% used)\n' "$(h "$avail_b")" "$(h "$size_b")" "$pct"
if [[ -n $meta_free_b ]]; then
    printf '    btrfs metadata free %s, unallocated %s' "$(h "$meta_free_b")" "$(h "$unalloc_b")"
    [[ $unalloc_b =~ ^[0-9]+$ ]] && (( unalloc_b < 1024*1024*1024 )) \
        && printf '  (no room to grow metadata: free space first, then: sudo btrfs balance start -dusage=50 /)'
    printf '\n'
fi
for group in known home; do
    echo
    if [[ $group == known ]]; then echo "Known consumers"; else
        echo "Largest under \$HOME$( (( home_partial )) && echo " (scan timed out after ${HOME_TIMEOUT}s: partial)")"; fi
    while IFS=$'\t' read -r g label _path b cmd; do
        [[ $g == "$group" ]] || continue
        printf '  %7s  %-30s  %s\n' "$(h "$b")" "$label" "$cmd"
    done < <(printf '%s\n' "${entries[@]}" | sort -t$'\t' -k4,4nr)
done
echo
echo "Nothing was deleted. Run a command above yourself to clean that item."
