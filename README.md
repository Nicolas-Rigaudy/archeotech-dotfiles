# Archeotech Dotfiles - Arch + Hyprland + MangoWC

Personal dotfiles for Arch Linux with Hyprland (primary) and MangoWC (testing) desktop environments with Catppuccin Macchiato theming.

**Theme:** Catppuccin Macchiato with Mauve accent
**Managed with:** GNU Stow + Git
**Compositors:** Hyprland (stable daily driver), MangoWC (testing scrolling layouts)

---

## Features

- ✨ **Hyprland** - Modern Wayland compositor with animations (primary)
- 🔄 **MangoWC** - Testing scrolling layout feature (parallel install)
- 🎨 **Catppuccin Macchiato** - Consistent theming across all apps
- 🔗 **Stow-based** - Symlink management for easy deployment
- 📝 **Fully documented** - Complete installation and usage guides
- 🔄 **Git-tracked** - Version controlled configs
- 🖥️ **Multi-compositor** - Switch between Hyprland/MangoWC at login

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
│   ├── backup.sh        # Backup utility
│   └── session-*.sh     # Session management
├── docs/
│   ├── INSTALLATION.md  # Full Arch + Hyprland install guide
│   ├── KEYBINDS.md      # All keybindings reference
│   └── PACKAGES.md      # Package list with explanations
├── .claude/             # Claude Code project files
│   ├── claude.md        # Main project knowledge base
│   ├── DECISIONS.md     # Technical decisions log
│   ├── TROUBLESHOOTING.md # Known issues & solutions
│   └── STYLE_GUIDE.md   # Aesthetic guidelines
└── README.md            # This file
```

---

## Included Configs

- **Hyprland** - Window manager config, keybinds, animations
- **Waybar** - Status bar with Catppuccin styling
- **Kitty** - Terminal with FiraCode Nerd Font
- **Rofi** - Application launcher
- **Fish** - Shell configuration
- **Starship** - Prompt configuration
- **GTK 3/4** - Theme settings
- **Btop** - System monitor
- **Yazi** - Terminal file manager

---

## Documentation

- 📖 **[Installation Guide](docs/INSTALLATION.md)** - Complete Arch + Hyprland setup
- ⌨️ **[Keybindings](docs/KEYBINDS.md)** - All keyboard shortcuts
- 📦 **[Package List](docs/PACKAGES.md)** - What's installed and why
- 🎨 **[Style Guide](.claude/STYLE_GUIDE.md)** - Aesthetic direction
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

## System Specifications

Built and tested on:
- **Laptop:** HP EliteBook 860 G10
- **CPU:** Intel i7-1355U (13th gen)
- **RAM:** 32GB
- **GPU:** Intel Iris Xe (integrated)
- **Display:** 1920x1200 @ 60Hz
- **Multi-monitor:** 3-screen setup (laptop + 2 external)

---

## Managed with Claude Code

This repository is designed to work with [Claude Code](https://claude.com/claude-code) for assisted development.

See [.claude/README.md](.claude/README.md) for Claude Code setup instructions.

---

## License

Personal dotfiles - use at your own risk. Feel free to steal anything useful!

---

**Last Updated:** 2025-12-01
**Status:** ✅ Fully Functional
**Daily Driver:** Yes
