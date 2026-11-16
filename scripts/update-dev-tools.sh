#!/usr/bin/env bash
# Auto-update the dev CLIs: cdx, logics-manager.
# (Claude Code updates itself via its own built-in auto-updater, not this timer.)
# Run daily by the update-dev-tools.timer systemd user unit (req_013 / item_172).
# Each tool is updated independently — one failing never blocks the others.
#
# Network: the timer is Persistent, so after a suspend it fires the second the
# laptop resumes, before Wi-Fi is back (network-online.target does not cover a
# resume; 2026-11-16 run failed on DNS). So we first wait until the update
# hosts resolve, then retry each step a few times on failure.
set -uo pipefail

export PATH="$HOME/.local/bin:$PATH"
log() { printf '%s  %s\n' "$(date -Is)" "$*"; }

NET_HOSTS=(github.com registry.npmjs.org)
NET_WAIT_MAX=${NET_WAIT_MAX:-300}   # seconds to wait for DNS before trying anyway
NET_WAIT_STEP=10
RETRIES=${RETRIES:-3}               # attempts per tool
RETRY_DELAY=${RETRY_DELAY:-60}      # seconds between attempts
NET_GAVE_UP=0                       # set once the wait timed out: retries stop re-waiting

net_ready() {
    local h
    for h in "${NET_HOSTS[@]}"; do
        getent hosts "$h" >/dev/null 2>&1 || return 1
    done
}

wait_for_network() {
    local waited=0
    until net_ready; do
        if (( waited >= NET_WAIT_MAX )); then
            log "!! network not ready after ${NET_WAIT_MAX}s (${NET_HOSTS[*]} do not resolve); trying anyway"
            NET_GAVE_UP=1
            return 1
        fi
        (( waited == 0 )) && log "waiting for network (${NET_HOSTS[*]})..."
        sleep "$NET_WAIT_STEP"
        waited=$(( waited + NET_WAIT_STEP ))
    done
    log "network ready after ${waited}s"
}

# run_step <label> <command...>: up to $RETRIES attempts, re-checking the
# network before each retry. Never fails the script.
run_step() {
    local label=$1; shift
    local attempt rc
    log "-- $label --"
    for (( attempt = 1; attempt <= RETRIES; attempt++ )); do
        "$@" 2>&1
        rc=$?
        (( rc == 0 )) && return 0
        if (( attempt < RETRIES )); then
            log "!! $label failed (exit $rc), attempt $attempt/$RETRIES; retrying in ${RETRY_DELAY}s"
            sleep "$RETRY_DELAY"
            (( NET_GAVE_UP )) || net_ready || wait_for_network
        else
            log "!! $label failed (exit $rc) after $RETRIES attempts"
        fi
    done
    return 0
}

log "=== update-dev-tools starting ==="
wait_for_network

run_step "cdx (self)"          cdx update --yes
run_step "cdx (managed tools)" cdx update all --yes
run_step "logics-manager"      logics-manager update

log "=== update-dev-tools done ==="
