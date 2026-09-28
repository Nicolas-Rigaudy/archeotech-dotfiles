# Archeotech shell — Architecture & Code-Health Audit

Scope: `~/Projects/archeotech-shell` @ `e94770f` (207 commits, 123 QML files, 18.7k lines), plus the ADRs in `archeotech-dotfiles/logics/architecture/`. The audit was read-only: I read files, ran grep/wc and read git logs, and inspected the installed Quickshell (**0.3.1-1**, `/usr/lib/qt6/qml/Quickshell`). I did not run `qs`.

Confidence tags: **[C]** confirmed by reading the code. **[L]** likely: the code path is clear, but I did not observe it at runtime. **[V]** verify: depends on Quickshell or compositor behaviour I could not test.

---

## 0. Executive verdict

The **core rendering architecture is sound** and on par with the best Quickshell shells (caelestia and noctalia class):
- one full-screen overlay surface per monitor
- a single `FrameBackground` shape
- a `QsWindow.mask` union for input
- thin exclusion windows
- per-screen `stateMap`
- a shared `holderRoot` contract across bar and strip

The weaknesses are all **around** that core:

1. **The theme engine lives in the wrong layer.** Pack-specific (Grimdark) visuals leak into core code (about 130 branches in 20 files).
2. **Knowledge is duplicated across four hand-maintained registries.** A panel id is spelled in 5+ places.
3. **The plugin API is not good enough for third parties.** Plugins cannot reach any service.
4. **Process handling is fragile.** About 60 `Process` objects, mostly `bash -c` strings. A single-slot reuse pattern silently drops commands.
5. **The code is heavily coupled to the owner's dotfiles and machine**: `~/.local/bin` scripts, swayidle/wlsunset caches, `/opt/zen-browser-bin`, `amixer -c 0`, `hci0`, sed on the mango config, and `theme-switch.py` clobbering starship/fish.
6. **Several native Quickshell modules are unused** even though they now exist in 0.3.1: `Networking`, `Bluetooth`, `SystemClock`, `ScriptModel`, `LazyLoader`, `IdleMonitor`, `ToplevelManager`, `BackgroundEffect`.

Much of the remaining work is replacing code with those modules rather than writing new code.

**The single worst perf bug is cheap to fix:** every bar widget is instantiated **twice** (§3.1).

---

## 1. Overall architecture

### 1.1 Boot (`shell.qml`)
- `shell.qml:26-41` references 16 singletons as `property var` to force instantiation. `:49` touches `ColorScheme.effectiveMode` for the same reason (lazy singletons).
  - This works, but boot order is implicit. Nothing expresses dependencies, e.g. that ColorScheme needs Config ready, which needs PackRegistry.
- `shell.qml:55-103` has **5 `Binding`s that push service state into `Commons.Appearance`**: `flatMode`, `activePack`, `activePackDir`, `activePackStyles`, `packSettings`. They exist because "Commons can't import a Service".
  - This layering is inverted. `Appearance` *is* the theme engine: it loads `theme.json` and `tokens.json` via FileView and does register merges (`Commons/Appearance.qml:57-230`). It is only fed from above because it sits in the wrong layer.
- `shell.qml:111-126` applies the pack's window decoration on `Component.onCompleted` and on every pack change. See the §5.1 ordering bug.
- `shell.qml:130-215`: 9 IpcHandlers, 7 of them the same `toggle/open/close` triplet for a hard-coded panel id.
  - Plugin panels cannot be opened by keybind at all.
  - `close()` always calls `closeAllAcross()`, so `launcher close` also closes the NC.
- `shell.qml:227-330` puts the toast queue and toast PanelWindow inline in the root.
  - The toast window has **no `screen:`** (`:277`), so toasts always land on the compositor's default output rather than the focused one.
  - The model is a JS array replaced on every change (`:233`, `:317-324`). The Repeater therefore **re-creates every toast delegate** on each arrival or dismiss, which **restarts every other toast's timeout**. In a burst, toasts never expire. **[L]**
- `shell.qml:44` still logs `"[Sprint 17] …"`. There are 126 comment references to Sprint/item/task ids across the QML; that is changelog in comments, which is noise for a public repo.

### 1.2 Per-monitor surface (`Modules/Shell/ShellSurface.qml`)
- The design is sound: one `PanelWindow` per screen (`:21-33`) with `ExclusionMode.Ignore` plus a mask union of 10 regions (`:55-66`).
  - `BarPopupMask` (`:73-86`) mirrors bar popup bounds. This is a reasonable workaround for popups that float outside the side rect.
- Keyboard focus is Exclusive only on the focused output (`:41-47`). Correct, and well reasoned.
- **Concern [V]:** the surface is on `WlrLayer.Overlay` (`:33`), is full-screen, and stays mapped even when `sidesHidden` (fullscreen) is true. Only children become invisible.
  - Many wlroots compositors cannot do direct scan-out while any surface sits above a fullscreen client, even a transparent, input-masked one. That costs games and video.
  - The fix is to unmap the surface (`visible: false`) when `sidesHidden(screen)` is true and no panel is open.
  - Also consider the `Top` layer for the frame, keeping `Overlay` only for panels and popups.
- `Builder.EditOverlay` (`:293-296`, 972 lines) is **always instantiated on every screen** and hidden through `visible: Commons.State.editMode` (`EditOverlay.qml:23`). It should be a `Loader`/`LazyLoader` with `active: State.editMode`.
- `FrameFx` and `WindowBrackets` are also always instantiated. They are cheap when the pack is off, but see §3.3.
- `ShellExclusions.qml`: 4 windows × N screens, each with an empty mask. Sound (ADR-015/§15).
  - `_zone()` returns 0 when hidden, which lets fullscreen clients reclaim the edge. Good.

