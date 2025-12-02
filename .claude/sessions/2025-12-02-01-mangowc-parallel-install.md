# Session Summary: MangoWC Parallel Installation

**Date:** 2025-12-02
**Duration:** ~2 hours
**Goal:** Install MangoWC compositor alongside Hyprland for testing scrolling layout feature

---

## Objectives

- ✅ Install MangoWC in parallel with Hyprland (no breaking changes)
- ✅ Port complete Hyprland configuration to MangoWC
- ✅ Configure scrolling layout (the main feature goal)
- ✅ Fix keyboard layout switching (US/FR)
- ✅ Configure multi-monitor setup (3 monitors including portrait)
- ✅ Document stow workflow in claude.md

---

## What Was Accomplished

### 1. MangoWC Installation & Parallel Setup

**Installed MangoWC compositor:**
- Installed `mangowc-git` from AUR
- Both Hyprland and MangoWC coexist as separate SDDM sessions
- Can switch between compositors at login screen
- Hyprland remains untouched as stable daily driver

**Created config structure:**
```
config/.config/mango/
├── config.conf     # Main MangoWC configuration
└── autostart.sh    # Autostart script for apps
```

### 2. Configuration Migration

**Ported from Hyprland to MangoWC:**
- All keybindings (~50+ bindings)
- Monitor configuration (3 monitors: laptop + 2 external, one portrait)
- Window rules (floating, opacity, sizing)
- Animations and visual effects
- Catppuccin Macchiato theming
- Gap settings
- Autostart programs

### 3. Major Configuration Fixes

**Fixed inline comments issue:**
- MangoWC doesn't support inline comments (e.g., `bind=... # comment`)
- Moved ALL comments above their respective lines
- This was causing keybindings to fail (trying to execute `kitty # Terminal`)

**Fixed complex shell commands:**
- Used `spawn_shell` for commands with pipes and command substitution
- Screenshots: `spawn_shell,grim -g "$(slurp)" ...`
- Clipboard: `spawn_shell,cliphist list | rofi ...`

**Fixed Space keybinds:**
- Changed `Space` to lowercase `space` (case-sensitive)
- Fixed: Super+Space, Super+Shift+Space, Super+Alt+Space

### 4. Keyboard Layout Configuration

**Configured US/FR layout switching:**
```conf
xkb_rules_layout=fr,us
xkb_rules_variant=,
xkb_rules_options=grp:alt_shift_toggle
```

**Implemented layout-aware keybindings:**
- Used `binds` (keysym-based) for letter keys → layout follows keyboard
- Used `bind` (keycode-based) for number keys → position-based
- Result: Super+Q always opens terminal (Q key) regardless of US/FR layout
- Result: Super+1-9 uses physical key position (works on both layouts)

### 5. Multi-Monitor Configuration

**Converted to MangoWC `monitorrule` syntax:**
```conf
# Format: name,mfact,nmaster,layout,transform,scale,x,y,width,height,refreshrate
monitorrule=eDP-1,0.55,1,scroller,0,1,0,0,1920,1200,60
monitorrule=HDMI-A-1,0.55,1,scroller,0,1,1920,0,1920,1080,60
monitorrule=DP-3,0.55,1,scroller,3,1,3840,0,1080,1920,60
```

**Key differences from Hyprland:**
- Different syntax entirely (`monitorrule` vs `monitor`)
- Transform values different (3 = 270° rotation for portrait)
- Includes layout per monitor in the config

### 6. Layout System Configuration

