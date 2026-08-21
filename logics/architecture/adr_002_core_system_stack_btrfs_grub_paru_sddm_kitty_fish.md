## adr_002_core_system_stack_btrfs_grub_paru_sddm_kitty_fish - Core system stack: btrfs, GRUB, paru, SDDM, kitty, fish
> Date: 2026-08-20
> Status: Proposed
> Related request: (none yet)
> Related backlog: (none yet)
> Related task: (none yet)
> Drivers: Bootstrap decisions for the Arch install that trade convenience/familiarity against setup ceremony.
> Reminder: Update status, linked refs, decision rationale, consequences, and follow-up work when you edit this doc.

# Overview
- Standardise on btrfs subvolumes, GRUB, paru, SDDM, kitty and fish as the base system components.

# Context
- btrfs subvolume layout @, @home, @snapshots, @cache, @log lets snapper snapshot data only (no caches/logs).
- GRUB was originally chosen for Fedora dual-boot auto-detection; dual-boot is now gone but GRUB stays (themed, documented, stable).
- SDDM has the best Wayland support and is Qt-native with Catppuccin themes.

# Decision
- Filesystem btrfs over ext4 with the subvolume layout above.
- Bootloader GRUB (themed Catppuccin) over systemd-boot; AUR helper paru over yay.
- Display manager SDDM; terminal kitty (GPU-accelerated, image protocol for yazi previews); interactive shell fish.

# Consequences
- More setup ceremony than ext4; slower boot and more config surface than systemd-boot.
- fish is non-POSIX — bash scripts run via shebang, fish handles the interactive shell only.
- SDDM /etc/sddm.conf is root-owned so it cannot be stowed — tracked at system/etc/sddm.conf and deployed via scripts/update-system-configs.sh (manual deploy step).

# References
- Related request: (none yet)
- Related backlog: (none yet)
- Related task: (none yet)
