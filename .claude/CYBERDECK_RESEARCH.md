# Cyberdeck pack: design research (2026-11-05)

Research behind `req_011` (cyberdeck theme pack). Mockups, wallpapers, fonts and the
compare page live in `~/Projects/cr-0w/local/state/shots/cyberdeck-pack/`
(`mock/<direction>/` QML scenes rendered with `shot.sh --qml` at 1920x1200,
`renders2/`, `compare2.html`). Everything shown is original; no third-party art,
logo or font outside OFL.

## First pass, rejected
The first three options were the stock shell with a new palette, a glow and
scanlines (tokens only). The owner rejected them: "not just a faint color filter
on my existing theme". Lesson: a pack identity needs its own structure (bar or no
bar, frame, panel shapes, launcher layout, overlays, wallpaper), not a palette.
Render the target identity first, then map it to engine work.

## Sources studied
- **CyberArch-Shell** (github.com/ARCANGEL0/CyberArch-Shell, no licence, ideas
  only; an explicit Cyberpunk 2077 HUD recreation). Studied its README, stylesheet
  and 14 screenshots/videos. Ideas taken: no bar, HUD clusters floating on a
  full-bleed neon wallpaper; slanted segmented bars; crosshair marks at screen
  corners; numbered slanted launcher rows with a status chip; kill mode as a
  full-screen red wash with an alert banner; region capture as a red box with a
  size readout; tilted floating panels; per-core grid monitor with vertical meters;
  bracketed key hints. Palette: red chrome, cyan interactive, yellow messages,
  green success on near-black. Fonts: Quantico, Rajdhani, Tektur.
- **Film and series FUI**: Rogue One and Andor (BLIND LTD: chunky linework,
  sparse text, one colour per screen); Blade Runner 2049 and Ghost in the Shell
  2017 (Territory Studio: CRT ageing, holographic volumes); Alien / Nostromo
  (cassette futurism: utilitarian hardware, amber or green CRT text terminals).
- **Anime and games**: Evangelion NERV (dark rooms, orange screens, heavy
  condensed warning type, hex motifs); Gundam cockpits (panoramic HUD, damage
  schematic, physical buttons); Persona 5 (red/black, slanted, one accent);
  Deus Ex HR (black and gold); Marathon 2026 (acid graphic, criticised as cluttered
  "fontslop": keep density readable).
- **Design vocabulary** (daisyUI trend pages, FUI guides): clipped/chamfered
  panels, angular brackets, segmented bars and rings, reticles, thin technical
  linework, telemetry readouts, scanlines, chromatic aberration.
- **Fonts (OFL)**: Barlow Condensed, Rajdhani, Share Tech Mono, VT323, Oxanium,
  Chakra Petch, Orbitron. Orbitron reads poorly small; Rajdhani and Barlow
  Condensed hold up in UI labels.

## Owner direction (2026-11-05)
Cyberdeck aesthetic, megacorp ("Arasaka style", original only) corporate
terminals, matrix-like data. CR-0W as a droid character. Look at games, film,
anime (Gundam, Star Wars).

## The three directions
Each was rendered as desk (bar or HUD, system monitor, crow agents, toast),
launcher, kill mode and screensaver, plus crow deck in the matching kitty palette.

### A. Megacorp: CR-0W Systems operator terminal
- Mood: a cold corporate security terminal. Black, warm white, blood red only.
- Palette: bg `#050506`, panel `#0b0b0d`, rules `#2a2a2f`/`#3c3c42`, text
  `#ece9e4`, muted `#8b8a90`, red `#e3122d`. Warnings are inverted red blocks.
- Type: Barlow Condensed Bold caps, tracked wide (headers, big numbers); Share
  Tech Mono (data, codes, hints).
- Elements: house mark (hexagon with a droid eye slit); thin bar with the crest,
  numbered workspace cells, inline readouts, two-line clock; panels with a red
  code tab, hairline frame, red L ticks on two corners, reference codes; 40-cell
  segmented gauges that turn red past the limit; CPU history with labelled axes;
  agent registry with AWAIT/EXEC/HALT/DONE chips and progress rules; CR-0W unit
  schematic card; hex data columns on the screen edges; red ticker.