**Configured multiple layouts:**
- **Scroller** (default) - Horizontal scrolling windows (like Niri!)
- **Tile** - Master-stack layout (like Hyprland's master)
- **Grid** - Auto-tiling (closest to Hyprland's dwindle)
- **Monocle** - Single fullscreen window
- **Deck** - Master + stacked windows
- **Vertical Scroller** - Vertical scrolling
- **Spiral** - Spiral tiling pattern

**Layout switching keybinds:**
- Super+Space → Scroller (the feature we wanted!)
- Super+Alt+Space → Tile (master-stack)
- Super+Alt+G → Grid (dwindle-like)
- Super+Alt+M → Monocle
- Super+Alt+D → Deck
- Super+Alt+V → Vertical Scroller
- Super+Alt+S → Spiral

### 7. Stow Workflow Documentation

**Updated claude.md with GNU Stow workflow:**
- Explained how stow works (symlinks from ~/.config to repo)
- Documented directory structure
- Added instructions for adding new config directories
- Clarified that configs live ONLY in the repo
- Explained daily workflow (edit symlinked file → automatically in git)

**Updated install.sh:**
- Added `mango` to CONFIGS array (for backup)
- Added `mango` to CRITICAL_CONFIGS array (for verification)

---

## Key Decisions Made

### 1. Parallel Installation Strategy
**Decision:** Install MangoWC alongside Hyprland, not as replacement

**Rationale:**
- Keep Hyprland stable as daily driver
- Test MangoWC without breaking working setup
- Easy rollback (just choose Hyprland at login)
- Can compare both compositors before deciding

### 2. Layout-Aware Keybindings Strategy
**Decision:** Use `binds` for letters, `bind` for numbers

**Rationale:**
- Letter keys need to follow keyboard layout (Q should be Q, not A)
- Number keys work better with physical position (1 is always 1)
- No need for AZERTY-specific number bindings
- Simpler and more maintainable than dual bindings

### 3. Comment Placement Strategy
**Decision:** Move all inline comments above their lines

**Rationale:**
- MangoWC doesn't support inline comments
- Inline comments were being parsed as part of commands
- Keeping comments above preserves documentation
- Consistent with many config file standards

---

## Technical Details

### MangoWC vs Hyprland Key Differences

| Feature | Hyprland | MangoWC |
|---------|----------|---------|
| **Config syntax** | `bind = MOD, key, action, args` | `bind=MOD,key,action,args` |
| **Monitor config** | `monitor=name,res@hz,pos,scale` | `monitorrule=name,mfact,nmaster,layout,transform,scale,x,y,w,h,hz` |
| **Workspaces** | Discrete workspaces (1-9) | Tags (like dwm, windows can have multiple) |
| **Layout switching** | Dwindle/Master built-in | Multiple layouts via `setlayout` |
| **Inline comments** | Supported | NOT supported |
| **Complex commands** | `exec` handles everything | Need `spawn_shell` for pipes/substitution |
| **Keybind flags** | N/A | `binds` (keysym), `bindl` (lock), etc. |

### Keybinding Types in MangoWC

- `bind` - Standard keybind using keycode (layout-independent)
- `binds` - Uses keysym instead of keycode (layout-aware)
- `bindl` - Still applies when screen locked
- `bindls` - Keysym-based + works when locked

---

## Testing Performed

### Verification Steps

1. ✅ MangoWC launches from SDDM
2. ✅ Keyboard layout switches with Alt+Shift (US ↔ FR)
3. ✅ All letter keybindings work (Super+Q, M, L, etc.)
4. ✅ Number keybindings work (Super+1-9 for tags)
5. ✅ Space keybindings work (Super+Space for scroller)
6. ✅ Multi-monitor setup works (3 screens, no mirroring)
7. ✅ Portrait monitor rotated correctly (DP-3)
8. ✅ Layout switching works (scroller, tile, grid, etc.)
9. ✅ Window management works (focus, move, resize)
10. ✅ Media keys work (volume, brightness, play/pause)

### Issues Encountered & Fixed

1. **Terminal not launching** → Inline comments breaking spawn commands
2. **Keyboard stuck on US** → Missing xkb_rules_layout config
3. **Super+M locking instead of quitting** → Changed to `binds` for layout-awareness
4. **Space keybinds not working** → Changed `Space` to lowercase `space`
5. **Multi-monitor mirroring** → Wrong syntax, changed to `monitorrule`
6. **Stow not picking up mango/** → Manually created symlink, updated install.sh

---

## Files Changed

**New Files:**
- `config/.config/mango/config.conf` - Complete MangoWC configuration
- `config/.config/mango/autostart.sh` - Autostart script
- `.claude/sessions/2025-12-02-mangowc-parallel-install.md` - This file

**Modified Files:**
- `scripts/install.sh` - Added mango to CONFIGS and CRITICAL_CONFIGS arrays
- `.claude/claude.md` - Added GNU Stow workflow documentation section

**Symlinks Created:**
- `~/.config/mango` → `../Projects/archeotech-dotfiles/config/.config/mango`

---

## Current Status

### What's Working

- ✅ MangoWC fully functional as secondary compositor
- ✅ Scroller layout working (horizontal scrolling windows!)
- ✅ All keybindings working correctly
- ✅ Keyboard layout switching (US/FR with Alt+Shift)
- ✅ Multi-monitor setup (3 screens including portrait)
- ✅ Layout-aware keybindings (letters follow layout)
- ✅ Animations, blur, shadows, theming applied
- ✅ Autostart programs configured
- ✅ Proper stow workflow documented

### What's Not Done (Low Priority)

- [ ] Swaylock configuration (lock screen replacement)
- [ ] Swayidle configuration (idle management)
- [ ] Waybar config for MangoWC compatibility (uses hyprland/* modules)
- [ ] Test dock/undock behavior
- [ ] Test all layouts extensively

---

## Next Steps

### Immediate
1. Test MangoWC for a few days as daily driver
2. Compare scrolling layout vs Hyprland's dwindle
3. Decide which compositor to keep long-term

### If Keeping MangoWC
1. Install and configure swaylock (replace hyprlock)
2. Install and configure swayidle (replace hypridle)
3. Create MangoWC-compatible waybar config
4. Fine-tune layouts and workflows
5. Update documentation (KEYBINDS.md)

### If Keeping Hyprland
1. Remove MangoWC config (or keep for reference)
2. Continue with original dotfiles roadmap
3. Consider other scrolling alternatives (river, niri)

---

## Lessons Learned

1. **Inline comments matter:** MangoWC doesn't support them, easy to miss
2. **Case sensitivity:** `space` vs `Space` caused silent failures
3. **Keysym vs keycode:** Important for multi-layout keyboards
4. **Monitor syntax varies:** Each compositor has different config format
5. **Stow works great:** Adding new configs to stow workflow is straightforward
6. **Documentation crucial:** GNU Stow workflow needs clear documentation
7. **Parallel install smart:** Testing without breaking working setup is valuable

---

## Commands Reference

### Switch Compositors

```bash
# At SDDM login screen
# Click session selector → Choose "Hyprland" or "MangoWC"
```

### Reload MangoWC Config

```bash
# Inside MangoWC
Super+Shift+R

# Or from terminal
mmsg -d reload_config
```

### Check Monitor Setup

```bash
# List connected monitors
wlr-randr
```

### Test Layouts

```bash
# Scroller layout
Super+Space

# Tile layout (master-stack)
Super+Alt+Space

# Grid layout (dwindle-like)
Super+Alt+G
```

---

## Resources Used

- [MangoWC GitHub](https://github.com/DreamMaoMao/mangowc)
- [MangoWC Wiki](https://github.com/DreamMaoMao/mangowc/wiki)
- [MangoWC config.conf Example](https://github.com/DreamMaoMao/mangowc/blob/main/config.conf)
- Previous session: `.claude/sessions/2025-12-01-dotfiles-stow-setup.md`

---

## Session Notes

- User wanted to try MangoWC for scrolling layout feature
- Initially confused about config syntax (thought it was C headers like dwl)
- Discovered inline comment issue after terminal keybind failed
- Fixed keyboard layout awareness with binds/bind distinction
- Multi-monitor config required complete syntax change
- Successfully got scrolling layout working (main goal!)
- Properly documented stow workflow for future sessions

---

**Status:** ✅ Complete and Functional
**MangoWC Ready:** Yes
**Hyprland Untouched:** Yes
**Next Session Goal:** Test MangoWC for a few days, decide which compositor to keep
