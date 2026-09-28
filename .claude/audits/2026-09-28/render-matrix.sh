#!/bin/bash
# matrix.sh <variant> <pack|""> <flat 0|1> <state|""> <out.png>
# Renders the shell in an isolated fake HOME so the nested instance never
# reads/writes the real ~/.config/archeotech or ~/.local/share/archeotech.
set -u
VARIANT=$1; PACK=$2; FLAT=$3; STATE=$4; OUT=$5
SP=/tmp/claude-1000/-home-corvus-Projects-archeotech-dotfiles/4861582f-2fa4-4e3d-8fb3-4e42364d4d5e/scratchpad
SHELL_REPO=/home/corvus/Projects/archeotech-shell
FHP=$(mktemp -d "$SP/fh.XXXX"); FH="$FHP/corvus"; mkdir -p "$FH"
mkdir -p "$FH/.config/quickshell" "$FH/.config/archeotech" "$FH/.local/share/archeotech" "$FH/.cache"
ln -s "$SHELL_REPO" "$FH/.config/quickshell/archeotech"
R=/home/corvus/.config/archeotech
for l in assets themes wallpapers; do ln -s "$(readlink -f $R/$l)" "$FH/.config/archeotech/$l"; done
cp "$R/shell-config.json" "$FH/.config/archeotech/"
cp -r /home/corvus/.cache/archeotech /home/corvus/.cache/awww "$FH/.cache/" 2>/dev/null
ln -s /home/corvus/.local/bin "$FH/.local/bin"
ln -s /home/corvus/Projects "$FH/Projects"
WP=${WP:-/home/corvus/.config/archeotech/wallpapers/$(ls /home/corvus/.config/archeotech/wallpapers | grep -iE 'shark|hammer' | head -1)}
mkdir -p "$FH/.config/mango"
printf 'exec-once=sh -c "awww-daemon & sleep 1; awww img %s"\n' "$WP" > "$FH/.config/mango/config.conf"
python3 - "$SHELL_REPO/themes/$VARIANT/theme.json" "$R/config.json" "$FH" "$VARIANT" "$PACK" "$FLAT" <<'EOF'
import json, sys
tj, cj, fh, variant, pack, flat = sys.argv[1:]
t = json.load(open(tj)); c = json.load(open(cj))
mode = t.get("mode", "dark")
t["_dir"] = f"{fh}/.config/archeotech/themes/{variant}"
json.dump(t, open(f"{fh}/.config/archeotech/theme.json", "w"), indent=2)
c["theme"]["variant"] = variant
cs = c.setdefault("colorScheme", {})
cs["mode"] = mode; cs["family"] = t.get("family", cs.get("family"))
if mode == "dark": cs["flavorDark"] = t.get("flavor", cs.get("flavorDark"))
else: cs["flavorLight"] = t.get("flavor", cs.get("flavorLight"))
c["appearance"]["activePack"] = pack
c["appearance"]["flatMode"] = flat == "1"
json.dump(c, open(f"{fh}/.config/archeotech/config.json", "w"), indent=2)
EOF
ARGS=(-w 10)
[ -n "$STATE" ] && ARGS+=(--state "$STATE")
cd "$SHELL_REPO" && HOME="$FH" timeout 90 ./scripts/shot.sh "${ARGS[@]}" "$OUT" >/dev/null 2>&1
echo "$(basename "$OUT"): $(file -b "$OUT" 2>/dev/null | cut -c1-20)"
rm -rf "$FHP"
