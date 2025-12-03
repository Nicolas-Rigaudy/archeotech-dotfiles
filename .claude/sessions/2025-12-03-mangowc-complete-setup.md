# MangoWC Complete Setup & Waybar Improvements

**Date:** 2025-12-03
**Duration:** ~2 hours
**Status:** ✅ Complete

## Session Overview

Completed a comprehensive setup and improvement of the MangoWC compositor configuration, including fixing audio keybinds, configuring touchpad gestures, improving Waybar styling and organization, and resolving various configuration issues.

## Problems Solved

### 1. Audio Keybinds Not Working in MangoWC ✅
**Problem:** Volume up/down keys and media controls worked in Hyprland but not in MangoWC.

**Root Cause:** MangoWC requires `NONE` as the modifier for XF86 multimedia keys, not empty modifier.

**Solution:**
- Changed all XF86 media key bindings from `bind=,XF86AudioRaiseVolume` to `bind=NONE,XF86AudioRaiseVolume`
- Applied fix to:
  - Volume controls (up/down/mute)
  - Microphone mute
  - Brightness controls
  - Media playback controls (play/pause/next/prev)
  - Print screen key

**Reference:** MangoWC Wiki gesture documentation confirmed `NONE` modifier requirement.

### 2. 2-Finger Scroll Not Working ✅
**Problem:** Two-finger scrolling on trackpad wasn't working at all.

**Root Cause:** Wrong configuration parameter names - MangoWC uses `trackpad_natural_scrolling` not `natural_scrolling`, and `scroll_method` requires numeric values (0-4), not strings like "2fg".

**Solution:**
```conf
# Before (incorrect)
natural_scrolling=1
scroll_method=2fg

# After (correct)
trackpad_natural_scrolling=1
scroll_method=1  # 1 = two-finger scrolling
```

**Scroll method values:**
- 0 = No scrolling
- 1 = Two-finger scrolling ✅
- 2 = Edge scrolling
- 4 = Button scrolling

### 3. Touchpad Gestures Missing ✅
**Problem:** No gesture support configured for trackpad navigation.

**Solution:** Added comprehensive gesture bindings:

**3-finger swipe (window navigation):**
- Left/Right/Up/Down: Navigate between windows with inverted/natural directions

**4-finger swipe (tag switching):**
- Left: Go to next tag (all tags, not just occupied)
- Right: Go to previous tag
- Up/Down: Toggle workspace overview

**Gesture syntax:**
```conf
gesturebind=NONE,left,3,focusdir,right  # Natural direction (inverted)
gesturebind=NONE,left,4,viewtoright     # Switch to all tags
```

### 4. Window Resize Keybinds Not Working ✅
**Problem:** Multiple resize keybind configurations conflicting and not working.

**Root Cause:**
- Using wrong commands (`resizeactive` instead of `resizewin`)
- Using wrong commands (`incmfact` instead of `setmfact`)
- Duplicate keybinds on same keys (Super+Ctrl+Left/Right)

**Solution:**
```conf
# For floating windows
bind=SUPER+CTRL,Left,resizewin,-20,0
bind=SUPER+CTRL,Right,resizewin,20,0
bind=SUPER+CTRL,Up,resizewin,0,-20
bind=SUPER+CTRL,Down,resizewin,0,20
```

Note: User removed conflicting mfact keybinds and the arrow key resizing works in all layouts.

### 5. Waybar Visual Issues ✅
**Problem:**
- Duplicate WiFi and Bluetooth icons (tray applets + Waybar modules)
- Percentages not clear (volume/battery looked identical)
- Modules not visually grouped
- Tags display showing random window titles

**Solution:**

**Removed duplicate tray applets:**
- Removed `nm-applet` and `blueman-applet` from autostart
- Kept Waybar modules which look better and are themed

**Improved module organization:**
```json
"modules-right": [
    "pulseaudio",           // Speaker with volume %
    "pulseaudio#microphone", // Mic with volume % (NEW)
    "network",              // WiFi SSID
    "bluetooth",            // BT device count
    "battery",              // Battery %
    "tray",
    "custom/power"
]
```

**Enhanced visual grouping:**
- Speaker + Mic visually connected (rounded left + rounded right corners)
- Each module has clear icons and labels
- Better tooltips with detailed information
- Color-coded states (battery: green→yellow→red)

