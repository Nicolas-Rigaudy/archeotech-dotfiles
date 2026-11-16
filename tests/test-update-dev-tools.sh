#!/usr/bin/env bash
# Tests for scripts/update-dev-tools.sh (item_172). Every tool, npm, pipx, uv
# and curl are stubs in a temp HOME: nothing is installed, nothing reaches the
# network or the desktop.
# shellcheck disable=SC2016,SC2034  # check() evals its single-quoted conditions
set -uo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
export HOME=$TMP/home
export UPDATE_STATE_DIR=$TMP/state
export NOTIFY_CMD=$TMP/notify-stub
export RETRIES=2 RETRY_DELAY=0 STEP_TIMEOUT=20
SENT=$TMP/sent.log
BIN=$HOME/.local/bin
mkdir -p "$BIN"
printf '#!/bin/sh\necho "$@" >>%q\n' "$SENT" >"$NOTIFY_CMD"

stub() { printf '#!/usr/bin/env bash\n%s\n' "$2" >"$BIN/$1"; chmod +x "$BIN/$1" "$NOTIFY_CMD"; }
# CLAUDE_UPDATE: shell code run by `claude update` (to force a failure or hang)
stub claude 'case $1 in --version) echo "2.1.400 (Claude Code)";; update) eval "${CLAUDE_UPDATE:-true}";; esac'
stub npm '
M=$HOME/codex-installed
case $1 in
  ls)   c=""; [[ -f $M ]] && c=", \"@openai/codex\": {\"version\": \"0.169.0\"}"
        echo "{\"dependencies\": {\"@grifhinz/logics-manager\": {\"version\": \"2.24.7\"}$c}}";;
  view) [[ $2 == @openai/codex ]] && echo 0.169.0 || echo 2.24.7;;
  install) [[ $3 == @openai/codex@* ]] && touch "$M";;
esac'
stub cdx 'exit 0'
stub pipx 'case $1 in list) echo "{\"venvs\": {\"cdx-manager\": {}, \"uv\": {}}}";; runpip) echo "Version: 1.0";; esac'
stub uv 'case "$1 $2" in "tool list") printf "ast-grep-cli v0.51.0\n- ast-grep\n";; esac'
stub rtk 'echo "rtk 1.2.0"'
stub codebase-memory-mcp 'echo "codebase-memory-mcp 0.11.0"'
stub curl 'case "$*" in *rtk-ai*) echo "{\"tag_name\": \"v1.2.0\"}";; *codebase-memory*) echo "{\"tag_name\": \"v0.11.0\"}";; *) exit 22;; esac'

UP=$ROOT/scripts/update-dev-tools.sh
V=$UPDATE_STATE_DIR/versions.json
fails=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; fails=$((fails + 1)); fi; }
tool() { jq -r --arg t "$1" ".tools[\$t].$2 // \"none\"" "$V"; }

# --- dry run ---
out=$("$UP" --dry-run --no-wait 2>&1)
check "dry run exits 0" '[[ $? -eq 0 ]]'
check "dry run says codex would be installed" '[[ $out == *"would run: npm install -g @openai/codex@0.169.0"* ]]'
check "dry run writes no state" '[[ ! -e $V ]]'
check "dry run installs nothing" '[[ ! -e $HOME/codex-installed ]]'

# --- one tool forced to fail ---
CLAUDE_UPDATE='exit 3' "$UP" --no-wait >"$TMP/run.log" 2>&1
check "a failed tool makes the run exit 1" '[[ $? -eq 1 ]]'
check "AC1: the failed tool is recorded failed" '[[ $(tool claude last_result) == failed && $(tool claude version) == 2.1.400 ]]'
for t in logics-manager codex cdx uv ast-grep-cli rtk codebase-memory-mcp; do
    check "AC1: $t still updated (ok)" "[[ \$(tool $t last_result) == ok ]]"
done
check "codex installed when missing" '[[ $(tool codex version) == 0.169.0 && $(tool codex method) == npm ]]'
check "cdx-manager is cdx's, not a pipx entry" '[[ $(tool cdx-manager version) == none ]]'
check "uv tool version read without the v" '[[ $(tool ast-grep-cli version) == 0.51.0 ]]'
check "AC6: versions.json lists every tool" '[[ $(jq ".tools | length" "$V") -eq 8 ]]'
check "the failure was retried" '[[ $(grep -c "claude failed (exit 3), attempt 1/2" "$TMP/run.log") -eq 1 ]]'
check "one tool-failed notice naming the tool" '[[ $(wc -l <"$SENT") -eq 1 ]] && grep -q "claude: exit 3" "$SENT"'

# --- timeout ---
rm -f "$SENT" "$UPDATE_STATE_DIR/notified.json"
STEP_TIMEOUT=1 RETRIES=1 CLAUDE_UPDATE='sleep 10' "$UP" --no-wait --only claude >"$TMP/run2.log" 2>&1
check "a hanging tool is killed and reported" 'grep -q "claude: timed out after 1s" "$SENT"'
check "--only runs just that tool" '! grep -q -- "-- rtk" "$TMP/run2.log"'

# --- all ok ---
rm -f "$SENT"
"$UP" --no-wait >/dev/null 2>&1
check "a clean run exits 0" '[[ $? -eq 0 ]]'
check "a clean run sends nothing" '[[ ! -e $SENT ]]'

echo
if (( fails )); then echo "$fails failed"; exit 1; fi
echo "all passed"
