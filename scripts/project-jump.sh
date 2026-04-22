#!/bin/bash
# project-jump.sh — Rofi project launcher (Super+Ctrl+P)
# Scans ~/Projects (personal) and ~/repos (work) for git repos.
# Selecting a project opens VSCode + a kitty terminal in that directory.
#
# Dependencies: rofi, code, kitty

SCRIPT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"
ROFI_THEME="$SCRIPT_DIR/assets/settings-hub.rasi"

PERSONAL_DIR="$HOME/Projects"
WORK_DIR="$HOME/Documents/repos"

# ── Collect repos ─────────────────────────────────────────────────────────────
# Each entry: "ICON  name\tpath"  (tab-separated, icon prefix for source)

ENTRIES=()
PATHS=()

add_repos() {
    local dir="$1"
    local icon="$2"

    [ -d "$dir" ] || return

    while IFS= read -r repo; do
        local name
        name=$(basename "$repo")
        ENTRIES+=("${icon}  ${name}")
        PATHS+=("$repo")
    done < <(find "$dir" -maxdepth 2 -mindepth 2 -type d -name ".git" -printf "%h\n" 2>/dev/null \
        | sort --ignore-case)
}

add_repos "$PERSONAL_DIR" ""  # nf-md-home personal
add_repos "$WORK_DIR"     "󰃖"  # nf-md-briefcase work

# ── Nothing found ─────────────────────────────────────────────────────────────
if [ ${#ENTRIES[@]} -eq 0 ]; then
    notify-send "Project Jump" "No git repos found in $PERSONAL_DIR or $WORK_DIR"
    exit 0
fi

# ── Rofi picker ───────────────────────────────────────────────────────────────
ROFI_INPUT=$(printf '%s\n' "${ENTRIES[@]}")

SELECTED=$(echo "$ROFI_INPUT" | rofi \
    -dmenu \
    -i \
    -p "󰊢" \
    -theme "$ROFI_THEME" \
    2>/dev/null)

[ -z "$SELECTED" ] && exit 0

# ── Resolve path ──────────────────────────────────────────────────────────────
for i in "${!ENTRIES[@]}"; do
    if [ "${ENTRIES[$i]}" = "$SELECTED" ]; then
        PROJECT_PATH="${PATHS[$i]}"
        break
    fi
done

[ -z "$PROJECT_PATH" ] && exit 1

# ── Launch ────────────────────────────────────────────────────────────────────
code "$PROJECT_PATH" &
kitty --directory "$PROJECT_PATH" &
