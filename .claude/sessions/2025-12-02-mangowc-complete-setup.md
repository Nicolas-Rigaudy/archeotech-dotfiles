# Session Summary: MangoWC Complete Setup

**Date:** 2025-12-02
**Duration:** ~2 hours
**Goal:** Bring MangoWC to feature parity with Hyprland by adding critical missing components (lock screen, idle management, waybar compatibility, fixed keybindings)

---

## What Was Done

### Major Changes
- Installed and configured swaylock with official Catppuccin Macchiato theme
- Installed and configured swayidle for idle management (dim, lock, screen off)
- Created MangoWC-compatible waybar configuration with dwl modules
- Fixed all window management keybindings (focus, move, monitor switching)
- Added dynamic waybar tag visibility (empty tags hidden, only show occupied/focused)
- Updated autostart script with all critical services
- Updated install.sh to include swaylock and swayidle

### Files Modified
```
config/.config/swaylock/config              # New - lock screen config
config/.config/swayidle/config.sh           # New - idle management script
config/.config/waybar/config-mango          # New - MangoWC waybar config
config/.config/waybar/style.css             # Modified - added dynamic tag styles
config/.config/mango/autostart.sh           # Modified - added swayidle and waybar-mango
config/.config/mango/config.conf            # Modified - fixed keybindings
scripts/install.sh                          # Modified - added swaylock/swayidle
```

### Packages Installed
```bash
wlopm  # Purpose: display power management for Wayland (via paru)
```

### Packages Already Installed
```bash
swaylock-effects  # Lock screen for Wayland compositors
swayidle          # Idle management daemon
```

---

## Issues Encountered

### Issue 1: Lock screen had no password set - got locked out
**Symptoms:** Pressing Super+L locked screen but couldn't unlock, had to hard reboot
**Cause:** MangoWC config called swaylock but it wasn't installed/configured
**Solution:** Installed swaylock-effects and configured with official Catppuccin theme
**Prevention:** Always test lock screen before binding it to a keybind

### Issue 2: Swaylock date text overlapping with indicator circle
**Symptoms:** First and last letters of date text cut off by circle edge
**Cause:** Default font size and indicator radius didn't leave enough space
**Solution:** Set font-size=24 and increased indicator-radius to 140
**Prevention:** Test lock screen visually before finalizing config

### Issue 3: Window focus and move keybindings not working
**Symptoms:** Super+Arrow and Super+Shift+Arrow did nothing
**Cause:** Wrong action names - used `focusdir,l` instead of `focusdir,left` and `movewindow` instead of `exchange_client`
**Solution:** Changed to correct MangoWC actions: `focusdir,left/right/up/down` and `exchange_client`
**Prevention:** Always check official config.conf examples for correct action names