### 1.3 State (`Services/Shell/ShellState.qml`)
- `stateMap` is a plain JS object, cloned and reassigned on every mutation (`:37-43`). Every call to `anyOpen`, `activePanel` and so on re-evaluates on any change on any screen. That is fine at N≤4.
- `closeAllAcross()` (`:91-95`) resets `open` but **not `side`**. That is harmless today but inconsistent with `close()` at `:78-84`.
- `sidesHidden()` (`:20-23`) depends on `CompositorService.isFullscreen`. That is always `false` on Hyprland (`HyprlandService.qml:55`), so **auto-hide in fullscreen is broken on the fallback compositor**. **[C]**

### 1.4 Widget mounting (filename convention + holderRoot)
- `WidgetRegistry.widgetFile()` (`:128-132`) plus `WidgetLoader` (`Sides/WidgetLoader.qml`) is a clean design, and the holderRoot contract is documented. Weaknesses:
  - **"No central registry to edit" (WIDGET_API.md:3) is false.** The palette reads a hand-maintained catalogue, `availableWidgets` (`WidgetRegistry.qml:24-47`). A new file that is not in it never appears in Edit Layout.
  - Built-in config schemas also live in that same singleton (`:74-82`), not next to the widget.
  - Panel-opener knowledge is spread across `WidgetRegistry._panelOpenerIds` (`:56`), `ShellConfig._stripToBarWidget/_barToStripPanel/_stripCapable` (`ShellConfig.qml:219-221`), `PanelRegistry.panels` (`PanelRegistry.qml:15-66`), `shell.qml` IpcHandlers, and `Strip._isPrimaryHost` order (`Strip.qml:77-84`).
  - **Plugin load race [L]:** `WidgetLoader._resolve()` runs only on `Component.onCompleted` and `onWidgetIdChanged` (`WidgetLoader.qml:108-109`, full-file numbering). If `ModuleRegistry.moduleFor()` returns null because the async jq scan (`ModuleRegistry.qml:150-182`) has not exited yet, the loader sets `source = ""` and **never retries**. Nothing connects to `ModuleRegistry.ready` or `modules` (grep: 0 hits). As a result, a `plugin:` widget placed on a bar is likely blank after a cold start until the config is next edited.
  - Disabled plugins keep running (`ModuleRegistry.qml:122-125`, "ponytail"). The loader never checks `isEnabled`.
- **Bar vs Strip model inconsistency.**
  - Bar keeps stable `ListModel`s with a diff sync (`Bar.qml:169-224`). Good.
  - Strip uses `model: strip._icons` (`Strip.qml:65`, `:453`), a fresh JS array on **every** `ShellConfig.data` change. Every strip icon is therefore destroyed and re-created on any config write, contrary to the "stable ListModel survives hot-reload" locked constraint.
  - `Quickshell.ScriptModel` (keyed diffing, available in 0.3.1) replaces both hand-rolled approaches.

### 1.5 `shell-config.json` hot-reload (`Services/Shell/ShellConfig.qml`)
- The read-time shim (`_sideContent`, `:76-90`) that normalises legacy `zones`/`icons` into `content` is well done (ADR-022).
- Every accessor goes through `side()` → `data` (`:37-47`). Any write re-evaluates every bound accessor on every screen. Acceptable.
- **Every `_mutate` fires twice** (`:202-208`): `data = d` triggers sync, then `_save()` → FileView watch → `onTextChanged` (`:420-446`) reparses and reassigns `data`, which triggers a second full sync of all zones and a FrameBackground rebuild.
  - Fix: an `_selfWrite` guard, or compare the text before reassigning.
- **`perScreen` is read but never written.** No mutator touches `perScreen`. Edit mode on a monitor that has an override edits the global side while displaying the override.
- Defaults are hard-coded in mutators (`setSideType` sets `size = 30/10`, `expanded = 44`, `:248-256`). These duplicate `_defaults` (`:10-28`) and `Appearance.bar.height`.
- There is no `version` field in the file and no migration hook, which is required before v1.0 freezes the format.
- A missing file leaves `ready` false forever (only `onTextChanged` sets it, `:420-446`). Nothing consumes `ready`, so this is latent.

### 1.6 PackRegistry / theme engine
- There are three layers:
  - `theme.json`, the family/flavor, written by `theme-switch.py`
  - the pack `tokens.json` overlay plus registers and pack settings (`Appearance.qml:126-170`)
  - style delegates (`Appearance.qml:271-282`, `StyleDelegate.qml`)
- The idea is good (ADR-026/027). The execution has problems:
  - **Layer C is almost unused.** There is exactly one delegable component (`GlassButton.qml:63`), and packs ship one delegate each (`packs/{grimdark,hud}/styles/GlassButton.qml`).
  - All other Grimdark looks are **hard-coded in core**. `frameChamfer` / `steel` / `_steel` / `_consoleOn` / `packMaterial*` appear about 130 times across 20 files. The heaviest are SegmentedControl (17), and WifiPopup, HoverCard, CalendarPopup, BtPopup and Strip (10 each). There is also `Bar.qml:356-403` (console rivets, `rivet.png` path), `Strip.qml` `ConsoleChrome`, and `FrameFx.qml:122-176`, which **re-hardcodes the same steel hex values** already tokenised at `Appearance.qml:251-255`.
  - Every new pack will need core edits. That contradicts "themes are pure JSON + assets" (README).
  - `_mergedPack` (`Appearance.qml:158-168`) deep-clones via `JSON.parse(JSON.stringify())` on every pack-settings change. That is fine as a cached property, but `_c()` is called about 60× per re-evaluation.
  - `Appearance.reload()` (`:113-117`) resets the path because "watchChanges alone is unreliable", and theme-switch triggers it through IPC. That is two reload paths.
  - `shellVersion: "0.3.0"` is hard-coded (`Appearance.qml:271`) and coincides with the Quickshell version, which is confusing. Read it from a `VERSION` file.
  - Pack discovery is an async `bash+jq` scan (`PackRegistry.qml:90-130`). As a result `activePackDir` is `""` on the first frames, so **every boot with a pack active renders the base look first and then flips** (flash), and it triggers the ordering bug in §5.1.

