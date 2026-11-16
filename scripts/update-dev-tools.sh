#!/usr/bin/env bash
# update-dev-tools.sh: daily update of the user-installed dev tools, one step
# per install method (req_013 / item_172). Run by update-dev-tools.timer.
# pacman and AUR packages are arch-update's job and are not touched here.
#
#   update-dev-tools.sh [--dry-run] [--only tool[,tool...]] [--no-wait]
#
# --dry-run  check what is out of date and print what would run; installs
#            nothing, writes no state, sends no notice.
# --only     run only these tools (names as in versions.json).
# --no-wait  skip the network wait.
#
# Followed tools (name: method):
#   claude: native (`claude update`; its own auto-updater stays on)
#   logics-manager, codex: npm -g (installed when missing)
#   cdx: its own self-update inside the pipx venv, then `cdx update all`
#   every other pipx venv: pipx upgrade
#   every uv tool: uv tool upgrade
#   rtk: GitHub release binary (rtk-oss musl build), checksum verified
#   codebase-memory-mcp: its install.sh into a versioned dir, then a symlink switch
#
# Each tool runs alone under a timeout, with retries; one failing never blocks
# the others. Every tool's version and result go to versions.json
# (update-state.sh); failures are sent as one tool-failed notice
# (update-notify.sh, at most one a day). Format: docs/UPDATES.md.
#
# Network: the timer is Persistent, so after a suspend it fires the second the
# laptop resumes, before Wi-Fi is back (network-online.target does not cover a
# resume; 2026-11-16 run failed on DNS). So we first wait until the update
# hosts resolve, then retry each step a few times on failure.
set -uo pipefail

export PATH="$HOME/.local/bin:$PATH"
SELF=$(readlink -f "$0")
SCRIPTS=$(dirname "$SELF")
STATE="$SCRIPTS/update-state.sh"
NOTIFY="$SCRIPTS/update-notify.sh"

NET_HOSTS=(github.com registry.npmjs.org pypi.org)
NET_WAIT_MAX=${NET_WAIT_MAX:-1800}  # seconds to wait for DNS (30 min: Wi-Fi on a train can take a while)
NET_WAIT_STEP=15
RETRIES=${RETRIES:-3}               # attempts per tool
RETRY_DELAY=${RETRY_DELAY:-60}      # seconds between attempts
STEP_TIMEOUT=${STEP_TIMEOUT:-600}   # seconds per attempt
export DRY_RUN=${DRY_RUN:-0}

# npm -g tools: <command>=<package>
NPM_TOOLS=(
    "logics-manager=@grifhinz/logics-manager"
    "codex=@openai/codex"
)
# pipx venvs with their own updater (skipped by the pipx loop)
PIPX_SKIP=(cdx-manager)

RTK_REPO=rtk-ai/rtk
RTK_ASSET=rtk-oss-x86_64-unknown-linux-musl.tar.gz   # the build installed here (oss, static)
CBM_REPO=DeusData/codebase-memory-mcp
CBM_HOME=$HOME/.local/share/codebase-memory-mcp      # one v<tag>/ dir per version
CBM_KEEP=2                                           # current + one to roll back to

log() { printf '%s  %s\n' "$(date -Is)" "$*"; }
dry() { (( DRY_RUN )); }

# ---------------------------------------------------------------- versions --

npm_pkg() {  # command name -> npm package
    local e
    for e in "${NPM_TOOLS[@]}"; do [[ ${e%%=*} == "$1" ]] && { echo "${e#*=}"; return; }; done
    return 1
}

npm_installed() {  # package -> installed version or empty
    npm ls -g --json --depth=0 2>/dev/null | jq -r --arg p "$1" '.dependencies[$p].version // empty'
}

# version_of <method> <tool>: installed version, empty when unknown
version_of() {
    local method=$1 tool=$2
    case $method in
        native)  claude --version 2>/dev/null | awk 'NR==1 {print $1}' ;;
        npm)     npm_installed "$(npm_pkg "$tool")" ;;
        cdx)     pipx runpip cdx-manager show cdx-manager 2>/dev/null | awk '/^Version:/ {print $2}' ;;
        pipx)    pipx runpip "$tool" show "$tool" 2>/dev/null | awk '/^Version:/ {print $2}' ;;
        uv)      uv tool list 2>/dev/null | awk -v t="$tool" '$1 == t {sub(/^v/, "", $2); print $2}' ;;
        binary)  rtk --version 2>/dev/null | awk 'NR==1 {print $2}' ;;
        cbm)     codebase-memory-mcp --version 2>/dev/null | awk 'NR==1 {print $2}' ;;
    esac
}

gh_latest() {  # repo -> latest release tag
    curl -fsS --max-time 30 "https://api.github.com/repos/$1/releases/latest" | jq -re .tag_name
}