### Issue 4: Waybar showing river/tags but crashing
**Symptoms:** Waybar wouldn't load, no tags or window titles visible
**Cause:** Used river/* modules but MangoWC is based on dwl, not river
**Solution:** Changed to dwl/tags and dwl/window modules
**Prevention:** Check compositor's wiki for correct waybar module types

### Issue 5: Waybar crashing with assertion error about button vector size
**Symptoms:** Waybar crashed with "Assertion '__n < this->size()' failed"
**Cause:** Waybar num-tags (4) didn't match MangoWC's actual tag count (9)
**Solution:** Set waybar num-tags to 9 to match MangoWC's hardcoded value
**Prevention:** Always match waybar tag count to compositor's tag count

---

## Decisions Made

### Decision 1: Use swaylock instead of hyprlock
**Options Considered:**
- Option A: Port hyprlock config somehow (not compatible with non-Hyprland)
- Option B: Use swaylock-effects (standard Wayland lock screen)

**Chosen:** Option B - swaylock-effects
**Rationale:** Swaylock is compositor-agnostic, works with any wlroots-based compositor, has official Catppuccin theme, and widely supported

### Decision 2: Use wlopm for display power management
**Options Considered:**
- Option A: Use hyprctl dispatch dpms (Hyprland-specific)
- Option B: Use wlopm (generic Wayland output power management)

**Chosen:** Option B - wlopm
**Rationale:** Generic tool that works with all wlroots compositors, MangoWC doesn't have built-in power management commands

### Decision 3: Create separate waybar config instead of making one universal
**Options Considered:**
- Option A: Try to make one config work for both Hyprland and MangoWC
- Option B: Create separate configs (config for Hyprland, config-mango for MangoWC)

**Chosen:** Option B - separate configs
**Rationale:** Different modules needed (hyprland/* vs dwl/*), cleaner separation, easier to maintain, no conditional logic needed

### Decision 4: Hide empty waybar tags completely instead of showing dimmed
**Options Considered:**
- Option A: Show all 9 tags dimmed when empty
- Option B: Hide empty tags completely with opacity:0 and visibility:hidden

**Chosen:** Option B - completely hidden
**Rationale:** Cleaner UI, less visual clutter, tags appear dynamically as needed, user preference for minimal interface

### Decision 5: Keep 9 tags configured instead of reducing to 4
**Options Considered:**
- Option A: Reduce MangoWC to 4 tags (remove keybindings for 5-9)
- Option B: Keep 9 tags but hide empty ones in waybar

**Chosen:** Option B - 9 tags with dynamic visibility
**Rationale:** More flexibility, can use more workspaces if needed, MangoWC's tag count is hardcoded at 9, waybar hides unused ones anyway

---

## Testing & Verification

### What Was Tested
- ✅ Swaylock with password authentication (Super+L)
- ✅ Swaylock visual appearance (clock, date, indicator positioning)
- ✅ Swayidle idle detection and screen dimming
- ✅ Window focus movement (Super+Arrow and Super+H/J/K)
- ✅ Window position swapping (Super+Shift+Arrow and Super+Shift+H/J/K)
- ✅ Moving windows between monitors (Super+Alt+Shift+Arrow)
- ✅ Waybar tags displaying dynamically (empty tags hidden)
- ✅ Waybar modules (network, bluetooth, battery, audio, clock)
- ✅ All 9 tags accessible via Super+1-9
- ✅ Moving windows to tags via Super+Shift+1-9

### Known Issues / TODO
- [ ] Test idle timeout actually locking after 10 minutes (long test)
- [ ] Test display power off after 15 minutes (long test)
- [ ] Test swaylock keyboard layout indicator accuracy
- [ ] Verify waybar dwl/window module shows correct window titles
- [ ] Test all layouts (scroller, tile, grid, monocle, etc.) extensively
- [ ] Consider adding custom waybar modules (git branch, AWS profile, etc.)

---

## Next Session Goals

### High Priority
1. Test MangoWC as daily driver for a few days
2. Evaluate scrolling layout vs Hyprland's dwindle
3. Decide which compositor to keep long-term (Hyprland or MangoWC)

### Medium Priority
1. Build custom rofi scripts (AWS profile switcher, Terraform commands, SSH quick connect)
2. Add custom waybar modules (git branch indicator, AWS profile, VPN status)
3. Implement advanced window rules (auto-workspace assignments)
4. Create theme switcher system (Macchiato ↔ Mocha)

### Questions / Blockers
- None - MangoWC is fully functional and ready for daily use

---

## Notes & Observations

- MangoWC's scrolling layout is the main feature that motivated this setup
- MangoWC uses dwm-style tags instead of Hyprland's discrete workspaces
- Tags in MangoWC are more flexible (windows can have multiple tags)
- MangoWC is lighter weight than Hyprland but has fewer features
- The dwl/tags waybar module works well once properly configured
- CSS visibility:hidden is better than display:none for waybar tags (avoids layout shifts)
- MangoWC's action names differ significantly from Hyprland (focusdir vs movefocus, exchange_client vs movewindow)
- Official Catppuccin themes exist for most lock screens, always check first

---

## Commands Reference

Useful commands discovered or used this session:

```bash
# Reload MangoWC config
mmsg -d reload_config

# Launch waybar with specific config
waybar -c ~/.config/waybar/config-mango &

# Test swaylock
swaylock

# Kill and restart waybar
pkill waybar && waybar -c ~/.config/waybar/config-mango &

# Check swaylock version
swaylock --version

# Install from AUR with paru
paru -S wlopm

# Make script executable
chmod +x ~/.config/swayidle/config.sh
```

---

## Time Breakdown

- Planning/Research: 15 mins
- Implementation: 60 mins
- Testing: 20 mins
- Documentation: 10 mins
- Troubleshooting: 35 mins

**Total:** ~2 hours

---

## Links & References

- [Catppuccin swaylock official theme](https://github.com/catppuccin/swaylock)
- [MangoWC GitHub repository](https://github.com/DreamMaoMao/mangowc)
- [MangoWC Wiki](https://github.com/DreamMaoMao/mangowc/wiki)
- [Waybar dwl module documentation](https://github.com/Alexays/Waybar/wiki/Module:-Dwl)
- [Waybar issue #4344 - dwl/tags crash bug](https://github.com/Alexays/Waybar/issues/4344)
- [MangoWC Installation Guide](https://www.tonybtw.com/tutorial/mangowc/)

---

**Status:** ✅ Complete and Fully Functional
**MangoWC Ready for Daily Use:** Yes
**Hyprland Status:** Untouched and still functional
**Next Session Goal:** Use MangoWC for a few days and evaluate vs Hyprland
