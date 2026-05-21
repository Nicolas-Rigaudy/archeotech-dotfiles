#!/usr/bin/env bash
# theme-switch.sh — Switch archeotech shell theme
# Usage: theme-switch.sh <variant>
# Example: theme-switch.sh archeotech-macchiato
set -euo pipefail

VARIANT="${1:-archeotech-macchiato}"

python3 - "${VARIANT}" <<'EOF'
import json, os, re, shutil, subprocess, sys

variant = sys.argv[1]
home    = os.path.expanduser("~")
src     = f"{home}/.config/archeotech/themes/{variant}/theme.json"
dst     = f"{home}/.config/archeotech/theme.json"

if not os.path.exists(src):
    print(f"theme-switch: unknown theme '{variant}' (no file at {src})", file=sys.stderr)
    sys.exit(1)

with open(src) as f:
    theme = json.load(f)

# 1 — Copy theme.json; ThemeLoader hot-reloads the QML shell automatically
os.makedirs(os.path.dirname(dst), exist_ok=True)
shutil.copy(src, dst)

# 2 — Patch rofi theme.rasi
rofi_path = f"{home}/.config/rofi/theme.rasi"
if os.path.exists(rofi_path):
    text = open(rofi_path).read()
    r    = theme["rofi"]
    text = re.sub(r"(\bbg:\s*)#[0-9a-fA-F]+;",      rf"\g<1>{r['bg']};",       text)
    text = re.sub(r"(\bbg-alt:\s*)#[0-9a-fA-F]+;",  rf"\g<1>{r['bg_alt']};",   text)
    text = re.sub(r"(\bfg:\s*)#[0-9a-fA-F]+;",      rf"\g<1>{r['fg']};",       text)
    text = re.sub(r"(\bfg-alt:\s*)#[0-9a-fA-F]+;",  rf"\g<1>{r['fg_alt']};",   text)
    text = re.sub(r"(\bborder:\s*)#[0-9a-fA-F]+;",  rf"\g<1>{r['border']};",   text)
    text = re.sub(r"(\bselected:\s*)#[0-9a-fA-F]+;",rf"\g<1>{r['selected']};", text)
    text = re.sub(r"(\burgent:\s*)#[0-9a-fA-F]+;",  rf"\g<1>{r['urgent']};",   text)
    open(rofi_path, "w").write(text)

# 3 — Patch MangoWC config and trigger a live reload
# reload_config resets monitor positions — mango-reload.sh re-applies them afterwards if needed
mango_path = f"{home}/.config/mango/config.conf"
if os.path.exists(mango_path):
    text = open(mango_path).read()
    m    = theme["mango"]
    text = re.sub(r"^shadowscolor=.*$", f"shadowscolor={m['shadowscolor']}",  text, flags=re.M)
    text = re.sub(r"^shadows_size=.*$", f"shadows_size={m['shadows_size']}",   text, flags=re.M)
    text = re.sub(r"^bordercolor=.*$",  f"bordercolor={m['bordercolor']}",     text, flags=re.M)
    text = re.sub(r"^focuscolor=.*$",   f"focuscolor={m['focuscolor']}",       text, flags=re.M)
    text = re.sub(r"^urgentcolor=.*$",  f"urgentcolor={m['urgentcolor']}",     text, flags=re.M)
    open(mango_path, "w").write(text)
    subprocess.run(["mmsg", "-s", "-d", "reload_config"], check=False)

# 4 — Update kitty current-theme.conf and hot-reload kitty
kitty_src = f"{home}/.config/kitty/themes/{theme['kitty']['theme']}.conf"
kitty_dst = f"{home}/.config/kitty/current-theme.conf"
if os.path.exists(kitty_src):
    shutil.copy(kitty_src, kitty_dst)
    subprocess.run(["pkill", "-USR1", "-x", "kitty"], check=False)

# 5 — Notify Quickshell to reload the theme (watchChanges alone is unreliable)
subprocess.run(["qs", "ipc", "call", "theme", "reload"], check=False)

print(f"theme-switch: switched to {variant}")
EOF
