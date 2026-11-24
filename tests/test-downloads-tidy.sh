#!/usr/bin/env bash
# Tests for scripts/downloads-tidy.sh (item_178) on a temp folder.
# shellcheck disable=SC2016,SC2034,SC2329  # check() evals its single-quoted conditions
set -uo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
export DOWNLOADS_DIR=$TMP/dl
export XDG_STATE_HOME=$TMP/state
TIDY=$ROOT/scripts/downloads-tidy.sh
LOG=$XDG_STATE_HOME/downloads-tidy/moves.log
fails=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; fails=$((fails + 1)); fi; }
old() { for f; do echo x >"$DOWNLOADS_DIR/$f"; touch -d '3 days ago' "$DOWNLOADS_DIR/$f"; done; }
count() { find "$DOWNLOADS_DIR" -type f | wc -l; }
loose() { find "$DOWNLOADS_DIR" -mindepth 1 -maxdepth 1 -type f -printf '%f\n' | LC_ALL=C sort | tr '\n' ' '; }

mkdir -p "$DOWNLOADS_DIR/Images" "$DOWNLOADS_DIR/some folder"
old photo.PNG scan.pdf deck.pptx src.tar.gz paru-1.pkg.tar.zst clip.mov setup.exe \
    part.stl data.csv conf.yaml notes "weird.cdx" "space name.jpg" big.zip.part
echo x >"$DOWNLOADS_DIR/fresh.pdf"                 # modified now: stays
echo x >"$DOWNLOADS_DIR/.hidden"; touch -d '3 days ago' "$DOWNLOADS_DIR/.hidden"
echo old >"$DOWNLOADS_DIR/Images/photo.PNG"        # forces a name clash
echo x >"$DOWNLOADS_DIR/some folder/inner.pdf"; touch -d '3 days ago' "$DOWNLOADS_DIR/some folder/inner.pdf"

before=$(count)
snap=$(find "$DOWNLOADS_DIR" -printf '%P\n' | sort)
out=$("$TIDY" --dry-run)
check "AC3: dry run lists planned moves" '[[ $out == *"would move: scan.pdf -> Documents/scan.pdf"* ]]'
check "AC3: dry run changes nothing" '[[ $(find "$DOWNLOADS_DIR" -printf "%P\n" | sort) == "$snap" && ! -e $LOG ]]'

"$TIDY" >/dev/null
after=$(count)
check "AC3: file count before and after is equal" '[[ $before -eq $after ]]'
check "AC3: only fresh, partial and hidden files stay loose" '[[ $(loose) == ".hidden big.zip.part fresh.pdf " ]]'
for pair in Images/photo\ \(2\).PNG Documents/scan.pdf Slides/deck.pptx Archives/src.tar.gz \
        Installers/paru-1.pkg.tar.zst Media/clip.mov Installers/setup.exe 3D/part.stl \
        Data/data.csv Data/conf.yaml Other/notes Other/weird.cdx "Images/space name.jpg"; do
    check "sorted: $pair" '[[ -f "$DOWNLOADS_DIR/$pair" ]]'
done
check "a clash never overwrites" '[[ $(cat "$DOWNLOADS_DIR/Images/photo.PNG") == old ]]'
check "subfolders are not touched" '[[ -f "$DOWNLOADS_DIR/some folder/inner.pdf" ]]'
check "every move is logged" '[[ $(wc -l <"$LOG") -eq 13 ]]'
check "log lines are run<TAB>from<TAB>to" '[[ $(awk -F"\t" "NF != 3" "$LOG" | wc -l) -eq 0 ]]'

# undo by hand, as docs/TOOLS.md shows: the last run back in place
last=$(tail -1 "$LOG" | cut -f1)
awk -F'\t' -v r="$last" '$1 == r {print $3 "\t" $2}' "$LOG" | while IFS=$'\t' read -r to from; do mv -n -- "$to" "$from"; done
check "the logged undo puts files back" '[[ -f "$DOWNLOADS_DIR/scan.pdf" && -f "$DOWNLOADS_DIR/photo.PNG" && $(count) -eq $before ]]'

out=$("$TIDY")
check "a second run moves them again" '[[ $out == *"13 file(s) moved"* ]]'
check "and the clash counter goes on" '[[ -f "$DOWNLOADS_DIR/Images/photo (2).PNG" ]]'

echo
(( fails == 0 )) && echo "all passed" || echo "$fails failed"
exit $(( fails > 0 ))
