# Design Decisions & Sprint Plan

Quickshell QML shell — Arch Linux / MangoWC — Catppuccin Macchiato  
Last updated: 2026-05-05

---

## Section 1: Design Principles

1. **Everything animates.** No instant state changes. Every visibility toggle, color change, and panel transition uses a defined animation token from Section 3. No exceptions without a documented reason.

2. **Popups connect to their trigger.** A popup drops down from the exact bar element that triggered it — anchored to the icon's x-position, slides down from the bar's bottom edge. No floating dialogs that appear from nowhere.

3. **Catppuccin Macchiato is the law.** All colors come from the palette. No hardcoded hex values outside the theme token file. Accent color for interactive/active states: mauve (`#c6a0f6`). Future theme switching will swap the token file, not individual components.

4. **One action per surface.** The bar is for glanceable status. The control center is for adjustment. The notification center is for history. Avoid duplicating controls across surfaces — if volume is in CC, the bar icon scrolls and mutes only.

5. **Density is a dial, not a default.** Dense information is acceptable in the bar. Panels (CC, notification center) use breathing room. Rarely-used controls (idle config, night light, display layout) collapse by default — expanded on click.

6. **Native QML first.** No third-party apps embedded where a native QML component is feasible within a sprint. External tools (e.g., `bluetoothctl`, `pactl`) are wrapped via Quickshell process/service interfaces, not launched as visible windows.

7. **Compositor features are compositor features.** MangoWC overview, window snapping, and tiling are not replicated in shell code. The shell augments, never fights, the compositor.

---

## Section 2: Component Inventory

| Component | Status | Priority | Notes |
|---|---|---|---|
| Bar — pill container | Done | — | Pill shape, correct positioning |
| Bar — workspace/tag dots | Partial | High | Active dot needs mauve color; dot size change only, no glow |
| Bar — window title | Done | — | Functional |
| Bar — MPRIS marquee | Done | — | Scrolling title |
| Bar — clock | Done | — | Fixed 1s interval |
| Bar — status icons | Done | — | Always visible; no hide-on-idle |
| Bar — auto-hide toggle | Missing | Low | Config flag, future sprint |
| Bar — position config (top/bottom/left/right) | Missing | Low | Config flag, future sprint |
| OSD — volume overlay | Done | — | Shown on scroll/key |
| OSD — brightness overlay | Done | — | Shown on key |
| Volume popup (bar icon) | Partial | High | Scroll = change, click = mute; no slider popup needed |
| Brightness popup (bar icon) | Partial | High | Same pattern as volume |
| Control Center | Partial | High | Transparent backdrop; scroll/slider fix landed; collapsibles needed |
| CC — media section | Done | — | |
| CC — quick toggles (wifi/bt/dnd/nightlight) | Partial | High | BT still delegates to external app |
| CC — audio/brightness sliders | Partial | High | Slider fix needed in CC context |
| CC — power profile | Missing | Medium | Common in reference repos |
| CC — display layout section | Done | Low | Candidate for collapsible — rarely used |
| CC — idle config section | Done | Low | Candidate for collapsible — rarely used |
| Notification toasts | Missing | High | Stack, top-right, click to dismiss |
| Notification center panel | Missing | High | Separate full-height right panel, bell icon in bar, not part of CC |
| Launcher | Missing | High | Native QML, fuzzy app search |
| Bluetooth native integration | Missing | Medium | `bluetoothctl` via Quickshell service |
| Lock screen | Missing | Medium | WlSessionLock + PamContext |
| SDDM theme | Missing | Low | Separate from shell, lower priority |
| GRUB theme | Missing | Low | Separate from shell, lowest priority |
| Theme switcher | Missing | Low | Catppuccin variants; groundwork for custom palettes |

---

## Section 3: Animation System

All durations and easings are defined as shared tokens. No component hardcodes a raw duration.

| Token | Duration | Easing | Use cases |
|---|---|---|---|
| `Anim.fast` | 100ms | OutCubic | Hover color changes, icon tint, dot color |
| `Anim.base` | 200ms | OutCubic | Most transitions — opacity, small position shifts |
| `Anim.slow` | 300ms | OutQuart | Panel slides (CC open/close), OSD appear |
| `Anim.spring` | 400ms | OutBack overshoot 1.2 | Tag dot size change, pop-in effects |
| `Anim.entrance` | 200ms | OutCubic | scale `0.92 → 1.0` + opacity `0 → 1`, simultaneous |
| `Anim.exit` | 150ms | OutCubic | opacity `1 → 0` only — no scale on exit, intentionally faster |

### Rules

- Panels (CC, notification center, launcher) use `Anim.slow` for the slide and `Anim.entrance`/`Anim.exit` for inner content.
- Toasts use `Anim.entrance` on appear, `Anim.exit` on dismiss.
- Tag dots use `Anim.spring` for size, `Anim.fast` for color.
- OSD uses `Anim.slow` for appear, `Anim.exit` for fade out (auto-dismiss).
- Never animate width/height directly on text — animate a container instead.

---

## Section 4: Sprint Plan

### Sprint 5 — Polish Pass

**Goal**: Fix visible regressions, align active states with design, connect popups to bar, establish animation consistency.

**Scope**:
- Active tag dot: set color to mauve, ensure dot size change only (remove any glow/background if present)
- Volume bar icon: scroll → `pactl` change, click → mute toggle; popup if any should originate from icon position
- Brightness bar icon: same pattern
- Popups connected to bar: anchor popup x-position to the triggering icon's x-position
- Animation pass: apply `Anim.*` tokens to all existing animated properties; remove any hardcoded durations
- CC: wrap display-layout and idle-config sections in `Expander` collapsible components (collapsed by default)
- CC: verify scroll and sliders work after the flickable fix

