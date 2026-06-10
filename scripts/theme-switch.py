#!/usr/bin/env python3
# theme-switch.py — Archeotech system-wide theme switcher.
#
# Reads ~/.config/archeotech/themes/<variant>/theme.json, then applies that
# palette across every targeted app via a declarative per-target table.
#
# Patterns lifted from Caelestia (atomic temp+rename writes, fcntl lock,
# template registry) and DMS (refresh-by-signal instead of restart).
#
# Usage: theme-switch.py <variant>

from __future__ import annotations

import fcntl
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Any, Callable, Dict, List

HOME = Path.home()
ARCHEOTECH_DIR = HOME / ".config" / "archeotech"
THEMES_DIR = ARCHEOTECH_DIR / "themes"
ACTIVE_THEME_FILE = ARCHEOTECH_DIR / "theme.json"
LOCK_FILE = ARCHEOTECH_DIR / "theme.lock"

REPO_DIR = Path(__file__).resolve().parent.parent
TEMPLATES_DIR = Path(__file__).resolve().parent / "themes" / "templates"


# ── Helpers ──────────────────────────────────────────────────────────────────

def atomic_write(path: Path, content: str) -> None:
    """Temp file + rename — readers never see a torn file.
    If `path` is itself a symlink (e.g. stow-managed `~/.config/starship.toml`),
    write through to the link target so the symlink is preserved."""
    target = path.resolve() if path.is_symlink() else path
    target.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=target.name + ".", dir=target.parent)
    try:
        with os.fdopen(fd, "w") as f:
            f.write(content)
        os.replace(tmp, target)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise


def render(template_name: str, vars: Dict[str, str]) -> str:
    """`{{key}}` substitution. Unknown keys raise KeyError so misnamed
    template tokens fail loudly instead of silently leaving `{{foo}}` in
    the output."""
    text = (TEMPLATES_DIR / template_name).read_text()
    def sub(m: re.Match) -> str:
        key = m.group(1).strip()
        if key not in vars:
            raise KeyError(f"template {template_name}: unknown var '{key}'")
        return vars[key]
    return re.sub(r"\{\{\s*([\w.-]+)\s*\}\}", sub, text)


def run(cmd: List[str], **kwargs: Any) -> subprocess.CompletedProcess:
    """Subprocess wrapper — never raises (callers may inspect returncode)."""
    return subprocess.run(cmd, check=False, capture_output=True, text=True, **kwargs)


def info(msg: str) -> None: print(f"\x1b[1;35m·\x1b[0m {msg}")
def warn(msg: str) -> None: print(f"\x1b[1;33m!\x1b[0m {msg}", file=sys.stderr)
def fail(msg: str) -> None:
    print(f"\x1b[1;31m✗\x1b[0m {msg}", file=sys.stderr)
    sys.exit(1)


# ── Per-target appliers ──────────────────────────────────────────────────────
# Each applier takes the parsed theme dict and a `vars` map (flat color
# names). Failures inside an applier should be logged via warn() but never
# raise — one broken target should not break the rest of the switch.


def apply_quickshell(theme: dict, vars: Dict[str, str]) -> None:
    """Write theme.json to where Quickshell's ThemeLoader watches.
    FileView watchChanges fires, but we also call `qs ipc call theme reload`
    since watchChanges alone is unreliable across atomic renames."""
    atomic_write(ACTIVE_THEME_FILE, json.dumps(theme, indent=2) + "\n")
    run(["qs", "ipc", "call", "theme", "reload"])


def apply_kitty(theme: dict, vars: Dict[str, str]) -> None:
    src = HOME / ".config" / "kitty" / "themes" / f"{theme['kitty']['theme']}.conf"
    dst = HOME / ".config" / "kitty" / "current-theme.conf"
    if not src.exists():
        warn(f"kitty theme file missing: {src}")
        return
    shutil.copy(src, dst)
    run(["pkill", "-USR1", "-x", "kitty"])


def apply_mango(theme: dict, vars: Dict[str, str]) -> None:
    """Patch mango/config.conf lines for shadow/border/focus/urgent colors,
    then trigger live reload via mmsg."""
    path = HOME / ".config" / "mango" / "config.conf"
    if not path.exists():
        warn(f"mango config missing: {path}")
        return
    m = theme.get("mango", {})
    text = path.read_text()
    for key, val in (
        ("shadowscolor", m.get("shadowscolor")),
        ("shadows_size", str(m.get("shadows_size", ""))),
        ("bordercolor",  m.get("bordercolor")),
        ("focuscolor",   m.get("focuscolor")),
        ("urgentcolor",  m.get("urgentcolor")),
    ):
        if val:
            text = re.sub(rf"^{key}=.*$", f"{key}={val}", text, flags=re.M)
    atomic_write(path, text)
    run(["mmsg", "-s", "-d", "reload_config"])


def apply_rofi(theme: dict, vars: Dict[str, str]) -> None:
    """Generate ~/.config/rofi/colors.rasi from the rofi-colors template.
    theme.rasi @imports colors.rasi — rofi reads on next launch."""
    out = HOME / ".config" / "rofi" / "colors.rasi"
    atomic_write(out, render("rofi-colors.rasi.tmpl", vars))


def apply_starship(theme: dict, vars: Dict[str, str]) -> None:
    """Overwrite ~/.config/starship.toml with the rendered theme.
    Starship watches its config file — live shells re-read on next prompt."""
    out = HOME / ".config" / "starship.toml"
    atomic_write(out, render("starship.toml.tmpl", vars))