### 1.7 Service layer boundaries
- The domain folders are clean (`Services/<Domain>/`), and the `CompositorService` facade (`CompositorService.qml:15-45`) is the right idea.
- Boundary violations:
  - Services shell out to user scripts via `Commons/Paths.qml:10-16`: `~/.local/bin/wifi-scan.sh`, `theme-switch.sh`, `bt-agent.py` via PATH (`Bluetooth.qml:236`).
  - UI modules own system logic that should be services:
    - `SystemStatus.qml:56-70` does CPU/RAM/disk/battery through bash every second and re-reads `BAT0` although `Battery` already exists.
    - `PowerPane.qml:30-78` does power profiles and swayidle.
    - `DisplayPane.qml:22-70` does wlsunset.
    - `Launcher.qml:131-170` does usage persistence through bash `printf` and the pacman dependency filter.
    - `ActiveProjects.qml:29-62` scans git.
- Mixed base types: some singletons are `Item` (`Notifications.qml:5`, `MprisService.qml:7`) and most are `QtObject`. Some use `property var monitor: Process` and some use `property Process`. The inconsistency is cosmetic but indicates there is no service template.

### What I would restructure
1. `Services/Theming/ThemeEngine` owns theme.json, pack loading, registers and settings, and exposes one read-only token tree. `Commons/Appearance` becomes a thin alias. This deletes the 5 Bindings in `shell.qml`.
2. **Dogfood the plugin manifest.** Describe every built-in widget and panel in a `module.json`-style manifest (or one `builtins.json`): id, caps, glyph, schema, panel size. `WidgetRegistry`, `PanelRegistry`, `_stripCapable` and the IPC list become derived views. Add one generic `IpcHandler { target: "panel"; toggle(id) / open(id) / close(id) }`.
3. Move pack-specific chrome out of core into style delegates. Promote each popup "neck card" (Strip, HoverCard, CalendarPopup, WifiPopup, BtPopup, BarPanel all hand-draw the same 8-arc `ShapePath`) into one `NeckCard` primitive with a `StyleDelegate`.
4. Add a `Services/Core/Exec` helper (§2.1) and ban raw `bash -c` string building.

---

## 2. Services

### 2.1 The single-slot `Process` pattern drops commands **[C]**
Setting `running = true` on a Process that is already running is a no-op, and `command` changes do not restart it. Many services reuse **one** Process for many commands:

| Where | Effect |
|---|---|
| `MangoService.qml:269-281` `_cmdRunner` shared by `dispatch`, `switchTag`, `setProportion`, `setDefaultProportion` and `applyWindowDecor` | `applyWindowDecor`'s bash (grep/sed/`reload_config`/`sleep 0.1` loop, `:252-267`) blocks the runner. Any tag click or dispatch during it is **silently dropped**. |
| `ColorScheme.qml:71-88` `_applyProc` | `_lastApplied = key` is set *before* the run (`:80`). A second flavor click while `theme-switch.py` runs is dropped, yet the dedup key says it was applied. `theme-switch.py:584` also self-skips ("another theme-switch is in progress"). **The UI shows theme B while the system stays on theme A.** |
| `Brightness.qml:67-74` `_cmd` | Fast scroll-wheel steps are dropped. `percent` is set optimistically (`:75`), so the slider and the hardware drift apart. That is a "fake toggle" by the project's own design rule. |
| `Network.qml:155-177` `_connCmd`, `Bluetooth.qml:133-141` `_cmd`, `PowerPane`/`DisplayPane` `cmdRunner` | Same class of bug. |

**Fix (S):**
- Use `Quickshell.execDetached([...])` for fire-and-forget calls such as `mmsg dispatch`, `brightnessctl set` and `amixer`.
- For calls that need results, use a tiny queue component. Either spawn a `Process` per request via `Component.createObject` and destroy it on exit, or keep a FIFO with a "latest wins" coalesce for setters like brightness and theme.

### 2.2 Process inventory and polling
- 62 `Process {}` declarations. Only 5 `execDetached` call sites.
- Long-lived streams:
  - `nmcli monitor` ×2. It is duplicated in `Network.qml:43-50` and `VPN.qml:62-74`.
  - `gdbus monitor` (`Bluetooth.qml:43-59`)
  - `udevadm monitor` (`Brightness.qml:51-62`)
  - `mmsg watch` ×3 (`MangoService.qml:~90-122`, with exponential backoff to 8s; good)
