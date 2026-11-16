#!/usr/bin/env bash
# Tests for scripts/update-notify.sh and scripts/update-state.sh (item_171).
# Runs against a temp state dir and a stub notifier: nothing reaches the desktop.
# shellcheck disable=SC2016,SC2034  # check() evals its single-quoted conditions
set -uo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
export UPDATE_STATE_DIR=$TMP/state
export NOTIFY_CMD=$TMP/notify-stub
SENT=$TMP/sent.log
printf '#!/bin/sh\necho "$@" >>%q\n' "$SENT" >"$NOTIFY_CMD"
chmod +x "$NOTIFY_CMD"

NOTIFY=$ROOT/scripts/update-notify.sh
STATE=$ROOT/scripts/update-state.sh
fails=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; fails=$((fails + 1)); fi; }
sent_count() { [[ -f $SENT ]] && wc -l <"$SENT" || echo 0; }

# --- notifier ---
out=$("$NOTIFY" --dry-run tool-failed "rtk: exit 1")
check "dry-run prints the notice" '[[ $out == "would notify [tool-failed]: Tool update failed: rtk: exit 1" ]]'
check "dry-run sends nothing" '[[ $(sent_count) -eq 0 ]]'
check "dry-run leaves state untouched" '[[ $(jq -r ".\"tool-failed\" // \"none\"" "$UPDATE_STATE_DIR/notified.json") == none ]]'

"$NOTIFY" tool-failed "rtk: exit 1" >/dev/null
check "first call sends" '[[ $(sent_count) -eq 1 ]]'
check "a -failed kind is sent critical" 'grep -q -- "-u critical" "$SENT"'
out=$("$NOTIFY" tool-failed "cdx: exit 2")
check "AC4: same kind same day sends nothing" '[[ $(sent_count) -eq 1 && $out == suppressed:* ]]'
"$NOTIFY" disk-space "/ at 86 %" >/dev/null
check "AC4: a different kind sends" '[[ $(sent_count) -eq 2 ]]'
check "other kinds are sent normal" '[[ $(tail -1 "$SENT") == *"-u normal"* ]]'
jq --arg d "$(date -d yesterday +%F)" '."tool-failed".date = $d' "$UPDATE_STATE_DIR/notified.json" >"$TMP/n" \
    && mv "$TMP/n" "$UPDATE_STATE_DIR/notified.json"
"$NOTIFY" tool-failed "rtk: exit 1" >/dev/null
check "same kind sends again the next day" '[[ $(sent_count) -eq 3 ]]'
"$NOTIFY" "Bad Kind" x >/dev/null 2>&1
check "bad kind is rejected (exit 2)" '[[ $? -eq 2 ]]'

# --- versions.json ---
"$STATE" record cdx 1.4.0 pipx ok
"$STATE" record rtk 0.35.0 binary ok
"$STATE" record cdx 1.4.0 pipx ok
V=$("$STATE" path)
check "AC6: versions.json is valid JSON" 'jq -e . "$V" >/dev/null'
check "AC6: one entry per tool" '[[ $(jq ".tools | length" "$V") -eq 2 ]]'
first=$(jq -r .tools.cdx.last_update "$V")
check "same version keeps last_update" '[[ $first != null ]]'
sleep 1
"$STATE" record cdx 1.5.0 pipx ok
check "new version moves last_update" '[[ $(jq -r .tools.cdx.last_update "$V") != "$first" && $(jq -r .tools.cdx.version "$V") == 1.5.0 ]]'
"$STATE" record rtk unknown binary failed
check "failed run with unknown version keeps the last version" \
    '[[ $(jq -r .tools.rtk.version "$V") == 0.35.0 && $(jq -r .tools.rtk.last_result "$V") == failed ]]'
"$STATE" forget rtk
check "forget drops the tool" '[[ $(jq ".tools | has(\"rtk\")" "$V") == false ]]'
"$STATE" record x 1 npm maybe 2>/dev/null
check "bad result is rejected (exit 2)" '[[ $? -eq 2 ]]'

echo
if (( fails )); then echo "$fails failed"; exit 1; fi
echo "all passed"
