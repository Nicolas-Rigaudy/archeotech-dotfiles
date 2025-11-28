# Technical Decisions Log

This document tracks all technical decisions made during the project, with rationale and alternatives considered.

**Purpose:** Maintain a clear record of why things are done a certain way, to inform future decisions and help others understand the system.

---

## Decision Format

```markdown
## [YYYY-MM-DD] Decision Title

**Context:** What situation required a decision

**Options Considered:**
1. Option A
   - Pros: ...
   - Cons: ...
2. Option B
   - Pros: ...
   - Cons: ...

**Decision:** Chose Option X

**Rationale:** Why this was chosen

**Trade-offs Accepted:** What we're giving up

**Review Date:** When to reconsider (if applicable)
```

---

## Decisions

### [2025-11-28] Filesystem: btrfs vs ext4

**Context:** Need to choose filesystem for Arch partition during installation.

**Options Considered:**
1. **ext4**
   - Pros: Stable, well-tested, slightly faster
   - Cons: No snapshots, no transparent compression
2. **btrfs**
   - Pros: Snapshots, compression, familiar from Fedora
   - Cons: Slightly more complex, rare corruption issues

**Decision:** btrfs with subvolumes (@, @home, @snapshots, @cache, @log)

**Rationale:**
- Snapshots provide safety net for system changes
- Already familiar with btrfs from Fedora
- Compression saves disk space
- Separate subvolumes allow selective backups

**Trade-offs Accepted:** Slightly more complexity in initial setup

---

### [2025-11-28] Bootloader: GRUB vs systemd-boot

**Context:** Need bootloader for dual-boot with Fedora.

**Options Considered:**
1. **systemd-boot**
   - Pros: Simpler, faster, native to systemd
   - Cons: More manual dual-boot setup, less themeable
2. **GRUB**
   - Pros: Auto-detects other OSes, highly configurable, themeable
   - Cons: More complex, occasional issues

**Decision:** GRUB

**Rationale:**
- Need dual-boot with Fedora (GRUB auto-detects it)
- Can apply Catppuccin theme
- More documentation available
- Familiar from previous Linux experience

**Trade-offs Accepted:** Slightly slower boot, more complexity

---

### [2025-11-28] AUR Helper: paru vs yay

**Context:** Need AUR helper for installing packages from Arch User Repository.

**Options Considered:**
1. **yay**
   - Pros: More mature, widely used
   - Cons: Written in Go, slower
2. **paru**
   - Pros: Rust-based (faster), more features, better UI
   - Cons: Less mature, fewer users

**Decision:** paru

**Rationale:**
- Performance advantage (Rust)
- Better interactive review of PKGBUILDs
- Modern codebase, actively developed
- More colorful/informative output

**Trade-offs Accepted:** Smaller community, newer tool

---

### [2025-11-28] Window Manager: Hyprland

**Context:** Main choice for this project - no alternatives seriously considered.

**Decision:** Hyprland

**Rationale:**
- Modern Wayland compositor
- Smooth animations and blur effects
- Tiling window manager (productivity)
- Active development and community
- Great documentation
- The whole point of this project!

**Trade-offs Accepted:**
- Wayland compatibility issues with some apps
- Bleeding edge (occasional bugs)
- Requires learning new workflow

---

### [2025-11-28] Display Manager: SDDM vs LightDM vs GDM

**Context:** Need graphical login screen.

**Options Considered:**
1. **LightDM**
   - Pros: Lightweight, many themes
   - Cons: Less modern, X11-focused
2. **GDM**
   - Pros: GNOME standard, polished
   - Cons: Heavy, GNOME-centric
3. **SDDM**
   - Pros: Qt-based, works well with Wayland, Catppuccin themes
   - Cons: Fewer themes than LightDM

**Decision:** SDDM

**Rationale:**
- Best Wayland support
- Catppuccin themes available
- Lightweight enough
- Good configuration options

