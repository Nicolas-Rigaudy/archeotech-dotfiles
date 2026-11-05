# Screensaver research (2026-11-05)

Input for `req_012` (screensaver engine) and its items 161-165. Web research, one
pass; licences and maintenance status were read from the listings named below,
not from each repo. Re-check a tool's licence before shipping a source for it.

## Source kinds the engine should support

| Kind | How it runs | Examples |
|---|---|---|
| `qml` | Scene inside the shell's fullscreen layer | clocks, OrbitViz, glance board, wallpaper slideshow |
| `shader` | Qt `ShaderEffect` in the same layer (GLSL compiled to `.qsb` with `qsb`; Shadertoy code needs a small wrapper for `iTime`/`iResolution`) | fractals, plasma, fluid, starfields |
| `terminal` | Fullscreen kitty window + compositor rule (layer-shell cannot host a terminal) | cmatrix, termflix, astroterm |
| `program` | Any fullscreen Wayland/GL program, same window rule as terminal | gource, mpv video, xscreensaver hacks via Xwayland |
| `web` | WebEngine view, sandboxed, off by default | WebGL demos, a status page |

`shader` and `program` are new compared to the 2026-11-03 hub decision.
`shader` is the best fit for the shell: no external process, GPU-cheap, themable
through uniforms (accent, surface colours from tokens), and it renders in shot.sh.

## Terminal animations (beyond the hub list)

The hub already listed cmatrix/unimatrix, pipes.sh, asciiquarium, cbonsai,
tty-clock, ASCII Star Wars and ascii-magic.

- **termflix** (Rust, MIT): about 60 procedural animations in one binary (fire,
  matrix rain, starfield, Game of Life, globe...) and a `--screensaver` flag that
  exits on key or focus change. One package gives a whole shuffle pool.
- **termsaver** (Python): a classic multi-screen pack (starwars, matrix, quotes).
- **bash-screensavers** (attogram, pure Bash): life, rain, stars; zero deps.
- **gh-screensaver** (vilmibm, gh extension): fireworks, starfield, pipes,
  pollock, life.
- **astroterm** (C, MIT): real-time star map for a date, time and location, from
  the Yale Bright Star Catalog and JPL elements. Use the owner's location.
- **Rotating globes**: DocAtPrompt/globe (live day/night terminator, city
  lights, clouds), adamsky/globe (Rust, spins in the background), `npx ascii-globe --animate`.
- Index for more: mcthomas/awesome-terminal-art.

## Shader and Wayland-native references

- **hyprsaver** (Rust, MIT, AUR): Wayland-native screensaver, fractal shaders on
  layer-shell overlays, Shadertoy-style code, triggered by hypridle. The closest
  existing project to the `shader` kind; read it before building item_162.
- Shader wallpapers that accept Shadertoy code: neowall, shaderbg (GPL-3.0),
  glpaper, wewa (37 built-in Shadertoy shaders), wayggle-bg. Useful as shader
  sources and to check how they map Shadertoy uniforms.
- No Quickshell-based screensaver was found: the engine is a real gap.

## Programs

- **gource**: OpenGL visualisation of a repo's history as a growing tree with
  contributors flying around; fullscreen flag, `--auto-skip-seconds` and `-s` for a
  continuous loop. Dev-flavoured and on-brand: with Contexts (0.70) it can play the
  active project's repo. Needs a wrapper (no screensaver mode of its own).
- **xscreensaver hacks** under Xwayland (`xwayland-run`): mostly works, reported
  unreliable; xscreensaver's locking is disabled on Wayland anyway (lock stays
  hyprlock/swaylock). wscreensaver (layer-shell fork) is unmaintained, about half the
  hacks fail. Treat as optional, best effort.
- mpv with a local video folder (the owner's own clips) is a trivial `program`.

## Original QML scene ideas (for the item_161 mockups)

These are ideas, not research findings:
- **Glance board** (StandBy-style): large clock, next calendar event, weather,
  battery, unread notifications count; dim and slow-moving to avoid burn-in.
- **Wallpaper drift**: slow Ken Burns pan across the wallpaper library with the
  palette crossfading per image.
- **Dev radar at rest**: OrbitViz fed by live data (network/Bluetooth nodes, CI
  status, crow runs), the canvas work from req_004/req_010 reused.
- **Flip clock** in the shell's type and tokens.
- **Theme-aware shaders**: one plasma/aurora shader whose uniforms come from the
  accent and surface tokens, so it follows family/flavor/accent and packs.

## Sources
- https://terminaltrove.com/categories/screensavers/
- https://docs.rs/crate/termflix/0.7.2 and https://lib.rs/crates/termflix
- https://alternativeto.net/software/unimatrix
- https://awesome.ecosyste.ms/projects/github.com%2Fmcthomas%2Fawesome-terminal-art
- https://awesome.ecosyste.ms/projects/github.com%2Fattogram%2Fbash-screensavers
- https://github.com/da-luce/astroterm (via https://terminaltrove.com/astroterm/)
- https://github.com/DocAtPrompt/globe, https://awesome.ecosyste.ms/projects/github.com%2Fadamsky%2Fglobe
- https://aur.archlinux.org/packages/hyprsaver, https://docs.rs/crate/hyprsaver/latest/source/README.md
- https://github.com/1ay1/neowall/wiki, https://aur.archlinux.org/packages/shaderbg, https://github.com/ownself/wewa
- https://man.archlinux.org/man/gource.1.en.txt
- https://bugs.gentoo.org/696156, https://discuss.cachyos.org/t/xscreensaver-and-wayland-plasma/29266, https://freshports.org/x11/wscreensaver, https://lwn.net/Articles/1027781/