- **`Network.qml:47`: every `nmcli monitor` line triggers `refresh` *and* `_scan()`** (which runs `wifi-scan.sh`), with no debounce. `nmcli monitor` is chatty (every connectivity, DHCP and device-state line), so this is a scan storm on roaming.
- **`Network.qml:49` and `VPN.qml:74` restart immediately on exit with no backoff.** On a machine without NetworkManager (a stranger's machine), `nmcli` exits instantly, which means a **tight respawn loop at 100% CPU**. That violates ADR-013 ("auto-restart must distinguish clean exit from failure").
- `Bluetooth.qml:66-69`: a 3s poll timer is always running (it only acts if the monitor is down). The device refresh (`:93-115`) forks about 6 `busctl` per device per refresh. `/org/bluez/hci0` is hard-coded (`:73`, `:94`, `:144`, `:148`, `:225`).
- `SystemStatus.qml:43-70`: `bash + 2×awk + sleep 0.3 + df + cat` every second while the dashboard is open. Read `/proc/stat` and `/proc/meminfo` with `FileView` (reload on a Timer) instead of forking.
- `Launcher.qml:131-153`: `pacman -Qdq | xargs pacman -Ql` on every launcher instantiation. Arch-only, and slow (hundreds of ms).
- Security: **`Network.qml:179-183` passes the Wi-Fi password in argv** (`nmcli dev wifi connect … password '<pw>'` through `bash -c`). It is visible to any local user via `ps` or `/proc/*/cmdline` during the connect.

### 2.3 Native Quickshell modules (installed 0.3.1)
| Module | Status | Replaces |
|---|---|---|
| `Services.Pipewire` | ✅ adopted (`Audio.qml`) | but see the `amixer -c 0 sset Master` hack at `Audio.qml:76-80`, which is machine-specific and runs on *every* mute change. Make it opt-in. |
| `Services.UPower` | ✅ `Battery.qml` | `SystemStatus` still reads sysfs `BAT0`/`BAT1`. |
| `Services.Mpris` | ✅ | `MprisService._updatePlayer` runs only on `players` list change (`:16-33`), not on `isPlaying` change, so it sticks to a paused player when another starts. |
| `Services.Notifications` | ✅ | `actionsSupported: false` (`Notifications.qml:18`): no action buttons, no images or inline reply, and unbounded `history` (`:21`) holding live `notif` refs. |
| `Services.SystemTray` | ✅ `TrayWidget` | — |
| **`Quickshell.Networking`** | ❌ **available, unused** | exposes `connectWithPsk`, `forget`, `autoconnect`, `connectivity`, and a device list. Replaces all 10 Processes in `Network.qml`, `wifi-scan.sh`, both `nmcli monitor`s, and the argv password leak. |
| **`Quickshell.Bluetooth`** | ❌ **available, unused** | `BluetoothAdapter`/`BluetoothDevice` replace all 9 Processes in `Bluetooth.qml`, the gdbus monitor, busctl, and the `hci0` hard-coding. Pairing may still need `bt-agent.py` **[V]**. |
| `Services.Pam` + `WlSessionLock` | ❌ | Native lock instead of hyprlock/swaylock scripts (`Paths.hyprlockLaunch` is also dead). |
| `Services.Polkit` | ❌ | Polkit agent. A stranger otherwise needs a separate one. |
| `Services.Greetd` | ❌ | Optional greeter (post-1.0). |
| `Wayland.IdleMonitor` / `IdleInhibitor` | ❌ | `PowerPane`'s swayidle cache file + `~/.config/swayidle/config.sh` (dotfiles-only, so a **fake toggle** on a stranger's machine), plus a caffeine toggle. |
| `Wayland.ToplevelManager` | ❌ | Window title and app list portable across compositors; could fill Hyprland's missing `isFullscreen`. |
| `Wayland.BackgroundEffect` | ❌ | Real blur behind glass via ext-background-effect, if MangoWC supports it **[V]**. Revisit ADR-008. |
| `SystemClock` | ❌ | `ClockWidget.qml:57,68` 1s Timers rebuilding rich text. Use `precision: SystemClock.Minutes` when `!showSeconds`. `MprisService`'s position tick could use it too. |
| `ScriptModel` | ❌ | `Bar._syncZone`, `Strip._icons`, `WindowBrackets._marks`, toast queue. |
| `LazyLoader` | ❌ | `EditOverlay` and other hidden heavy UIs. |
| `FileView` + `JsonAdapter` | FileView ✅, JsonAdapter ❌ | ADR-009 says "Config singleton **JsonAdapter**", but `Config.qml` is hand-rolled JSON with deep clone on every `set` (`Config.qml:56-69`). **ADR drift.** |
| `DesktopEntries` | ✅ Launcher | — |

### 2.4 Compositor backends
- `MangoService` is solid overall: JSON streams and backoff. However:
  - `fullscreen` per output is written only from the focusing-client stream (`:186`). When focus leaves a fullscreen window's monitor, that output's flag goes stale. Derive it from `clients[]` (`is_fullscreen` per client, `:~200`) instead.
  - **`setDefaultProportion` and `applyWindowDecor` sed the user's compositor config** (`:235-267`) and run `reload_config`. For a public shell, that is invasive: editing a stranger's config file is surprising. It also causes git churn in the owner's dotfiles, which is the same issue the claude.md "theme-switch churn" note describes. Make it opt-in, or write a separate `archeotech.conf` include.
- `HyprlandService` is partial:
  - `isFullscreen`, `clientsFor` and `layoutFor` are stubs (`:52-55`).
  - `selected` uses the *global* focused workspace (`:34`), so non-focused monitors show no active workspace. It should use `monitor.activeWorkspace`.
  - Only existing workspaces are listed, whereas mango shows fixed tags 1..9.
- Detection is "not Hyprland ⇒ Mango" (`CompositorService.qml:18-19`). On sway, niri or river, the shell spins `mmsg` restarts forever with backoff and shows empty workspaces. Add a `none`/generic backend using `ToplevelManager`, plus an explicit `compositor` config override.

---

## 3. Code quality

### 3.1 P0 perf bug: every bar widget is instantiated twice **[C]**
In `Modules/Shell/Sides/Bar.qml`:
- the horizontal `RowLayout`/`Row` Repeaters (`:282-354`, left/right/center)
- **and** the vertical `ColumnLayout`/`Column` Repeaters (`:410-469`)

all bind to the **same** `_leftModel`/`_centerModel`/`_rightModel`. The losing orientation is only `visible: false`. Every widget (Tray, Media marquee, Workspaces, Clock with its timers, Network, and so on), and every plugin, therefore exists twice per bar per screen. That doubles bindings, timers and any per-widget Process.

