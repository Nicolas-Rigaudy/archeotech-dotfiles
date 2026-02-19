# Fedora Boot Fix Scripts

Scripts for troubleshooting Fedora dual-boot issues when booting from Arch's GRUB.

## Current Status

⚠️ **Partially Working** - Fedora boots from GRUB but shows wrong desktop environment

**Recommendation:** Use BIOS boot menu to boot Fedora (works perfectly)

## Scripts

### diagnose-fedora-boot.sh
Diagnoses Fedora boot configuration by checking:
- Btrfs subvolume layout
- Fedora's `/etc/fstab` entries
- UUID mismatches

Usage:
```bash
./diagnose-fedora-boot.sh
```

### fix-fedora-fstab.sh
Fixes Fedora's `/boot` UUID in fstab to point to shared boot partition.

Changes: `UUID=ea89ad85...` → `UUID=031889ca...`

Usage:
```bash
./fix-fedora-fstab.sh
```

### fix-fedora-efi.sh
Fixes Fedora's `/boot/efi` UUID in fstab to point to shared EFI partition.

Changes: `UUID=3020-44F9` → `UUID=1788-AEB3`

Usage:
```bash
./fix-fedora-efi.sh
```

## What Works

- ✅ Fedora kernel loads from shared `/boot` (nvme0n1p3)
- ✅ Root filesystem mounts (nvme0n1p7, subvol=root)
- ✅ Login screen appears, password accepted

## What Doesn't Work

- ❌ Shows Arch's plain SDDM instead of Fedora's KDE
- ❌ Desktop environment fails to start after login

## GRUB Configuration

The custom GRUB entries are in:
```
system/etc/grub.d/40_custom
```

Deploy with:
```bash
./scripts/update-system-configs.sh
```

## Workaround

**Just use BIOS boot menu** to boot Fedora - it works perfectly!

1. Reboot
2. Press F9 (or your BIOS boot key)
3. Select "Fedora"
4. Boots into Fedora KDE normally

## Future Investigation

If you want to revisit this:
1. Check why Arch's SDDM is loaded instead of Fedora's
2. Investigate systemd service initialization order
3. Consider systemd-boot as alternative to GRUB for Fedora
4. Check if display manager needs special kernel parameter

---

**Last Updated:** 2025-12-09