- Launcher: "QUERY // APPLICATION INDEX", command line, table rows, selection
  inverted white. Kill: "TERMINATION PROTOCOL ARMED" band with hazard slashes,
  the target window stays lit in a red frame. Screensaver: hex rain, big crest,
  "UNIT IS WORKING" card.
- Engine fit: closest to today's bar + panel layout. Needs style delegates for
  bar, panel header and gauges, a kill-mode overlay, the ticker strip.

### B. Netrunner: street HUD
- Mood: rain-soaked neon city, the HUD floats on the wallpaper.
- Palette: red `#ff2a4a` chrome, cyan `#2ef2ff` interactive, yellow `#f7e249`
  messages, green `#3dff9e` OK, text `#e2f4ff`, panels `rgba(5,13,18,0.78)`.
- Type: Rajdhani Bold; Share Tech Mono.
- Elements: no bar; corner clusters (shield workspace badge with slanted dots,
  four slanted segmented vitals, big yellow clock with weather and net); corner
  crosshairs; cut-corner panels with a notch tab; tilted holographic diagnostics
  panel; daemon rows (crow agents) as cut-corner cards; yellow slanted
  transmission toast; quick keys with key letters; CR-0W eye sigil.
- Launcher: scanner reticle with sweep and ticks, slanted numbered results with
  READY/LOCKED chips. Kill: "FLATLINE" reticle on the window, chromatic split
  label. Screensaver: big eye sigil, "JACKED IN", three daemon cards.
- Engine fit: largest gap. Needs a "no bar" HUD layout mode (clusters instead of
  bars, exclusive zones off), perspective panels, and a wallpaper shipped with the
  pack (item_151).

### C. Deck: physical cyberdeck
- Mood: the screen is a CRT inside a hardware deck. Phosphor green, amber alerts.
- Palette: green `#39ff7a`, bright `#c8ffd8`, mid `#25b356`, dim `#16663a`,
  amber `#ffb43a`, red `#ff4d3a`, bg `#020604`; bezel metal `#1b1f23`/`#3a4148`.
- Type: VT323 (large), Share Tech Mono (body); Barlow Condensed for engraved
  bezel labels.
- Elements: metal bezel around the screen (screws, engraved labels, status LEDs,
  vent slots); the bar is a row of LCD modules in the top rail; double-rule
  terminal boxes with an inverted title cut into the top rule; ASCII meters and
  bar charts; matrix rain module; bloom and scanlines over the screen.
- Launcher: "RUN>" prompt with a big block cursor, inverted selection. Kill:
  "SIGKILL ARMED" box, ASCII reticle. Screensaver: full-screen matrix rain with an
  amber "CR-0W IS WORKING" box.
- Engine fit: maps to the existing frame (FrameBackground + bar on the frame):
  needs a frame style delegate (bezel), bar module delegates (LCD), a CRT
  post-process layer (scanlines + bloom, off with reduce motion / performance).

## Terminal match (kitty ANSI 16)
Each direction ships its own ANSI map (`kit/ansi-<direction>.kitty.conf`). crow
deck draws frames in slot 4, so slot 4 carries the pack accent: red (Megacorp),
cyan (Netrunner), mid green (Deck). Brights differ from normals. This needs the
pack-level `ansi` block of item_157; today's template copies normals into brights
and hardwires slot 4 to `blue`.

## Reproduce
- Wallpapers: `python3 -I kit/gen_walls.py walls/` (procedural, original).
- Scenes: `kit/render.sh <megacorp|netrunner|deck> desk launcher kill saver`.
- Terminal: `SHOTS=<dir> go test -run TestShots .` in cr-0w `tools/crow-deck`,
  then `bin/ansi-shot <ans> <png> --theme kit/ansi-<direction>.kitty.conf`.