**Fix (S):** set `model: bar.horizontal ? _leftModel : null` on the horizontal Repeaters and the inverse on the vertical ones, or wrap each orientation in a `Loader`.

### 3.2 Largest files (top 10 by lines)
| # | File | Lines | Notes |
|---|---|---|---|
| 1 | `Modules/Shell/Builder/EditOverlay.qml` | 972 | God-object: DnD state machine + library + config dialog + side mocks. Split into `BuilderState` (logic), `SideMock`, `WidgetLibrary`, `ConfigDialog`. Always instantiated (§1.2). |
| 2 | `Modules/Shell/Panels/Content/Launcher.qml` | 799 | UI + usage store (bash printf, `:156-170`) + pacman filter + fuzzy scorer + providers. Extract `LauncherService` + `FuzzyMatch.js`. Hard-coded `kitty` (`:337`) and `_pinnedDefaults ["kitty","zen","code","obsidian"…]` (`:35`). |
| 3 | `Modules/Settings/Panes/ConnectionsPane.qml` | 618 | Duplicates much of WifiPopup/BtPopup list and row logic. |
| 4 | `Commons/Appearance.qml` | 519 | Theme engine in the wrong layer (§1.6). |
| 5 | `Modules/Shell/Sides/Strip.qml` | 506 | Hover/geometry/panel host/chrome in one. Magic sizes `_iconSize 36`, `_iconStride 48`, `_padLong 10` (`:128-131`) are not tokens. |
| 6 | `Modules/Shell/Sides/Bar.qml` | 478 | Owns WiFi/BT/calendar popup state and knows widget ids (`"workspaces"`, `"media"` at `:302-305`). Holder ↔ widget coupling. |
| 7 | `Services/Shell/ShellConfig.qml` | 447 | OK. Mutators duplicate defaults (§1.5). |
| 8 | `Modules/Shell/FrameFx.qml` | 441 | Pack-specific (Grimdark) chrome with hard-coded hex values (`:122-176`). |
| 9 | `shell.qml` | 332 | IPC boilerplate + toasts + theme wiring. |
| 10 | `Modules/Settings/Panes/PluginsPane.qml` | 321 | — |

### 3.3 Performance hazards
- **`WindowBrackets.qml:33-52`:** for each window × 4 corners, a delegate `Shape` with `anchors.fill: parent`, meaning a **full-screen CurveRenderer Shape per corner**. The model is a JS array rebuilt on every `mmsg watch all-clients` event, and that stream fires continuously during window moves and animations. Only active when a pack has `fx.brackets`, but then it is the most expensive thing in the shell. Size each Shape to its bracket (about 20×20) and key the model with `ScriptModel`.
- `HoverCard.qml:46-47`: `layer.enabled: true; layer.samples: 8` on the card Shape (8× MSAA offscreen). This contradicts the project rule (CurveRenderer for AA) and is probably duplicated in the other popups. The effect/layer grep hit Wifi/Bt/Calendar/BarPanel once each.
- `FrameFx.qml` glow uses 4 gradient Rectangles (cheap); a MultiEffect comment remains. `Dashboard` sparkline and gauges faces use Canvas; those are gated to dashboard-open, which is fine.
- Timers that always run: `Bluetooth._pollTimer` (3s), `MprisService` tick while playing (1s), `ColorScheme._clock` (60s in auto mode). `ClockWidget` 1s ×2 (both orientations, because of §3.1).
- `Config.set` deep-clones the whole config and reassigns `_data` (`Config.qml:56-69`), so **every `Config.get()` binding in the shell (51 call sites) re-evaluates on any setting change**, including Audio aliases and FaceHost persistence. Use `JsonAdapter` with per-key properties, or at least per-top-level-key signals.

### 3.4 Hard-coded values and personal coupling
There is no literal `/home/corvus` in the shell repo (good). However, these are machine- or owner-specific:
- `ColorScheme.qml:153-156` `/opt/zen-browser-bin/zen-bin` (opt-in, but it ships)
- `Audio.qml:78` `amixer -c 0 sset Master`
- `Bluetooth.qml:73…` `hci0`
- `ActiveProjects.qml:29,52-53` `~/Projects`, `code`, `kitty`
- `Launcher.qml:35,147,337`: pacman, kitty, the pinned app list
- `PowerPane.qml:51,78` `~/.cache/swayidle.conf` + `~/.config/swayidle/config.sh` (lives in **dotfiles**)
- `DisplayPane.qml:30-70` wlsunset pid file
- `QuickLaunch.qml:20` `setsid <cmd>` through a child Process, which contradicts the `execDetached` lesson in `Launcher.qml:320-325`
- `Commons/Paths.qml:10-16` hard-wires `~/.local/bin/*.sh`. The shell does not work until `install.sh` has run, and breaks if `~/.local/bin` is not writable. Resolve `scripts/` relative to the shell dir (`Qt.resolvedUrl("../scripts")`) as ModuleRegistry and PackRegistry already do.
- `scripts/theme-switch.py:231-236` **overwrites `~/.config/starship.toml`** unconditionally. The same is true for fish `conf.d` (`:263`) and swaylock (`:243`). On a stranger's machine that clobbers their prompt config. Appliers must be opt-in per target, or render only into files the user has explicitly `@import`/`source`d.

Magic numbers vs tokens:
- Panel sizes are hard-coded in `PanelRegistry.qml:15-66` (940×880, 450×680, …).
- The toast is 316/48/24 (`shell.qml:288-309`).
- Strip geometry is described above.
- Colour hex values are almost all tokenised; the exception is FrameFx.