# ------------------------------------------------------------------ updaters --
# Each runs in its own process (see run_tool), so traps and exits are local.

update_native() {
    if dry; then echo "would run: claude update"; return 0; fi
    claude update
}

update_npm() {
    local tool=$1 pkg cur latest
    pkg=$(npm_pkg "$tool") || { echo "no npm package for $tool" >&2; return 2; }
    cur=$(npm_installed "$pkg")
    latest=$(npm view "$pkg" version) || return 1
    if [[ $cur == "$latest" ]]; then echo "$pkg $cur is current"; return 0; fi
    echo "$pkg ${cur:-not installed} -> $latest"
    if dry; then echo "would run: npm install -g $pkg@$latest"; return 0; fi
    npm install -g "$pkg@$latest"
}

update_cdx() {
    if dry; then cdx update --check; echo "would run: cdx update --yes; cdx update all --yes"; return 0; fi
    cdx update --yes && cdx update all --yes
}

update_pipx() {
    if dry; then echo "would run: pipx upgrade $1"; return 0; fi
    pipx upgrade "$1"
}

update_uv() {
    if dry; then echo "would run: uv tool upgrade $1"; return 0; fi
    uv tool upgrade "$1"
}

update_binary() {  # rtk
    local tag cur bin tmp
    tag=$(gh_latest "$RTK_REPO") || return 1
    cur=$(version_of binary rtk)
    if [[ "v$cur" == "$tag" ]]; then echo "rtk $cur is current"; return 0; fi
    echo "rtk ${cur:-not installed} -> $tag"
    if dry; then echo "would download $RTK_ASSET from $tag"; return 0; fi
    [[ $(uname -m) == x86_64 ]] || { echo "rtk: only the x86_64 build is wired up" >&2; return 2; }
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    local url="https://github.com/$RTK_REPO/releases/download/$tag"
    curl -fsSL --max-time 300 -o "$tmp/$RTK_ASSET" "$url/$RTK_ASSET" || return 1
    curl -fsSL --max-time 60 -o "$tmp/checksums.txt" "$url/checksums.txt" || return 1
    (cd "$tmp" && grep -E "^[0-9a-f]{64}  $RTK_ASSET\$" checksums.txt | sha256sum -c --strict -) \
        || { echo "rtk: checksum mismatch or missing" >&2; return 1; }
    tar -xzf "$tmp/$RTK_ASSET" -C "$tmp" rtk || return 1
    "$tmp/rtk" --version >/dev/null || { echo "rtk: new binary does not run" >&2; return 1; }
    bin=$HOME/.local/bin/rtk
    [[ -f $bin ]] && cp -p "$bin" "$bin.prev"   # one-step rollback: mv rtk.prev rtk
    install -m 755 "$tmp/rtk" "$bin.new" && mv -f "$bin.new" "$bin"
}

CBM_MARK='# Added by codebase-memory-mcp install'
strip_cbm_path_edits() {  # remove "<blank>\n$CBM_MARK\n<path line>" blocks from rc files
    local rc
    for rc in "$HOME/.config/fish/config.fish" "$HOME/.zshrc" "$HOME/.bashrc"; do
        rc=$(readlink -f "$rc" 2>/dev/null) || continue
        if [[ ! -f $rc ]] || ! grep -qxF "$CBM_MARK" "$rc"; then continue; fi
        awk -v m="$CBM_MARK" '
            skip { skip = 0; next }
            $0 == m { skip = 1; if (blank) blank = 0; next }
            { if (blank) print ""; blank = ($0 == ""); if (!blank) print }
            END { if (blank) print "" }' "$rc" >"$rc.cbm-tmp" && cat "$rc.cbm-tmp" >"$rc" && rm -f "$rc.cbm-tmp"
        echo "removed the installer's PATH line from $rc"
    done
}

update_cbm() {  # codebase-memory-mcp
    local tag cur link installer new
    tag=$(gh_latest "$CBM_REPO") || return 1
    cur=$(version_of cbm codebase-memory-mcp)
    if [[ "v$cur" == "$tag" ]]; then echo "codebase-memory-mcp $cur is current"; return 0; fi
    echo "codebase-memory-mcp ${cur:-not installed} -> $tag"
    link=$HOME/.local/bin/codebase-memory-mcp
    installer=$(dirname "$(readlink -f "$link")")/install.sh
    [[ -f $installer ]] || { echo "codebase-memory-mcp: no install.sh next to $link" >&2; return 2; }
    new=$CBM_HOME/$tag
    if dry; then echo "would run: bash $installer --dir=$new --skip-config; then link $link -> $new"; return 0; fi
    # install.sh downloads the latest release, verifies its checksum and
    # installs into --dir; --skip-config leaves the agent configs alone.
    # It also appends `fish_add_path <dir>` to the shell rc (fish config is
    # tracked in this repo) unless <dir> is on PATH: the ~/.local/bin link is
    # what PATH uses, so put <dir> on PATH for the call, then drop any marker
    # block it added anyway.
    PATH="$new:$PATH" bash "$installer" --dir="$new" --skip-config </dev/null || return 1
    strip_cbm_path_edits
    "$new/codebase-memory-mcp" --version >/dev/null || { echo "codebase-memory-mcp: new binary does not run" >&2; return 1; }
    ln -sfn "$new/codebase-memory-mcp" "$link"
    # Keep the newest $CBM_KEEP version dirs (rollback = point the link back).
    find "$CBM_HOME" -mindepth 1 -maxdepth 1 -type d -name 'v*' -printf '%f\n' | sort -V | head -n -"$CBM_KEEP" \
        | while read -r old; do rm -rf "${CBM_HOME:?}/$old"; done
}

