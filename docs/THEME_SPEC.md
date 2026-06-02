# Archeotech Theme Specification

This document defines the file structure, JSON schema, and apply mechanics
for an Archeotech theme. It is the contract referenced by `theme-switch.py`
and the `AppearancePane` card grid.

> Sprint 19 — initial spec. Wallpaper layer is intentionally **out of scope**:
> themes change colors/fonts/icons only, never the desktop wallpaper. Wallpaper
> selection lives in its own strip-panel picker.

---

## Folder layout

```
~/.config/archeotech/themes/<variant>/
└── theme.json     # The whole theme. No other files required.
```

The directory is conventionally stowed from
`config/.config/archeotech/themes/<variant>/` in the dotfiles repo.

Templates that drive non-Quickshell apps (starship, rofi-colors) live in the
shared `scripts/themes/templates/` folder and are substituted with values
from `theme.json` at switch time — they are **not** per-theme files. That
keeps the source of truth in one place: `theme.json`.

---

## `theme.json` schema

All fields are required unless noted *(optional)*. Hex colors are full
`#rrggbb`. MangoWC colors are `0xrrggbbaa`.

```jsonc
{
  "name": "archeotech-macchiato",          // matches the directory name

  "colors": {                              // Catppuccin-shape palette
    "base":      "#24273a", "mantle":   "#1e2030", "crust":    "#181926",
    "surface0":  "#363a4f", "surface1": "#494d64", "surface2": "#5b6078",
    "text":      "#cad3f5", "subtext1": "#b8c0e0", "subtext0": "#a5adcb",
    "overlay2":  "#939ab7", "overlay1": "#8087a2", "overlay0": "#6e738d",
    "mauve":     "#c6a0f6", "blue":     "#8aadf4", "sapphire": "#7dc4e4",
    "sky":       "#91d7e3", "teal":     "#8bd5ca", "green":    "#a6da95",
    "yellow":    "#eed49f", "peach":    "#f5a97f", "maroon":   "#ee99a0",
    "red":       "#ed8796", "pink":     "#f5bde6", "flamingo": "#f0c6c6",
    "rosewater": "#f4dbd6", "lavender": "#b7bdf8"
  },

  "mango": {                               // mango/config.conf patches
    "shadowscolor": "0x00000066",          // ⚠ neutral, never accent-colored
    "shadows_size": 20,
    "bordercolor":  "0x6e738dff",
    "focuscolor":   "0xc6a0f6ff",
    "urgentcolor":  "0xed8796ff"
  },

  "kitty": {                               // copies kitty/themes/<theme>.conf
    "theme": "macchiato"                   //   → kitty/current-theme.conf
  },

  "rofi": {                                // values for rofi-colors.rasi.tmpl
    "bg": "#1e2030",  "bg_alt": "#363a4f",
    "fg": "#cad3f5",  "fg_alt": "#b8c0e0",
    "border":   "#c6a0f6",
    "selected": "#494d64",
    "urgent":   "#ed8796"
  },

  "gtk": {                                 // applied via gsettings + ini patch
    "theme":  "catppuccin-macchiato-mauve-standard+default",
    "icon":   "Papirus-Dark",
    "cursor": "catppuccin-macchiato-mauve-cursors"
  },

  "vscode": {                              // jq patch on Code/User/settings.json
    "theme": "Catppuccin Macchiato",       // workbench.colorTheme
    "icon":  "catppuccin-macchiato"        // workbench.iconTheme (optional)
  },

  "obsidian": {                            // jq patch on .obsidian/appearance.json
    "css_theme": "AnuPpuccin"              // empty string = default theme
  },

  "card": {                                // metadata for the AppearancePane grid
    "display": "Macchiato",                // human-readable name shown on the card
    "accents": ["#c6a0f6", "#8aadf4",      // 4-color swatch row
                "#a6da95", "#eed49f"]
  }
}
```

> Note: the `card.*` metadata is currently mirrored in `AppearancePane.qml`'s
> hardcoded `_themes` list. A future `ThemeRegistry` singleton will discover
> themes by scanning the directory and reading each `theme.json` directly.

