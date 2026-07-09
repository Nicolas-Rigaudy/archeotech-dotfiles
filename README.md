# Archeotech Dotfiles - Arch + MangoWC/Hyprland

Personal dotfiles for Arch Linux with MangoWC (primary) and Hyprland (backup) desktop environments with Catppuccin Macchiato theming.

**Theme:** Catppuccin Macchiato with Mauve accent
**Managed with:** GNU Stow + Git
**Compositors:** MangoWC (primary - scrolling layouts), Hyprland (backup)

---

> **The desktop shell lives in a separate repo.** As of 2026-07-09 the Archeotech
> Quickshell shell (bar, panels, launcher, theme system — the publishable product)
> was split out into **[archeotech-shell](https://github.com/Nicolas-Rigaudy/archeotech-shell)**.
> This repo is now **only the personal machine config** (compositor keybinds + monitor
> rules, kitty/fish/rofi/etc, system files, wallpapers). The shell is deployed
> separately — its own `install.sh` symlinks it to `~/.config/quickshell/archeotech`
> and it's launched with `qs -c archeotech` (see the mango config here for the
> launch/IPC binds). See `.claude/DECISIONS.md [2026-07-09]` for the split rationale.
>
> _Note: sections below still describe the older waybar-era layout and are due a refresh._

---

## Features

- ✨ **MangoWC** - Modern Wayland compositor with scrolling layouts (primary)
- 🔄 **Hyprland** - Stable fallback compositor with animations (backup)
- 🎨 **Catppuccin Macchiato** - Consistent theming across all apps
- 🔗 **Stow-based** - Symlink management for easy deployment
- 📝 **Fully documented** - Complete installation and usage guides
- 🔄 **Git-tracked** - Version controlled configs
- 🖥️ **Multi-compositor** - Switch between MangoWC/Hyprland at login

---

## Quick Start

### 1. Install Stow

```bash
sudo pacman -S stow
```

### 2. Clone Repository

```bash
cd ~/Projects
git clone https://github.com/Nicolas-Rigaudy/archeotech-dotfiles.git
cd archeotech-dotfiles
```

### 3. Deploy Configs

```bash
./scripts/install.sh
```

This will:
- Backup your existing configs
- Create symlinks from `~/.config/` to this repo
- Verify everything is working

**That's it!** Your configs are now managed by this repository.

---

## How It Works

This repo uses **GNU Stow** to create symlinks:

```
~/.config/hypr/  →  ~/Projects/archeotech-dotfiles/config/.config/hypr/
~/.config/waybar/ →  ~/Projects/archeotech-dotfiles/config/.config/waybar/
...
```

When you edit `~/.config/hypr/hyprland.conf`, you're editing the repo file directly. Changes are automatically tracked by git!

---

## Repository Structure

```
archeotech-dotfiles/
├── config/              # Stow package for .config files
│   └── .config/
│       ├── hypr/        # Hyprland configs
│       ├── waybar/      # Status bar configs
│       ├── kitty/       # Terminal configs
│       ├── fish/        # Shell configs
│       └── ...
├── scripts/
│   ├── install.sh       # Deploy dotfiles (stow)
│   ├── uninstall.sh     # Remove symlinks
│   └── setup-snapper.sh # Snapshot management setup
├── docs/
│   ├── INSTALLATION.md      # Full Arch + MangoWC/Hyprland install guide
│   ├── KEYBINDS-MANGO.md    # MangoWC keybindings (primary)
│   ├── KEYBINDS.md          # Hyprland keybindings (backup)
│   ├── PACKAGES.md          # Package list with explanations
│   └── TOOLS.md             # Tool configurations and usage
├── .claude/                 # Claude Code project files
│   ├── claude.md            # Main project knowledge base
│   ├── DECISIONS.md         # Technical decisions log
│   ├── TROUBLESHOOTING.md   # Known issues & solutions
│   ├── STYLE_GUIDE.md       # Theme and design patterns
│   └── sessions/            # Session summaries
└── README.md                # This file
```

---

## Included Configs

- **MangoWC** - Primary compositor with scrolling layout configs
- **Hyprland** - Backup compositor config, keybinds, animations
- **Waybar** - Status bar with Catppuccin styling (works on both)
- **Kitty** - Terminal with FiraCode Nerd Font
- **Rofi** - Application launcher
- **Fish** - Shell configuration with productivity tools
- **Starship** - Prompt configuration
- **GTK 3/4** - Theme settings
- **Btop** - System monitor
- **Yazi** - Terminal file manager

---

## Documentation

- 📖 **[Installation Guide](docs/INSTALLATION.md)** - Complete Arch + Hyprland setup
- 🖥️ **MangoWC Setup** - moved to the [archeotech-shell repo](https://github.com/Nicolas-Rigaudy/archeotech-shell) (`docs/MANGOWC-SETUP.md` there)
- ⌨️ **[MangoWC Keybindings](docs/KEYBINDS-MANGO.md)** - Primary compositor shortcuts
- ⌨️ **[Hyprland Keybindings](docs/KEYBINDS.md)** - Backup compositor shortcuts
- 📦 **[Package List](docs/PACKAGES.md)** - What's installed and why
- 🛠️ **[Tools Guide](docs/TOOLS.md)** - Tool configurations and usage
- 🎨 **[Style Guide](.claude/STYLE_GUIDE.md)** - Theme and design patterns
- 🔧 **[Troubleshooting](.claude/TROUBLESHOOTING.md)** - Common issues & fixes

---

## Managing Your Dotfiles

### Making Changes

Just edit files normally:
```bash
nvim ~/.config/hypr/hyprland.conf
```

Since it's a symlink, you're editing the repo file directly.

### Committing Changes

```bash
cd ~/Projects/archeotech-dotfiles
git status                    # See what changed
git add config/.config/hypr/  # Stage changes
git commit -m "Update keybinds"
git push
```

### Deploying to Another Machine

```bash
git clone <your-repo>
cd archeotech-dotfiles
./scripts/install.sh
```

### Removing Dotfiles

```bash
./scripts/uninstall.sh  # Removes symlinks, keeps repo intact
```

---

## License

Personal dotfiles - use at your own risk. Feel free to steal anything useful!

---

**Last Updated:** 2026-07-09 (shell split out to archeotech-shell)
**Status:** ✅ Fully Functional
**Primary Compositor:** MangoWC (scrolling layouts)
**Backup Compositor:** Hyprland
**Daily Driver:** Yes