def apply_swaylock(theme: dict, vars: Dict[str, str]) -> None:
    """Render swaylock/config from the template. swaylock colors are hex
    WITHOUT the leading '#', so feed render() a stripped-hex var map. No reload
    needed — swaylock re-reads its config on the next lock."""
    sl_vars = {k: v.lstrip("#") for k, v in theme.get("colors", {}).items()}
    out = HOME / ".config" / "swaylock" / "config"
    atomic_write(out, render("swaylock.config.tmpl", sl_vars))


def apply_gtk(theme: dict, vars: Dict[str, str]) -> None:
    """Update gtk-3.0/4.0 settings.ini AND gsettings (gtk-3 ini is for apps
    that read it directly; gsettings drives GNOME/Adwaita apps live)."""
    gtk = theme.get("gtk", {})
    if not gtk:
        return
    for ver in ("3.0", "4.0"):
        ini = HOME / ".config" / f"gtk-{ver}" / "settings.ini"
        if not ini.exists():
            continue
        text = ini.read_text()
        for key, val in (
            ("gtk-theme-name",         gtk.get("theme")),
            ("gtk-icon-theme-name",    gtk.get("icon")),
            ("gtk-cursor-theme-name",  gtk.get("cursor")),
        ):
            if val:
                text = re.sub(rf"^{key}=.*$", f"{key}={val}", text, flags=re.M)
        atomic_write(ini, text)
    # gsettings — fires the actual GTK reload signal across running apps.
    iface = "org.gnome.desktop.interface"
    for prop, val in (
        ("gtk-theme",     gtk.get("theme")),
        ("icon-theme",    gtk.get("icon")),
        ("cursor-theme",  gtk.get("cursor")),
    ):
        if val:
            run(["gsettings", "set", iface, prop, val])


def apply_vscode(theme: dict, vars: Dict[str, str]) -> None:
    """Patch workbench.colorTheme via jq. VSCode hot-reloads on save."""
    vs = theme.get("vscode")
    if not vs:
        return
    path = HOME / ".config" / "Code" / "User" / "settings.json"
    if not path.exists():
        return
    if shutil.which("jq") is None:
        warn("jq not installed — skipping VSCode")
        return
    expr = f'.["workbench.colorTheme"] = "{vs["theme"]}"'
    if "icon" in vs:
        expr += f' | .["workbench.iconTheme"] = "{vs["icon"]}"'
    r = run(["jq", expr, str(path)])
    if r.returncode != 0:
        warn(f"jq failed on {path}: {r.stderr.strip()}")
        return
    atomic_write(path, r.stdout)


def apply_obsidian(theme: dict, vars: Dict[str, str]) -> None:
    """Patch every vault's .obsidian/appearance.json. Obsidian reloads CSS
    when appearance.json mtime changes."""
    ob = theme.get("obsidian")
    if not ob:
        return
    if shutil.which("jq") is None:
        warn("jq not installed — skipping Obsidian")
        return
    # Search likely vault locations
    candidates = list((HOME / "Documents").glob("*/.obsidian/appearance.json"))
    candidates += list((HOME / "Notes").glob("*/.obsidian/appearance.json"))
    for path in candidates:
        css = ob.get("css_theme", "")
        r = run(["jq", f'.cssTheme = "{css}"', str(path)])
        if r.returncode != 0:
            warn(f"jq failed on {path}: {r.stderr.strip()}")
            continue
        atomic_write(path, r.stdout)


# ── Registry ─────────────────────────────────────────────────────────────────

Applier = Callable[[dict, Dict[str, str]], None]

REGISTRY: List[tuple[str, Applier]] = [
    ("quickshell", apply_quickshell),
    ("kitty",      apply_kitty),
    ("mango",      apply_mango),
    ("rofi",       apply_rofi),
    ("starship",   apply_starship),
    ("swaylock",   apply_swaylock),
    ("gtk",        apply_gtk),
    ("vscode",     apply_vscode),
    ("obsidian",   apply_obsidian),
]


# ── Driver ───────────────────────────────────────────────────────────────────

def build_vars(theme: dict) -> Dict[str, str]:
    """Flatten the theme into a single name→hex map for template rendering.
    Includes the rofi sub-block so rofi-colors.rasi can reference rofi_bg etc."""
    vars: Dict[str, str] = {"name": theme.get("name", "")}
    for k, v in theme.get("colors", {}).items():
        vars[k] = v
    for k, v in theme.get("rofi", {}).items():
        vars[f"rofi_{k}"] = v
    return vars


def main() -> None:
    if len(sys.argv) < 2:
        fail("usage: theme-switch.py <variant>")
    variant = sys.argv[1]

    src = THEMES_DIR / variant / "theme.json"
    if not src.exists():
        fail(f"unknown theme '{variant}' (no file at {src})")

    # fcntl non-blocking lock prevents stampedes when the user holds a
    # keybind or two pickers race. If we can't get it, exit silently —
    # another switch is already running.
    LOCK_FILE.parent.mkdir(parents=True, exist_ok=True)
    lock_fd = open(LOCK_FILE, "w")
    try:
        fcntl.flock(lock_fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        info("another theme-switch is in progress — skipping")
        return

    with src.open() as f:
        theme = json.load(f)
    vars = build_vars(theme)

    info(f"switching to {variant}")
    for name, applier in REGISTRY:
        try:
            applier(theme, vars)
        except Exception as e:
            warn(f"{name}: {e}")
        else:
            info(f"  ✓ {name}")

    info(f"done: {variant}")


if __name__ == "__main__":
    main()
