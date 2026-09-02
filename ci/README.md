# CI — compositor config testing

Reproducible, **isolated** testing for the compositor configs, so a change can be
validated without risking the live session.

## Why containers

Validating a Wayland compositor config means running the compositor binary
(`Hyprland --verify-config`). Doing that on the host is dangerous: a stray full
boot once crashed the live session to SDDM and knocked out Bluetooth audio
(autostart programs collide over the shared session bus / `XDG_RUNTIME_DIR`). A
container gives the compositor its **own** runtime dir, D-Bus, and user — it
physically cannot touch your session. It's also the exact environment CI uses, so
_passes locally_ ⇒ _passes CI_.

## Scripts

| Script | Runs | Purpose |
|--------|------|---------|
| `hyprland-verify-native.sh <conf>` | inside an Arch box with Hyprland | the actual check — `Hyprland --verify-config`, fails on hard `invalid field` errors, warns on deprecations. Shared by local + CI. |
| `verify-compositor-configs.sh` | your machine (needs Docker) | spins a throwaway Arch container and runs the native check on `config/.config/hypr/hyprland.conf`. |

```sh
ci/verify-compositor-configs.sh      # local, isolated, needs docker + --network host
```

CI runs the same `hyprland-verify-native.sh` directly inside an Arch container —
see [`.github/workflows/compositor-config.yml`](../.github/workflows/compositor-config.yml).

## Verdict semantics

- **hard error** (`invalid field …`) → exit 1. The compositor cannot parse the
  directive; it will error on login.
- **deprecation notice** → printed, non-fatal. The directive still works.
  (On Hyprland 0.56.2, window rules must use `windowrulev2`; the modern
  `windowrule` form is rejected — hence the deprecation notices are expected.)

## Known gaps / next

- **Headless *rendering*** of Hyprland in-container is not yet solved (its
  aquamarine backend won't init without a DRM session), so this is config-lint
  only today. The shell itself is render-tested separately via the shell repo's
  `scripts/shot.sh` (nested headless mango). Unifying these into full
  visual-regression CI is tracked as backlog **item_068**.
- MangoWC config linting (mango has no `--verify-config` equivalent) — TBD.