### 3.5 Dead code
- `PanelRegistry._placeholderComp` (`PanelRegistry.qml:76-87`)
- `Network.wired` (never set or read)
- `Paths.wallpaperPicker` and `Paths.hyprlockLaunch` (no consumers)
- `Commons/Primitives` `WidgetPalette.qml` is staged-deleted in the working tree
- `ci.yml` validates a nonexistent `drawer-config.json`
- `ModuleRegistry.modulesFor()` logs a warning per incompatible module *inside a function called from bindings* (`:107-110`), which means log spam on every re-eval

### 3.6 Inconsistent patterns
- 202 relative imports (`"../../../Commons"`) and 0 `qs.*` module imports. Quickshell supports `import qs.Commons` for in-tree files, which is less brittle when files move.
- Two Process-declaration styles, two singleton base types.
- Bar uses a ListModel diff while Strip uses a JS array.
- `Behavior … NumberAnimation { duration: …panel; easing: OutCubic }` is copy-pasted 12× in `ShellSurface.qml:220-276`. `Commons/Anim.qml` exists but is not used there.

### 3.7 Binding-loop risk
- Low overall. There are a few feedback pairs: `Bar._titleMaxWidth` ← `_wsWidth`/`_mediaWidth` pushed from `onWidthChanged` (`Bar.qml:59-62`, `302-305`), and `Strip.panelRect` calls `mapToItem` inside a binding (`:97-102`).
- Neither is a loop today, but both are imperative back-channels that should become declarative, e.g. a `Layout.maximumWidth` on the title.

---

## 4. Extensibility contracts (docs vs code)

| Doc | Mismatch |
|---|---|
| `WIDGET_API.md:3,11` | "No central registry" is false (catalogue `WidgetRegistry.qml:24-47`). Path `config/.config/quickshell/Widgets/…` is stale since the repo split. |
| `WIDGET_API.md` holderRoot table | `thickness` exists on both (Bar `:30`, Strip `:51`) ✅. `showPopup` etc. are documented as "a strip stubs them". **Verify** Strip declares `showPopup`/`hidePopup`/`hideCalendar`/`keepPopupsAlive`: grep found none in `Strip.qml`, so a bar widget placed on a strip that calls them unconditionally will throw `TypeError`. **[L]** |
| `WIDGET_API.md` "Mutually-exclusive popup state" | Documents underscore-private props (`_wifiPopupVisible`, …) as API. Private state is being exported as contract. |
| `PANEL_API.md:16,208` | Stale `config/.config/quickshell/` paths. Adding a panel requires editing 3 files (PanelRegistry, WidgetRegistry catalogue, and shell.qml for IPC, which is undocumented). |
| `MODULE_API.md:17,179` | Says bundled modules live at `~/.config/quickshell/modules/`. The code uses `<shell dir>/modules` (`ModuleRegistry.qml:35`). |
| `MODULE_API.md:174` | Admits "Access to shell *services* beyond theme tokens is not yet exposed". This is the **blocking gap for third parties**: a plugin cannot read volume, battery, MPRIS, network or compositor state, cannot open a panel by id except through `holderRoot`, and cannot persist its own state. |
| `MODULE_API.md` `desktop-widget` | Advertised in `canLiveIn` but ⏳ unimplemented. |
| `INSTALL.md` deps | Missing hard deps: **`jq`** (module and pack discovery silently finds nothing without it), `python3` (theme-switch, bt-agent), `nmcli`, `gdbus`/`busctl`, `udevadm`, `stdbuf`, `amixer`, `powerprofilesctl`, `wlsunset`, `swayidle`. Says `quickshell-git`, but stable `quickshell` 0.3.1 is in Arch extra. Lists `wpctl` for volume OSD, which is obsolete since the Pipewire migration. |
| `README.md` | "License: TBD" is a **release blocker**. "Every panel … is a self-describing module" is aspirational; built-ins are not modules. |
| ADR-009 | Says JsonAdapter; the code doesn't use it. |
| `docs/` | `FLAGSHIP_HANDOFF.md`, `FRAME_CORNER_HANDOFF.md` and `SHELL_VISUAL_DEV.md` are internal AI-session handoffs in the public repo. Move them to the dotfiles `.claude/`. |

**Are the contracts good enough for third parties?** Not yet:
- There is no versioned plugin API object.
- There are no services.
- There is no lifecycle (`onActivated`/`onDeactivated`), so panels cannot know they are shown.
- There is no per-plugin storage.
- There is no sandboxing story. Plugins run arbitrary QML with `Process` access. That is acceptable for Quickshell, but it must be stated.
- Discovery depends on jq and a manual rescan.

**Recommendation:** inject a single frozen `shell` context object into every plugin, versioned with `apiVersion`, alongside `appearance`:
- `shell.audio`, `shell.battery`, `shell.media`, `shell.net`, `shell.compositor` (read-only facades)
- `shell.panels.toggle(id)`
- `shell.storage(pluginId)`
- `shell.exec(argv)`

Gate on `minShellVersion`. Then rewrite 2-3 built-ins (clock, battery, notes) as modules to prove it.

---

## 5. Reliability, testability, stranger's machine

### 5.1 Startup ordering
- **Pack window-decor double reload [L].** `shell.qml:119` calls `_winDecor.apply()` at `Component.onCompleted`. `Config` is not loaded yet (`Config.qml:19-44`: `preload:false`, flipped to true in `onCompleted`, async), and `PackRegistry` has not scanned. So `packWindow` is `{}` and apply sends base values (12/2).
  - If last session left pack values in `config.conf`, `MangoService.applyWindowDecor` seds it back to base and runs `reload_config`, which cycles the keyboard layout.
  - When the pack resolves, `on_PackDataChanged` fires apply again. Because `_cmdRunner` is still busy (§2.1), **that second call is likely dropped, leaving the compositor in base decor**. Otherwise the result is two compositor reloads per shell start.
  - **Fix:** gate on `Config.ready && PackRegistry.ready`, and use a proper queue.