---

## Apply mechanics — what `theme-switch.py` does

The script is a single-process Python driver. It takes an `fcntl` non-blocking
exclusive lock on `~/.config/archeotech/theme.lock` so simultaneous invocations
do not race.

| Target     | Mechanism                                                                                                    | Reload signal                       |
|------------|--------------------------------------------------------------------------------------------------------------|--------------------------------------|
| Quickshell | Atomic write of `theme.json` → `~/.config/archeotech/theme.json`                                             | `qs ipc call theme reload`           |
| Kitty      | `cp themes/<kitty.theme>.conf → kitty/current-theme.conf`                                                    | `pkill -USR1 kitty`                  |
| MangoWC    | Regex-patch `shadowscolor` / `shadows_size` / `bordercolor` / `focuscolor` / `urgentcolor` in `mango/config.conf` | `mmsg -s -d reload_config`           |
| Rofi       | Render `rofi-colors.rasi.tmpl` → `~/.config/rofi/colors.rasi` (theme.rasi `@imports` it)                    | none (read on next rofi launch)      |
| Starship   | Render `starship.toml.tmpl` → `~/.config/starship.toml`                                                       | none (read on next prompt)           |
| GTK 3/4    | Regex-patch `settings.ini` + `gsettings set org.gnome.desktop.interface gtk-theme / icon-theme / cursor-theme` | gsettings broadcast                  |
| VSCode     | `jq` patch on `Code/User/settings.json` (`workbench.colorTheme`, `workbench.iconTheme`)                       | VSCode auto-reloads on save          |
| Obsidian   | `jq` patch on every `Documents/*/.obsidian/appearance.json` (`cssTheme`)                                      | Obsidian reloads CSS on mtime change |

### Atomic writes

Every config patch goes through `atomic_write(path, content)`:

1. If `path` is a symlink (e.g. stow-managed `starship.toml`), resolve it
   first so the symlink stays intact.
2. Create a temp file in the same directory as the target.
3. Write content + close.
4. `os.replace(tmp, target)` — atomic rename, readers never see a torn file.

### Failure isolation

Each applier runs inside a `try/except`. A failure in one target logs a
warning but never breaks the rest of the switch.

---

## Adding a new theme

1. Pick a slug (`my-theme`). Create the directory:
   ```
   config/.config/archeotech/themes/my-theme/
   ```
2. Write `theme.json` following the schema above. Pay attention to:
   - `shadowscolor` stays **neutral** (`0x00000066`) — never accent-colored.
     See `.claude/feedback_mangowc_shadow_color.md`.
   - `card.accents` should be 4 colors from your palette that read well at
     16px swatch height.
3. Add a kitty theme file at `kitty/themes/<kitty.theme>.conf` (or pick an
   existing one).
4. Add the theme to `AppearancePane.qml`'s `_themes` array (display + accents).
5. Switch to it: `theme-switch.sh my-theme`.

---

## What is intentionally **not** in this spec

- **Wallpaper.** Themes do not change the desktop wallpaper. Wallpaper picking
  is its own UI (right-strip wallpaper icon → grid panel). This decoupling means
  any wallpaper can be paired with any theme.
- **Per-monitor variants.** A theme is a single palette. Per-screen rules live
  in `shell-config.json`'s `perScreen` block, not in `theme.json`.
- **Light mode.** All built-in themes are dark. Light mode is on the roadmap as
  a future flag inside `theme.json` (`"mode": "dark" | "light"`).
- **Wallpaper-extracted colors (matugen / wallust / pywal).** Archeotech is
  intentionally a **curated** theme system, not a dynamic one — see
  `.claude/DECISIONS.md`.

---

## References

- Caelestia template / state-file pattern: `cli/src/caelestia/utils/theme.py`
- DMS template registry: `core/internal/matugen/matugen.go`
- Noctalia `Services/Theming/`: declarative TemplateRegistry table
- HyDE `Configs/.local/lib/hyde/theme.switch.sh`: gold-standard for fan-out