**Done when**: No instant state changes remain in existing components; popups visually emerge from bar; CC is not overwhelming on open.

---

### Sprint 6 — Notification System

**Goal**: Full notification pipeline — toasts on arrival, notification center panel for history.

**Scope**:
- Listen to `org.freedesktop.Notifications` DBus interface via Quickshell
- Toast component: stacked top-right, `Anim.entrance` on arrive, `Anim.exit` on dismiss, click to dismiss
- Toast stack: max visible N (configurable), oldest auto-dismiss after timeout
- Notification center panel: slide in from right (or top-right), lists all notifications in reverse-chronological order
- Per-notification: app icon, app name, title, body, timestamp, dismiss button
- Clear-all button
- Notification center triggered from a bar icon (bell)
- Respect `urgency` field — critical notifications do not auto-dismiss

**Done when**: `notify-send` creates a toast; notification center opens from bar and shows history; dismiss and clear-all work.

---

### Sprint 7 — Launcher

**Goal**: Native QML fuzzy app search launcher, caelestia/noctalia style.

**Scope**:
- Parse `.desktop` files from standard XDG paths (`/usr/share/applications`, `~/.local/share/applications`)
- Fuzzy match on name and generic name (case-insensitive, substring or FZF-style scoring)
- Display: app icon + name + comment in a centered floating panel
- Keyboard navigation: arrow keys, Enter to launch, Escape to close
- Launch via `gio open` or `Exec` field from `.desktop`
- `Anim.entrance` on open, `Anim.exit` on close
- Triggered from keybind and optionally a bar icon

**Done when**: Typing partial app name shows matches; Enter launches the app; Escape closes; panel animates in/out.

---

### Sprint 8 — Bluetooth Native Integration

**Goal**: Replace external Bluetooth app with native CC integration.

**Scope**:
- Quickshell service wrapping `bluetoothctl` (or DBus `org.bluez` directly)
- CC quick toggle: enable/disable adapter
- CC expandable Bluetooth section: list paired devices, connect/disconnect per device, show connection status
- Bar status icon reflects adapter state and active connection
- Remove any leftover delegation to external BT app

**Done when**: BT can be toggled and a paired device connected/disconnected entirely within the shell, no external app launched.

---

### Sprint 9 — Lock Screen

**Goal**: Native QML lock screen using WlSessionLock and PamContext.

**Scope**:
- `WlSessionLock` surface covering all outputs
- Clock and date displayed while locked
- Password input field — characters masked
- `PamContext` for PAM authentication
- Failed auth: shake animation on input field, clear password
- Wallpaper or blurred compositor snapshot as background
- Lock triggered from CC power section and keybind
- SDDM theme (same visual language, lower priority — can ship as Sprint 9b)

**Done when**: Lock screen appears, accepts correct password to unlock, rejects incorrect password with visual feedback.

---

### Sprint 10 — Theme System

**Goal**: Switchable Catppuccin variants; architecture ready for fully custom palettes.

**Scope**:
- Extract all color literals into a single `Theme.qml` singleton (one source of truth)
- Implement Catppuccin Macchiato, Mocha, Latte, Frappe as built-in variants
- CC setting to switch variant at runtime (no restart required)
- Persist selected theme across sessions
- Document palette token names so custom themes (Warhammer, Gundam, Cyberpunk) only need to fill the same token map
- Validate all existing components bind to `Theme.*` tokens, not hardcoded hex

**Done when**: Switching theme in CC repaints the entire shell without restart; all four Catppuccin variants work correctly.

---

## Section 5: Open Questions

### Sprint 5
- Should popups (volume, brightness) be `PopupWindow` roots or layered `Item` children of the bar? `PopupWindow` is cleaner but requires knowing the exact screen coordinates of the trigger icon at runtime. Evaluate Quickshell's `mapToGlobal` equivalent.
- Is a single shared `Expander` component worth creating for CC collapsibles, or inline it per section?

### Sprint 6
- Does Quickshell expose a ready-made DBus `org.freedesktop.Notifications` server interface, or do we implement the listener manually with `DBusServiceObject`? (Confirmed: `Quickshell.Services.Notifications.NotificationServer` exists)
- Notification center panel: full-height right side panel, same slide animation as CC, triggered by bell icon in bar. Confirm exact width and whether it overlaps or pushes CC.
- Notification persistence: store to disk (SQLite/JSON) or in-memory only for this sprint?

### Sprint 7
- `.desktop` file parsing: use a Quickshell `FileView` approach or shell out to `gio` / `find` for the list? In-process parsing is preferable to avoid subprocess latency on each keystroke.
- Should the launcher also search web (like some launchers do) or remain app-only for now?
- Calculator / unit conversion in launcher bar (end-4 style)? Defer or include?

### Sprint 8
- DBus `org.bluez` direct vs `bluetoothctl` subprocess: direct is more reliable and lower latency but requires more QML DBus boilerplate. Decide before sprint start.
- How many paired devices to show in the CC section before requiring a scroll? Suggest cap at 5 visible, scroll for more.

### Sprint 9
- `PamContext` availability: confirm Quickshell ships with or exposes a PamContext QML type, or whether a small C++ helper is needed.
- Wallpaper source for lock screen: reference the same wallpaper path as the compositor config, or use a dedicated lock screen wallpaper setting?
- Should the lock screen show the notification count/previews, or be fully opaque to content?

### Sprint 10
- At what granularity do we expose theme tokens — full Catppuccin 26-color palette, or a smaller semantic set (`background`, `surface`, `overlay`, `text`, `accent`, `warning`, `error`)? Semantic set is safer for custom themes but may not cover all Catppuccin nuance.
- Hot-swap theme without restart: requires all color bindings to be property bindings to `Theme.*`, not `Component.onCompleted` copies. Audit scope before starting.