- **ColorScheme boot** (`ColorScheme.qml:111-128`) seeds `_lastApplied` with `activePackDir`, which is still `""` at boot. When the pack dir arrives, `onActivePackDirChanged` (`:92-95`) runs the whole `theme-switch.py` (~11 targets) **on every boot with a pack**.
- **First-frame flash:** `Config`, `ShellConfig`, `theme.json` and packs all load asynchronously, so frame 1 shows defaults (Macchiato, base look, flatMode false). Use `blockLoading: true` for these small JSON files, and hold the surfaces `visible: false` until a `Boot.ready` aggregate is true.
- **`Config` data-loss window [V]:** if any code calls `Config.set()` before the async load completes, `_data` is `{}`. The debounced write (`Config.qml:35-38`) then **overwrites config.json with a single key**. `ColorScheme` guards on `ready`; other setters (FaceHost, Audio aliases, ModuleRegistry.setEnabled) do not. Make `set()` refuse or queue while `!ready`.
- `Config`/`Persistent` create their dirs with an async `mkdir -p` Process (`Config.qml:14-17`) that races the first `setText`. Create them in `install.sh`, or check with `FileView` `onLoadFailed` and write again.

### 5.2 What breaks on a stranger's machine (ranked)
1. **Not MangoWC and not Hyprland** (sway, niri, river): no workspaces, no title, `mmsg` restart loop. The README only promises "wlroots-based", which over-promises.
2. **No NetworkManager:** `nmcli monitor` hot-respawn loop at 100% CPU (`Network.qml:49`, `VPN.qml:74`).
3. **No `jq`:** zero modules and zero packs, silently (`ModuleRegistry.qml:155`, `PackRegistry.qml:92-100`).
4. **`install.sh` not run or `~/.local/bin` not on PATH:** theme switching, wallpaper, Wi-Fi scan and power menu are silently dead (`Paths.qml`, `PowerWidget.qml:12` `wlogout-launch.sh` via bash PATH).
5. **Theme switch clobbers** starship/fish/swaylock configs (`theme-switch.py:231-263`), and the shell seds `~/.config/mango/config.conf`.
6. **Non-Arch:** the Launcher pacman filter errors out silently; `SystemNotes` uses checkupdates/paru; the INSTALL instructions are paru-only.
7. **Fake toggles:** idle/dim/lock (PowerPane → dotfiles swayidle script) and night light (DisplayPane → wlsunset pid file in `~/.cache`).
8. **Hardware assumptions:** `amixer -c 0 Master` on every mute, BT adapter `hci0`, a desktop with no backlight (`brightnessctl` errors and the udev monitor idles), batteries named BAT0/BAT1.
9. **Hyprland:** no fullscreen auto-hide and wrong workspace selection on secondary monitors.
10. Toasts appear on the wrong monitor (`shell.qml:277`).

### 5.3 Error handling and testability
- Errors are logged with `console.warn` at best. `printErrors: false` is set on all FileViews, so a malformed `theme.json` fails silently (`Appearance.qml:70`: `catch (_) {}`). There is no user-visible "degraded" indicator.
- A `Health` service should collect missing binaries and failed loads at boot (`which nmcli jq …`) and surface them in Settings → About. That gives the stranger-debugging story in one place.
- Tests: **none.**
  - CI (`.github/workflows/ci.yml`) runs `bash -n`, `py_compile` and JSON validation. It says QML lint needs "a Quickshell CI image", but `quickshell` 0.3.1 is in Arch **extra**, so an `archlinux:latest` container with `pacman -S quickshell qt6-declarative` can run `qmllint` today.
  - Also worth adding: a headless smoke boot that runs `scripts/shot.sh` in CI under a nested/headless compositor and fails on any `ReferenceError`/`TypeError` in the log. The harness already exists for local use.
- Pure-JS logic is **unit-testable with `qmltestrunner` or plain node**: `ShellConfig._sideContent/_regroup/moveEntry`, `WidgetRegistry._pascalCase`, `_verGte` (duplicated in ModuleRegistry `:73-83` and PackRegistry), the Launcher fuzzy scorer, `Network._dedup`. Extract it to `.js` libraries (`.pragma library`) and test there.

---

## 6. Upgrade plan

Effort: **S** ≤ half a day, **M** 1–3 days, **L** about a week or more.

