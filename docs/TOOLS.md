# Tools Guide

Complete reference for all tools and utilities in this Arch + MangoWC/Hyprland setup.

**Last Updated:** 2025-12-04

---

## Table of Contents

- [Terminal & Shell](#terminal--shell)
- [Development Tools](#development-tools)
- [System Utilities](#system-utilities)
- [Productivity Tools](#productivity-tools)
- [Media & Graphics](#media--graphics)
- [Configuration](#configuration)

---

## Terminal & Shell

### Kitty Terminal
**Package:** `kitty`
**Config:** [~/.config/kitty/kitty.conf](../config/.config/kitty/kitty.conf)

**Features:**
- GPU-accelerated
- Catppuccin Macchiato theme
- FiraCode Nerd Font (11pt) with ligatures
- Image preview support

**Usage:**
```bash
# Launch
kitty

# Keybind: Super+Q
```

### Fish Shell
**Package:** `fish`
**Config:** [~/.config/fish/config.fish](../config/.config/fish/config.fish)

**Features:**
- Syntax highlighting
- Autosuggestions
- Catppuccin Macchiato theme

**Custom Aliases:**
```fish
ls    → exa -al --icons
cat   → bat
lg    → lazygit
c     → clear + fastfetch
```

### Starship Prompt
**Package:** `starship`
**Config:** [~/.config/starship.toml](../config/.config/starship.toml)

**Features:**
- Git branch/status
- Python version
- AWS profile indicator
- Terraform workspace
- Execution time

---

## Development Tools

### Git & Lazygit

#### Lazygit (Git TUI)
**Package:** `lazygit`
**Config:** [~/.config/lazygit/config.yml](../config/.config/lazygit/config.yml)
**Keybind:** `Super+G`
**Alias:** `lg`

**Features:**
- Official Catppuccin Macchiato Mauve theme
- Vim-style keybindings
- Interactive staging/committing
- Branch management

**Common Operations:**
| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `c` | Commit |
| `P` | Push |
| `p` | Pull |
| `a` | Stage all |
| `d` | Discard changes |
| `e` | Edit file |
| `?` | Show help |

**Theme Source:** https://github.com/catppuccin/lazygit

#### Git
**Package:** `git`

**Configured with:**
- SSH keys (restored from Fedora)
- User name and email
- Default branch: main

### AWS CLI
**Package:** `aws-cli`
**Version:** 1.43.2

**Features:**
- SSO authentication configured
- Multiple profiles support
- Works with Granted for easy switching

**Usage:**
```bash
# Login to SSO
aws sso login --profile my-profile

# Check identity
aws sts get-caller-identity --profile my-profile
```

### Granted (AWS Profile Switcher)
**Package:** `granted-bin` (AUR)
**Command:** `assume <profile>`

**Features:**
- Switch AWS profiles instantly
- Open AWS Console in browser
- Fish shell integration

**Usage:**
```bash
# List profiles
assume --list

# Switch profile
assume dev-account

# Open console
assume -c

# Unset credentials
assume -u
```

**Fish Integration:**
```fish
alias assume="source assume"
```

### Terraform
**Package:** `terraform`
**Version:** 1.14.0

**Features:**
- Infrastructure as Code
- AWS provider configured
- State management

### Python Development
**Packages:** `python` (3.13.7), `python-pip` (25.3)

**Tools:**
- pip for package management
- Virtual environments

### Docker & Docker Compose
**Packages:** `docker` (29.0.4), `docker-compose`

**Usage:**
```bash
# Start Docker service
sudo systemctl start docker

# Run container
docker run hello-world

# Docker compose
docker-compose up -d
```

### VSCode
**Package:** `visual-studio-code-bin` (AUR)
**Keybind:** `Super+E`

**Features:**
- All extensions synced
- Settings synced
- Integrated terminal
- Git integration

---

## System Utilities

### Shell History - Atuin
**Package:** `atuin`
**Config:** [~/.config/atuin/config.toml](../config/.config/atuin/config.toml)
**Keybind:** `Ctrl+R` (in terminal)

**Features:**
- Enhanced shell history with fuzzy search
- SQLite backend for fast searches
- Context-aware (shows when/where commands ran)
- Filters out simple commands (ls, cd, pwd)

**Usage:**
```bash
# Search history (Ctrl+R)
# Type anything, fuzzy matched

# View stats
atuin stats

# Manual search
atuin search "terraform"
```

**Config Highlights:**
- Fuzzy search mode
- Compact UI style
- Preview enabled
- Simple commands filtered out

### Interactive Cheatsheets - Navi
**Package:** `navi`
**Config:** [~/.config/navi/config.yaml](../config/.config/navi/config.yaml)
**Keybind:** `Super+Shift+N`

**Features:**
- Interactive command cheatsheets
- Fuzzy searchable
- Variable interpolation
- Custom cheatsheets support

**Usage:**
```bash
# Launch
navi
# Or: Super+Shift+N

# Search and execute commands
# Tab to fill variables
# Enter to execute
```

**Custom Cheatsheets:**
Create in `~/Projects/archeotech-dotfiles/navi-cheats/`

Example format:
```
% terraform

# Plan with var file
terraform plan -var-file=<var_file>

$ var_file: ls *.tfvars
```

### Fast Command Help - Tealdeer
**Package:** `tealdeer`
**Command:** `tldr <command>`

**Features:**
- Rust rewrite of tldr (faster than Node.js version)
- Simplified man pages
- Practical examples

**Usage:**
```bash
# Get quick help
tldr git
tldr terraform
tldr docker

# Update cache
tldr --update
```

### Network Tools

#### Gping (Graphical Ping)
**Package:** `gping`

**Features:**
- Live ping graphs
- Multiple hosts
- Color-coded latency

**Usage:**
```bash
# Single host
gping google.com

# Multiple hosts
gping google.com cloudflare.com
```

### File Navigation

#### Zoxide (Smart cd)
**Package:** `zoxide`

**Features:**
- Learns your most-used directories
- Jump to directories by partial names
- Integrated into fish shell

**Usage:**
```bash
# Jump to directory
cd projects  # Goes to most-used matching directory

# Zoxide commands
z projects   # Same as cd
zi           # Interactive selection
```

#### Eza (Better ls)
**Package:** `eza`
**Alias:** `ls` → `exa -al --icons`

**Features:**
- Colorized output
- Git integration
- Nerd Font icons
- Tree view

**Usage:**
```bash
# Default (aliased to ls)
ls

# Tree view
exa --tree --level=2

# Git status
exa --long --git
```

#### Yazi (Terminal File Manager)
**Package:** `yazi`
**Config:** [~/.config/yazi/](../config/.config/yazi/)

**Features:**
- Modern TUI file manager
- Image preview
- Vim-style navigation
- Fast (Rust-based)

**Usage:**
```bash
# Launch
yazi

# Navigation: h/j/k/l or arrows
# Open file: Enter
# Go back: q
```

### System Monitoring

#### Btop (System Monitor)
**Package:** `btop`
**Config:** [~/.config/btop/](../config/.config/btop/)

**Features:**
- Beautiful TUI system monitor
- CPU, RAM, disk, network monitoring
- Process management

**Usage:**
```bash
# Launch
btop

# Keybinds inside:
# m - menu
# q - quit
# k - kill process
```

#### Fastfetch (System Info)
**Package:** `fastfetch`

**Features:**
- Fast system information display
- ASCII art logo
- Runs on terminal startup

**Usage:**
```bash
# Display system info
fastfetch

# Clear and show (aliased as 'c')
c
```

### Clipboard Management

#### Cliphist
**Package:** `cliphist`
**Keybind:** `Super+V`

**Features:**
- Clipboard history
- Image support
- Rofi integration

**Usage:**
```bash
# Show history (Super+V)
# Select with rofi
# Paste anywhere
```

### Command Correction

#### Thefuck
**Package:** `thefuck`
**Alias:** `fuck`

**Features:**
- Corrects your previous command
- AI-powered suggestions

**Usage:**
```bash
# Make a typo
git comit

# Correct it
fuck
# Suggests: git commit
```

---

## Media & Graphics

### Screenshots

#### Grim + Slurp
**Packages:** `grim`, `slurp`
**Keybinds:**
- `Super+S` - Region screenshot
- `Super+P` - Fullscreen screenshot
- `Print` - Fullscreen screenshot

**Features:**
- Wayland-native
- Saves to ~/Pictures/Screenshots/
- Auto-copies to clipboard

**Usage:**
```bash
# Region (Super+S)
grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png

# Fullscreen (Super+P)
grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png
```

### Color Picker

#### WL-Color-Picker
**Package:** `wl-color-picker` (AUR)
**Keybind:** `Super+Shift+C`

**Features:**
- Wayland-native color picker
- Click to pick color
- Auto-copies hex to clipboard
- Real-time preview

**Usage:**
```bash
# Launch (Super+Shift+C)
wl-color-picker

# Click any pixel
# Hex code copied to clipboard
```

**Perfect for:** Theming, CSS work, design

### Image Viewer

#### imv
**Package:** `imv`

**Features:**
- Wayland-native
- Lightweight
- Keyboard-driven

**Usage:**
```bash
# View image
imv image.png

# Navigate: arrow keys
# Quit: q
```

### PDF Viewer

#### Zathura
**Package:** `zathura`
**Config:** [~/.config/zathura/](../config/.config/zathura/)

**Features:**
- Vim-like keybinds
- Minimal interface
- Fast

**Usage:**
```bash
# Open PDF
zathura document.pdf

# Navigate: j/k or arrows
# Zoom: +/-
# Quit: q
```

### Video Player

#### MPV
**Package:** `mpv`

**Features:**
- Best Linux video player
- Keyboard shortcuts
- GPU acceleration

**Usage:**
```bash
# Play video
mpv video.mp4

# Space - play/pause
# Arrow keys - seek
# q - quit
```

---

## Configuration

### Dotfiles Management

#### GNU Stow
**Package:** `stow`
**Script:** [scripts/install.sh](../scripts/install.sh)

**How It Works:**
- All configs in `~/Projects/archeotech-dotfiles/config/.config/`
- Stow creates symlinks from `~/.config/` to repo
- Editing `~/.config/file` edits repo file directly
- Changes auto-tracked by git

**Usage:**
```bash
cd ~/Projects/archeotech-dotfiles

# Deploy all configs
stow -R config

# Remove symlinks
stow -D config

# Dry run (see what would happen)
stow -n -R config
```

**Adding New Config:**
1. Create directory: `mkdir -p config/.config/newapp/`
2. Add config files
3. Run: `stow -R config`
4. Symlink created automatically

---

## Quick Reference

### Most Used Commands

```bash
# Terminal
Super+Q        # Open kitty

# Development
Super+G        # Lazygit
Super+E        # VSCode
Ctrl+R         # Shell history (Atuin)

# System
Super+K        # Show keybinds
btop           # System monitor
tldr <cmd>     # Quick help

# Git
lg             # Lazygit (alias)
git status     # Check status

# AWS
assume <prof>  # Switch AWS profile
aws sso login  # Login to SSO

# Utilities
Super+S        # Screenshot region
Super+Shift+C  # Color picker
Super+V        # Clipboard history
gping <host>   # Network test

# Navigation
cd <dir>       # Smart cd (zoxide)
ls             # Better ls (eza)
yazi           # File manager TUI
```

---

## Troubleshooting

### Atuin not working
```bash
# Reload fish config
source ~/.config/fish/config.fish

# Check status
atuin doctor
```

### Lazygit theme wrong
```bash
# Verify Kitty uses Catppuccin
cat ~/.config/kitty/kitty.conf | grep catppuccin

# Check lazygit config
cat ~/.config/lazygit/config.yml
```

### Granted assume fails
```bash
# Check alias
alias | grep assume

# Should show: alias assume='source assume'

# Reload fish
source ~/.config/fish/config.fish
```

### Symlinks broken
```bash
cd ~/Projects/archeotech-dotfiles

# Check symlink status
ls -la ~/.config/kitty
ls -la ~/.config/fish

# Recreate
stow -R config
```

---

## Sources & Documentation

- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
- [Catppuccin Lazygit](https://github.com/catppuccin/lazygit)
- [Atuin](https://github.com/atuinsh/atuin)
- [Granted](https://github.com/common-fate/granted)
- [Navi](https://github.com/denisidoro/navi)
- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs/)

---

**Project:** Arch + MangoWC/Hyprland Dotfiles
**Repo:** ~/Projects/archeotech-dotfiles
