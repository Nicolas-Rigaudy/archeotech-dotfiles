#!/usr/bin/env bash
# downloads-tidy.sh: sort loose files in ~/Downloads into type folders
# (req_017 / item_178). Run daily by downloads-tidy.timer.
#
#   downloads-tidy.sh [--dry-run]
#
# Moves only top-level regular files. Leaves alone: folders, dotfiles,
# partial downloads (.part .crdownload .download .tmp), and anything modified
# in the last day (it may still be in use). Never deletes and never
# overwrites: a name clash becomes "name (2).ext".
# --dry-run prints the planned moves and changes nothing.
#
# Every move is logged, tab-separated, to
#   ${XDG_STATE_HOME:-~/.local/state}/downloads-tidy/moves.log
#   <run time> <TAB> <from> <TAB> <to>
# so a run can be undone by hand (docs/TOOLS.md has the one-liner).
# Env: DOWNLOADS_DIR (default: XDG download dir, else ~/Downloads),
#      DOWNLOADS_MIN_AGE_MIN (default 1440, one day).
set -euo pipefail

dry=0
case ${1:-} in
    --dry-run) dry=1 ;;
    "") ;;
    *) echo "usage: ${0##*/} [--dry-run]" >&2; exit 2 ;;
esac

dir=${DOWNLOADS_DIR:-$(xdg-user-dir DOWNLOAD 2>/dev/null || true)}
[[ -n $dir && $dir != "$HOME" ]] || dir=$HOME/Downloads
[[ -d $dir ]] || { echo "${0##*/}: no such folder: $dir" >&2; exit 1; }
min_age=${DOWNLOADS_MIN_AGE_MIN:-1440}
log=${XDG_STATE_HOME:-$HOME/.local/state}/downloads-tidy/moves.log

# The folder map: extension (lowercase) -> folder. Multi-part endings first.
# No extension (meeting notes, transcripts) -> Documents (owner, 2026-11-24).
folder_for() {
    local name=${1,,}
    case $name in
        *.part|*.crdownload|*.download|*.tmp) echo SKIP; return ;;
        *.pkg.tar.zst|*.pkg.tar.xz) echo Installers; return ;;
        *.tar.gz|*.tar.xz|*.tar.bz2|*.tar.zst) echo Archives; return ;;
    esac
    [[ $name == *.* ]] || { echo Documents; return; }
    case ${name##*.} in
        png|jpg|jpeg|gif|webp|svg|bmp|tif|tiff|heic|avif|ico) echo Images ;;
        pdf|md|txt|doc|docx|odt|rtf|xls|xlsx|ods|epub|html|htm) echo Documents ;;
        ppt|pptx|odp|key) echo Slides ;;
        zip|tar|tgz|gz|xz|bz2|zst|7z|rar) echo Archives ;;
        mp4|mkv|webm|mov|avi|mp3|flac|ogg|wav|m4a|opus) echo Media ;;
        exe|msi|deb|rpm|appimage|dmg|iso|jar) echo Installers ;;
        stl|stp|step|obj|glb|gltf|blend|blend1|3mf|fbx|f3d) echo 3D ;;
        json|csv|tsv|yaml|yml|xml|toml|sql) echo Data ;;
        *) echo Other ;;
    esac
}

# free_name <folder> <file name> -> a path in folder that does not exist yet
free_name() {
    local dest=$1/$2 base ext n=2
    [[ ! -e $dest ]] && { echo "$dest"; return; }
    if [[ $2 == ?*.* ]]; then base=${2%.*}; ext=.${2##*.}; else base=$2; ext=""; fi
    while [[ -e "$1/$base ($n)$ext" ]]; do n=$((n + 1)); done
    echo "$1/$base ($n)$ext"
}

run=$(date -Is)
moved=0
(( dry )) || mkdir -p "$(dirname "$log")"
while IFS= read -r -d '' f; do
    name=${f##*/}
    target=$(folder_for "$name")
    [[ $target == SKIP ]] && continue
    dest=$(free_name "$dir/$target" "$name")
    if (( dry )); then
        echo "would move: $name -> $target/${dest##*/}"
    else
        mkdir -p "$dir/$target"
        mv -n -- "$f" "$dest"
        printf '%s\t%s\t%s\n' "$run" "$f" "$dest" >>"$log"
        echo "moved: $name -> $target/${dest##*/}"
    fi
    moved=$((moved + 1))
done < <(find "$dir" -mindepth 1 -maxdepth 1 -type f ! -name '.*' -mmin +"$min_age" -print0 | sort -z)

if (( dry )); then echo "$moved file(s) would move; nothing changed"
else echo "$moved file(s) moved; log: $log"; fi