### P0 — correctness, perf and release blockers (do first, in this order)
| # | Item | Evidence | Effort |
|---|---|---|---|
| P0-1 | Stop double-instantiating bar widgets (null the inactive orientation's models or Loader-gate them) | `Bar.qml:282-354` vs `410-469` | S |
| P0-2 | Add an `Exec` helper: `execDetached` for fire-and-forget, per-call or coalescing queue for result calls. Migrate MangoService, ColorScheme (move `_lastApplied` to on-success), Brightness (latest-wins), Network/BT/Power/Display runners | `MangoService.qml:269-281`, `ColorScheme.qml:71-88`, `Brightness.qml:67-75` | M |
| P0-3 | Boot gating: `blockLoading` on config/theme JSON; `Config.set` refuses or queues until ready; gate `_winDecor.apply` and `ColorScheme._bootResolve` on `Config.ready && PackRegistry.ready`; retry the WidgetLoader plugin resolve on `ModuleRegistry.modulesChanged` | `shell.qml:119`, `ColorScheme.qml:111-128`, `Config.qml:19-44`, `WidgetLoader.qml:108-109` | M |
| P0-4 | Respawn backoff plus a binary-presence check for `nmcli monitor` ×2; dedupe into one NM event source; debounce `_scan` | `Network.qml:43-50`, `VPN.qml:62-74` | S |
| P0-5 | Remove the Wi-Fi password from argv (short term: `nmcli --ask` via stdin; real fix: P1-1) | `Network.qml:179-183` | S |
| P0-6 | Stop clobbering third-party configs: per-target opt-in for starship/fish/swaylock/VSCode/Obsidian/Zen/mango-sed, with defaults off for a fresh install; keep the owner's opt-ins in the dotfiles | `theme-switch.py:231-263`, `MangoService.qml:235-267` | M |
| P0-7 | Pick a LICENSE; fix install docs (jq, python3, stable `quickshell`, remove wpctl); fix stale paths in WIDGET/PANEL/MODULE_API; move the handoff docs out; fix `ci.yml` drawer-config | README, `docs/*` | S |
| P0-8 | Toast queue: `ScriptModel` or ListModel with stable ids (no timer resets); `screen:` = focused output | `shell.qml:227-330` | S |

### P1 — architecture (enables v1.0 extensibility)
| # | Item | Effort |
|---|---|---|
| P1-1 | Replace `Network.qml` with **`Quickshell.Networking`** and `Bluetooth.qml` with **`Quickshell.Bluetooth`** (keep `bt-agent.py` only if pairing needs it). This deletes about 19 Processes, `wifi-scan.sh`, both monitors, and the `hci0` hard-coding. | M |
| P1-2 | Move the theme engine into `Services/Theming/ThemeEngine`. `Appearance` becomes a pure token facade; delete the 5 Bindings in shell.qml. Add a `VERSION` file for `shellVersion`. | M |
| P1-3 | Move pack chrome out of core: create a `NeckCard` primitive (dedupe 6 hand-drawn arc paths) plus `StyleDelegate` hooks for NeckCard, SegmentedControl, BarSegment, MetalSurface and frame FX. Move the Grimdark branches (~130) and FrameFx hex values into `packs/grimdark/styles/`. | L |
| P1-4 | Unified manifest registry: built-ins described like plugins; derive WidgetRegistry, PanelRegistry, `_stripCapable` and conversion maps from it; one generic `panel` IpcHandler (`toggle(id)`) so plugin panels are keybindable. | M |
| P1-5 | Plugin API v1: an injected, versioned `shell` context (service facades, `panels`, `storage(id)`, `exec`); lifecycle hooks; enforce `isEnabled` in WidgetLoader; drop the jq dependency (use `FolderListModel` + `FileView` per manifest). | L |
| P1-6 | Compositor portability: a generic backend over `ToplevelManager`; fix Hyprland `isFullscreen` and per-monitor `activeWorkspace`; derive Mango fullscreen from `clients[]`; explicit `compositor` override in config. | M |
| P1-7 | Pull system logic out of UI panes into services (`SystemStats` via FileView on `/proc`, `PowerProfiles`, `Idle` via `IdleMonitor`/`IdleInhibitor`, `NightLight`, `LauncherService`). Remove the fake toggles. | M |
| P1-8 | Config hygiene: `shell-config.json` gets a `version` + migration; `_mutate` self-write guard (no double sync); `perScreen` mutators or hide overrides in edit mode; switch `Config` to `JsonAdapter` (ADR-009) to stop global re-evaluation. | M |
| P1-9 | Add a `Health` service with a missing-deps and failed-loads report in Settings → About. | S |

### P2 — polish, perf and maintainability
| # | Item | Effort |
|---|---|---|
| P2-1 | Unmap the per-screen Overlay surface when sides are hidden and no panel is open (direct scan-out); evaluate moving the resting frame to the `Top` layer [V] | S–M |
| P2-2 | `LazyLoader` for EditOverlay; split EditOverlay (972 lines) and Launcher (799 lines) into logic singletons + views | M |
| P2-3 | `ScriptModel` for Strip icons, WindowBrackets (and bracket-sized Shapes), notifications; `SystemClock` for Clock/MPRIS; drop `layer.samples: 8` on popup shapes | S–M |
| P2-4 | Switch to `qs.*` module imports; strip Sprint/item changelog comments (126) and `[Sprint 17]` logs; one service template (QtObject, `property Process`) | M |
| P2-5 | CI: `archlinux` container → `qmllint` + headless shot.sh smoke boot failing on JS errors; `.pragma library` unit tests for ShellConfig mutators, fuzzy scorer, `_verGte` (dedupe the two copies) | M |
| P2-6 | Notifications: actions, images, bounded history, persistence (PersistentProperties / file) | M |
| P2-7 | Native lock (`WlSessionLock` + `Pam`) and Polkit agent, so a stranger needs no hyprlock/wlogout scripts | L |
| P2-8 | Make the amixer mute-LED mirror, Zen restart, ActiveProjects `code`/`kitty` and Launcher pins config-driven with neutral defaults | S |
| P2-9 | Revisit ADR-008 blur with `Wayland.BackgroundEffect` [V] | S (spike) |

### Sequencing
1. **Week 1 (stabilise):** P0-1, P0-4, P0-5, P0-8 (all S). Then P0-2 and P0-3 together; they touch the same boot and Process paths. Add P2-5's CI lint early, so later refactors have a safety net.
2. **Week 2 (portability):** P0-6, P0-7, P1-1 (native Networking/BT), P1-9 (Health), P1-6.
   - After this, a stranger on MangoWC or Hyprland gets a working, non-destructive shell.
3. **Weeks 3–4 (architecture):**
   - P1-2 goes before P1-3: move the engine, then evict pack code.
   - P1-4 goes before P1-5: unify the registries, then expose the API.
   - P1-8 comes before freezing formats.
   - Tag **v1.0-rc** once the plugin API v1 is dogfooded by 2-3 built-ins.
4. **Post-rc:** P1-7, the P2 items, and the native lock/polkit.