**Created separate styling:**
- New `style-mango.css` for MangoWC (won't affect Hyprland)
- Cleaned up `style.css` to remove MangoWC-specific `#tags` styling
- Modern effects: smooth transitions, hover states, animations

### 6. Keybinds Display Script ✅
**Problem:** No easy way to view all keybindings while working.

**Solution:** Created `scripts/show-keybinds.sh`:
- Auto-detects running compositor (Hyprland or MangoWC)
- Displays formatted keybind reference in rofi popup
- Organized into logical sections with icons
- Aligned columns for easy reading
- Bound to `Super+K` in both Hyprland and MangoWC
- 204 lines with full coverage of all keybinds

**Features:**
- Compositor-aware (shows different keybinds for Hyprland vs MangoWC)
- Nerd Font icons for visual sections
- Covers: launchers, window controls, focus/move, workspaces/tags, layouts, gaps, screenshots, audio, mouse
- Clean formatting with proper column alignment

### 7. Vim Keybindings Cleanup ✅
**Problem:** Conflicting vim keybindings (h/j/k/l) causing issues with other commands.

**Solution:**
- Removed all vim-style keybindings from Hyprland config
- Kept only arrow key bindings for consistency
- Updated documentation to reflect arrow keys only
- Freed up Super+H/K/L/J for other uses (Super+K now shows keybinds)

### 8. Hyprland/MangoWC Config Separation ✅
**Problem:** Mixed configs causing confusion between Hyprland and MangoWC.

**Solution:**
- Separate Waybar configs: `config` (Hyprland) vs `config-mango` (MangoWC)
- Separate Waybar styles: `style.css` (Hyprland) vs `style-mango.css` (MangoWC)
- Updated autostart to use correct files: `waybar -c config-mango -s style-mango.css`
- Removed `#tags` styling from Hyprland CSS (only uses `#workspaces`)

## Files Modified

### New Files Created
1. **scripts/show-keybinds.sh** (NEW - 204 lines)
   - Auto-detects running compositor (Hyprland or MangoWC)
   - Displays formatted keybind reference in rofi
   - Separate sections for launchers, windows, tags/workspaces, layouts, etc.
   - Uses Nerd Font icons for visual clarity
   - Aligned columns for readability
   - Bound to Super+K in both compositors

2. **config/.config/waybar/style-mango.css** (NEW - 179 lines)
   - Complete MangoWC-specific Waybar styling
   - Separate from Hyprland to avoid conflicts
   - See detailed description in "Files Modified" section below

3. **docs/KEYBINDS-MANGO.md** (NEW)
   - Complete keybind reference specifically for MangoWC
   - Documents all layouts, gestures, and MangoWC-specific features

4. **.claude/sessions/2025-12-03-mangowc-complete-setup.md** (NEW - this file)
   - Complete session documentation

### Configuration Files
1. **config/.config/mango/config.conf** (222 lines changed)
   - Fixed audio keybinds (NONE modifier)
   - Fixed touchpad config (trackpad_natural_scrolling, scroll_method=1)
   - Added comprehensive gesture bindings (3-finger, 4-finger)
   - Fixed window resize commands (resizewin)
   - Enhanced Catppuccin Macchiato theming
   - Improved blur, shadow, and animation settings

2. **config/.config/mango/autostart.sh**
   - Updated Waybar launch command to use style-mango.css
   - Removed nm-applet and blueman-applet (duplicates)

3. **config/.config/waybar/config-mango** (127 lines changed)
   - Added pulseaudio#microphone module
   - Enhanced format strings with better icons
   - Added window title rewriting (app icons)
   - Improved calendar tooltip with color coding
   - Enhanced tooltips for all modules
   - Better battery state configuration
   - Right-click actions for quick toggling

4. **config/.config/waybar/style-mango.css** (NEW FILE - 179 lines)
   - Complete MangoWC-specific styling
   - Visual grouping for audio modules (connected corners)
   - State-based colors (battery, network, bluetooth)
   - Smooth animations and transitions
   - Hover effects
   - DWL tags dynamic visibility styling

5. **config/.config/waybar/style.css** (cleaned up)
   - Removed all #tags styling (MangoWC-specific)
   - Kept only #workspaces styling (Hyprland-specific)
   - Added header comment clarifying Hyprland-only

6. **config/.config/hypr/hyprland.conf** (23 lines changed)
   - Added Super+K keybind to show keybinds script
   - Removed all vim keybindings (h/j/k/l) to avoid conflicts
   - Kept only arrow key bindings for focus, move, and resize
   - Cleaned up duplicate keybind configurations

7. **config/.config/kitty/kitty.conf** (4 lines changed)
   - Adjusted background_opacity to 0.4 (from 0.85)
   - Note: This stacks with MangoWC's global opacity settings
   - Added comment explaining MangoWC opacity behavior

8. **docs/KEYBINDS.md** (6 lines changed)
   - Removed vim keybinding documentation (h/j/k/l)
   - Added Super+K "Show keybinds" entry
   - Updated last modified date to 2025-12-02
   - Kept only arrow key documentation

## Waybar Improvements Summary

### Before:
```
[1][2]        Window Title        vol_53%  WiFi_SSID  2  bat_87%  ⏻
                                   ^WiFi   ^BT ^Battery (unclear)
```

### After:
```
[1][2]        󰨞 archeotech-dotfiles        🔊 53% 🎤 75%  󰖩 MyWifi  󰂱 2  󰂁 87%  ⏻
                                            ^Speaker ^Mic  ^Network ^BT ^Battery (clear!)
```

### Key Improvements:
1. **Visual Grouping:** Speaker + Mic appear as connected unit
2. **Clear Labels:** Icons + percentages make purpose obvious
3. **Better Tooltips:** Detailed info on hover (device names, time remaining, etc.)
4. **State Colors:** Battery green→yellow→red, network changes on disconnect
5. **Smooth Animations:** Transitions, hover effects, pulsing critical states
6. **No Duplicates:** Single set of controls, no tray applet clutter

## Technical Learnings

### MangoWC-Specific Syntax:
- `NONE` modifier required for XF86 keys (not empty string)
- `trackpad_natural_scrolling` (not `natural_scrolling`)
- `scroll_method=1` (numeric, not "2fg")
- `gesturebind=MODIFIERS,DIRECTION,FINGERS,COMMAND,PARAMS`
- `resizewin` (not `resizeactive`)
- `setmfact` (not `incmfact`)
- `viewtoright`/`viewtoleft` (not `_have_client` for all tags)

### Waybar Module Pairing:
- Use asymmetric border-radius for visual connection:
  ```css
  #pulseaudio { border-radius: 10px 0 0 10px; }
  #pulseaudio.microphone { border-radius: 0 10px 10px 0; }
  ```

### DWL Tags Styling:
- Hide empty tags with `opacity: 0`
- Show occupied/focused with `opacity: 1`
- Smooth transitions with cubic-bezier easing

## Current State

### ✅ Fully Working:
- Audio controls (volume keys, media keys, wheel on external KB)
- 2-finger scroll (natural scrolling)
- 3-finger swipe (window navigation, natural directions)
- 4-finger swipe (tag switching to all tags)
- Window resizing (Super+Ctrl+Arrows, works in all layouts)
- Waybar modules (clean, organized, themed)
- Separate Hyprland/MangoWC configs (no conflicts)

### 🎯 User Workflow Enabled:
- VS Code + YouTube side-by-side in scroller layout
- Resize windows with Super+Ctrl+Arrows
- Navigate with 3-finger swipes
- Switch workspaces with 4-finger swipes
- Control audio from Waybar or keyboard
- Clean visual interface without duplicates

## Recommendations for Future

### Nice-to-Have Additions:
1. **Custom Waybar modules:**
   - Git branch indicator
   - AWS profile indicator
   - VPN status
   - CPU/Memory usage (optional)

2. **Layout presets:**
   - Save/restore window layouts per tag
   - Quick switch between coding/browsing/gaming layouts

3. **Workspace-specific wallpapers:**
   - Different wallpaper per tag
   - Tag-based color schemes

4. **Enhanced gestures:**
   - Pinch to zoom (if supported)
   - Rotate gestures for layout switching

### Documentation to Add:
- Complete keybinds reference for MangoWC (KEYBINDS-MANGO.md exists but untracked)
- MangoWC troubleshooting guide
- Layout switching guide with screenshots
- Gesture cheat sheet

## Commands Used

```bash
# Reload MangoWC config
Super + Shift + R

# Kill and restart Waybar
pkill waybar

# Test audio
wpctl status
wpctl get-volume @DEFAULT_AUDIO_SINK@

# Check touchpad
libinput list-devices

# Git operations
git status
git diff --stat
git add <files>
git commit
```

## Sources Referenced

- [MangoWC GitHub Wiki](https://github.com/DreamMaoMao/mangowc/wiki) - Configuration syntax, gestures, input settings
- [Waybar DWL Module Documentation](https://github.com/Alexays/Waybar/wiki/Module:-Dwl) - Tags configuration
- [Waybar Group Module](https://github.com/Alexays/Waybar/wiki/Module:-Group) - Module grouping
- [Catppuccin Macchiato Colors](https://github.com/catppuccin/catppuccin) - Color palette
- Various Waybar configs from Hyde, Adnan-Malik, end-4 for styling inspiration

## Next Session Ideas

1. Create custom rofi scripts (AWS switcher, Terraform commands)
2. Add VPN status to Waybar
3. Configure workspace-specific rules (VSCode on tag 2, browser on tag 3)
4. Set up multi-monitor hotplug scripts
5. Theme switcher (Mocha ↔ Macchiato)
6. Complete KEYBINDS-MANGO.md documentation
7. Test and document all MangoWC layouts

---

**Session completed successfully.** All major issues resolved, MangoWC fully functional as daily driver alongside Hyprland.