# ---------------------------------------------------------------- running --

net_ready() {
    local h
    for h in "${NET_HOSTS[@]}"; do
        getent hosts "$h" >/dev/null 2>&1 || return 1
    done
}

NET_GAVE_UP=0  # set once the wait timed out: retries stop re-waiting
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

FAILED=()     # "tool: reason" for the notice
SELECTED=()   # --only

selected() {
    (( ${#SELECTED[@]} == 0 )) && return 0
    local s
    for s in "${SELECTED[@]}"; do [[ $s == "$1" ]] && return 0; done
    return 1
}

# run_tool <method> <tool>: up to $RETRIES attempts of update_<method> under
# $STEP_TIMEOUT, then records the version and result. Never fails the script.
run_tool() {
    local method=$1 tool=$2 attempt rc=0 reason version result
    selected "$tool" || return 0
    log "-- $tool ($method) --"
    for (( attempt = 1; attempt <= RETRIES; attempt++ )); do
        timeout --kill-after=30 "$STEP_TIMEOUT" "$SELF" __step "$method" "$tool" 2>&1
        rc=$?
        (( rc == 0 )) && break
        if (( attempt < RETRIES )); then
            log "!! $tool failed (exit $rc), attempt $attempt/$RETRIES; retrying in ${RETRY_DELAY}s"
            sleep "$RETRY_DELAY"
            (( NET_GAVE_UP )) || net_ready || wait_for_network
        fi
    done
    if (( rc == 0 )); then
        result=ok
    else
        result=failed
        if (( rc == 124 || rc == 137 )); then reason="timed out after ${STEP_TIMEOUT}s"; else reason="exit $rc"; fi
        log "!! $tool failed ($reason) after $RETRIES attempts"
        FAILED+=("$tool: $reason")
    fi
    dry && return 0
    version=$(version_of "$method" "$tool")
    "$STATE" record "$tool" "${version:-unknown}" "$method" "$result" >/dev/null \
        || log "!! could not record $tool in versions.json"
    log "$tool ${version:-unknown} ($result)"
}

# Internal entry: one attempt of one updater, in its own process so the
# timeout can kill it cleanly.
if [[ ${1:-} == __step ]]; then
    "update_$2" "$3"
    exit $?
fi

no_wait=0
while (( $# )); do
    case $1 in
        --dry-run) DRY_RUN=1 ;;
        --only)    shift; IFS=, read -ra SELECTED <<<"${1:-}" ;;
        --no-wait) no_wait=1 ;;
        -h|--help) sed -n '2,12s/^# \{0,1\}//p' "$SELF"; exit 0 ;;
        *) echo "${0##*/}: unknown option '$1'" >&2; exit 2 ;;
    esac
    shift
done

log "=== update-dev-tools starting$(dry && echo ' (dry run)') ==="
(( no_wait )) || wait_for_network

run_tool native claude
for e in "${NPM_TOOLS[@]}"; do run_tool npm "${e%%=*}"; done
run_tool cdx cdx
while read -r venv; do
    [[ -n $venv && " ${PIPX_SKIP[*]} " != *" $venv "* ]] && run_tool pipx "$venv"
done < <(pipx list --json 2>/dev/null | jq -r '.venvs | keys[]')
while read -r t; do
    [[ -n $t ]] && run_tool uv "$t"
done < <(uv tool list 2>/dev/null | awk '/^[^- ]/ {print $1}')
run_tool binary rtk
run_tool cbm codebase-memory-mcp

if (( ${#FAILED[@]} )); then
    msg=$(printf '%s; ' "${FAILED[@]}"); msg=${msg%; }
    if dry; then
        log "would notify: $msg"
    else
        "$NOTIFY" tool-failed "$msg" || log "!! could not send the failure notice"
    fi
    log "=== update-dev-tools done: ${#FAILED[@]} failed ==="
    exit 1
fi
log "=== update-dev-tools done ==="