**Trade-offs Accepted:** Fewer themes, Qt dependency

---

### [2025-11-28] Status Bar: Waybar vs AGS vs Quickshell

**Context:** Need status bar for Hyprland.

**Options Considered:**
1. **Waybar**
   - Pros: Most popular, huge community, CSS styling
   - Cons: Limited to JSON config, less dynamic
2. **AGS (Aylur's GTK Shell)**
   - Pros: JavaScript config, very flexible
   - Cons: Steep learning curve, complex
3. **Quickshell**
   - Pros: QML-based, modern, flexible
   - Cons: Very new, small community

**Decision:** Waybar (with option to try Quickshell later)

**Rationale:**
- Huge community means lots of examples
- CSS styling is familiar
- JSON config is simple to understand
- Can switch to Quickshell once comfortable with basics

**Trade-offs Accepted:** Less flexibility than AGS/Quickshell

---

### [2025-11-28] App Launcher: rofi vs wofi vs fuzzel

**Context:** Need application launcher.

**Options Considered:**
1. **wofi**
   - Pros: Native Wayland, simple
   - Cons: Limited features, less themeable
2. **fuzzel**
   - Pros: Fast, minimal
   - Cons: Very basic, no plugins
3. **rofi-wayland**
   - Pros: Most features, extensible, many themes
   - Cons: Port of X11 app (not native Wayland)

**Decision:** rofi-wayland

**Rationale:**
- Can extend with custom modi (AWS, SSH, Terraform menus)
- Huge theme collection
- Can integrate clipboard history, calculator, etc.
- Most powerful option

**Trade-offs Accepted:** Not native Wayland (but works well)

---

### [2025-11-28] Terminal: kitty vs alacritty vs wezterm

**Context:** Need GPU-accelerated terminal emulator.

**Options Considered:**
1. **alacritty**
   - Pros: Very fast, minimal
   - Cons: Limited features, TOML config
2. **wezterm**
   - Pros: Lua config, very flexible
   - Cons: Complex, more resource intensive
3. **kitty**
   - Pros: Fast, image support, extensive features
   - Cons: Python-based (but still fast)

**Decision:** kitty

**Rationale:**
- Already using it and familiar
- Image support (needed for yazi file manager)
- Good balance of speed and features
- Excellent documentation

**Trade-offs Accepted:** Not the absolute fastest (but fast enough)

---

### [2025-11-28] Shell: fish vs zsh vs bash

**Context:** Need shell for terminal.

**Options Considered:**
1. **bash**
   - Pros: Universal, default everywhere
   - Cons: Less user-friendly, requires more config
2. **zsh**
   - Pros: Very customizable, Oh My Zsh
   - Cons: Requires configuration, complex
3. **fish**
   - Pros: Friendly, great defaults, syntax highlighting
   - Cons: Not POSIX-compliant, different syntax

**Decision:** fish

**Rationale:**
- Already using it and familiar
- Great out-of-box experience
- Excellent autosuggestions
- Good syntax highlighting
- Staying consistent with previous setup

**Trade-offs Accepted:** Non-POSIX syntax (some scripts need bash)

---

### [2025-11-28] File Manager (GUI): thunar vs nautilus vs dolphin

**Context:** Need lightweight GUI file manager.

**Options Considered:**
1. **nautilus**
   - Pros: GNOME standard, simple
   - Cons: GNOME dependencies, limited features
2. **dolphin**
   - Pros: Feature-rich, powerful
   - Cons: Heavy (KDE dependencies)
3. **thunar**
   - Pros: Lightweight, customizable, plugin system
   - Cons: Less polished than Dolphin

**Decision:** thunar

**Rationale:**
- 90% of Dolphin's features at 30% of weight
- No heavy KDE dependencies
- Good plugin ecosystem
- Integrates well with XFCE/GTK apps

**Trade-offs Accepted:** Less features than Dolphin (but enough for needs)

---

### [2025-11-28] File Manager (TUI): yazi vs ranger vs nnn

**Context:** Need terminal file manager.

**Options Considered:**
1. **ranger**
   - Pros: Mature, vim-like, many features
   - Cons: Python-based (slower), dated
2. **nnn**
   - Pros: Very fast, minimal
   - Cons: Less intuitive, steeper learning curve
3. **yazi**
   - Pros: Modern (Rust), fast, beautiful, image preview
   - Cons: Newer (less mature)

**Decision:** yazi

**Rationale:**
- Modern and actively developed
- Beautiful UI with image preview
- Fast (Rust-based)
- Intuitive keybindings
- Integrates well with kitty (image support)

**Trade-offs Accepted:** Newer tool, smaller community

---

### [2025-11-28] Theme: Catppuccin Macchiato vs Mocha

**Context:** Which Catppuccin flavor to use as primary theme.

**Options Considered:**
1. **Mocha** (darker, cooler)
   - Pros: Popular choice, very dark
   - Cons: Can feel too dark/cold
2. **Macchiato** (darker, warmer)
   - Pros: Warmer tones, good contrast
   - Cons: Less common than Mocha
3. **Frappe** (medium dark, cooler)
   - Pros: Good balance
   - Cons: Less distinct identity
4. **Latte** (light theme)
   - Pros: Good for daytime use
   - Cons: Not preferred for primary

**Decision:** Catppuccin Macchiato with Mauve accent

**Rationale:**
- Warmer tones easier on eyes for long work sessions
- Good contrast while not being extreme
- Mauve accent color is distinctive
- Can add Mocha as alternate theme later

**Trade-offs Accepted:** Less common, fewer examples online

---

### [2025-11-28] Keybind Philosophy: Layout-aware vs Position-based

**Context:** How should keybinds work with AZERTY/QWERTY switching.

**Options Considered:**
1. **Position-based (default)**
   - Pros: Consistent muscle memory across layouts
   - Cons: Keys labeled differently than what they do
2. **Layout-aware (resolve_binds_by_sym)**
   - Pros: Logical (Q key does Q action)
   - Cons: Different positions in each layout

**Decision:** Layout-aware (resolve_binds_by_sym = true)

**Rationale:**
- More intuitive (Q key opens terminal on Q key)
- Switching between AZERTY/QWERTY frequently
- Can relearn muscle memory if needed
- Easier to remember "Super+Q = terminal" than positions

**Trade-offs Accepted:** Need to relearn positions when switching layouts

---

### [2025-11-28] Dual Boot Strategy: Keep Windows Recovery vs Delete

**Context:** Initial plan had Windows recovery partitions to keep.

**Decision:** Delete Windows recovery partitions (chose more space for Arch)

**Rationale:**
- Can recover Windows via:
  - HP Cloud Recovery Tool (downloadable)
  - Fresh Windows install from Microsoft ISO
  - Company IT department (work laptop)
- Extra 33GB valuable for Arch development
- Recovery partitions rarely needed

**Trade-offs Accepted:** No on-disk Windows recovery (but alternatives exist)

---

## Decision Review Schedule

Some decisions should be periodically reviewed:

- **Waybar vs Quickshell:** Review after 3 months once comfortable
- **Theme choice:** Can add alternate themes anytime
- **File managers:** Working well, no review needed
- **Keybind philosophy:** Review if causing issues (none so far)

---

## How to Use This Document

**When making a new decision:**
1. Copy the decision template
2. List all options seriously considered
3. Document why the choice was made
4. Note what you're giving up
5. Add review date if temporary/experimental

**When reviewing old decisions:**
- Check if circumstances have changed
- Evaluate if chosen option still makes sense
- Update or create new decision entry if changing

**When someone asks "why did we...":**
- Point them to this document
- Rationale should be self-explanatory
- If not clear, update the entry

---

**Last Updated:** 2025-11-28
**Total Decisions:** 14
