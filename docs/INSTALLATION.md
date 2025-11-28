# Installation Guide

Complete step-by-step guide to install Arch Linux + Hyprland desktop environment from scratch.

> **Warning:** This guide assumes you're comfortable with the command line and understand the risks of partitioning. Always backup your data before proceeding.

---

## Table of Contents

- [Pre-Installation](#pre-installation)
- [Base Arch Installation](#base-arch-installation)
- [Post-Installation Setup](#post-installation-setup)
- [Hyprland Installation](#hyprland-installation)
- [Application Installation](#application-installation)
- [Theming](#theming)
- [Final Configuration](#final-configuration)
- [Post-Install Checklist](#post-install-checklist)

---

## Pre-Installation

### Requirements

- USB drive (4GB minimum)
- Internet connection
- UEFI-capable system
- Free disk space (50GB minimum, 100GB+ recommended)

### 1. Download Arch Linux ISO

```bash
# Download from: https://archlinux.org/download/
# Verify the signature (recommended)
```

### 2. Create Bootable USB

**On Linux:**
```bash
dd if=archlinux-*.iso of=/dev/sdX bs=4M status=progress && sync
```

**On Windows:**
- Use Rufus or Etcher

### 3. Boot Settings

1. Enter BIOS/UEFI (usually F2, F10, F12, or Del during boot)
2. Disable Secure Boot
3. Set boot mode to UEFI
4. Save and boot from USB

---

## Base Arch Installation

### 1. Verify Boot Mode

```bash
# Should show /sys/firmware/efi (means UEFI mode)
ls /sys/firmware/efi/efivars
```

### 2. Connect to Internet

**WiFi:**
```bash
iwctl
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect "SSID"
[iwd]# exit

# Test connection
ping archlinux.org
```

**Ethernet:**
Connection should be automatic.

### 3. Update System Clock

```bash
timedatectl set-ntp true
timedatectl status
```

### 4. Partition Disk

> **Note:** Adjust partitioning based on your needs. This guide assumes a dedicated Arch installation.

**View disks:**
```bash
lsblk
fdisk -l
```

**Partition with `fdisk` or `cfdisk`:**

For a typical setup on `/dev/nvme0n1`:

```bash
cfdisk /dev/nvme0n1
```

**Recommended layout:**
- `/dev/nvme0n1p1` - EFI partition (512MB, type: EFI System)
- `/dev/nvme0n1p2` - Root partition (remaining space, type: Linux filesystem)
- Optional: Separate home partition

**For dual-boot:** Use existing EFI partition, don't create a new one.

### 5. Format Partitions

**EFI partition (only if new, skip if dual-booting):**
```bash
mkfs.fat -F32 /dev/nvme0n1p1
```

**Root partition (btrfs with subvolumes):**
```bash
mkfs.btrfs /dev/nvme0n1p2

# Mount and create subvolumes
mount /dev/nvme0n1p2 /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
btrfs subvolume create @snapshots
btrfs subvolume create @cache
btrfs subvolume create @log

cd /
umount /mnt

# Mount subvolumes
mount -o subvol=@,compress=zstd,noatime /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/cache,var/log}
mount -o subvol=@home,compress=zstd,noatime /dev/nvme0n1p2 /mnt/home
mount -o subvol=@snapshots,compress=zstd,noatime /dev/nvme0n1p2 /mnt/.snapshots
mount -o subvol=@cache,compress=zstd,noatime /dev/nvme0n1p2 /mnt/var/cache
mount -o subvol=@log,compress=zstd,noatime /dev/nvme0n1p2 /mnt/var/log
mount /dev/nvme0n1p1 /mnt/boot/efi
```

### 6. Install Base System

```bash
pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode btrfs-progs networkmanager vim nano
```

### 7. Generate fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab  # Verify
```

### 8. Chroot into System

```bash
arch-chroot /mnt
```

### 9. System Configuration

**Set timezone:**
```bash
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc
```

**Localization:**
```bash
# Edit /etc/locale.gen and uncomment needed locales
nano /etc/locale.gen
# Uncomment: en_US.UTF-8 UTF-8

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

**Hostname:**
```bash
echo "archeotech" > /etc/hostname

# Edit /etc/hosts
cat > /etc/hosts << EOF
127.0.0.1    localhost
::1          localhost
127.0.1.1    archeotech.localdomain archeotech
EOF
```

**Root password:**
```bash
passwd
```

### 10. Install Bootloader (GRUB)

```bash
pacman -S grub efibootmgr os-prober

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

# For dual-boot, enable os-prober
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

# Generate GRUB config
grub-mkconfig -o /boot/grub/grub.cfg
```

### 11. Enable NetworkManager

```bash
systemctl enable NetworkManager
```

### 12. Create User

```bash
useradd -m -G wheel,storage,power,audio,video -s /bin/bash yourusername
passwd yourusername

# Enable sudo
EDITOR=nano visudo
# Uncomment: %wheel ALL=(ALL:ALL) ALL
```

### 13. Exit and Reboot

```bash
exit
umount -R /mnt
reboot
```

Remove the USB drive during reboot.

---

## Post-Installation Setup

### 1. Connect to Internet

```bash
# WiFi
nmcli device wifi connect "SSID" password "password"

# Or use nmtui for GUI
nmtui
```

### 2. Update System

```bash
sudo pacman -Syu
```

### 3. Install AUR Helper (paru)

```bash
sudo pacman -S git

cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

---

## Hyprland Installation

### 1. Install Hyprland and Core Components

```bash
sudo pacman -S hyprland hyprlock hypridle \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    wayland wayland-protocols \
    sddm qt5-wayland qt6-wayland
```

### 2. Install Desktop Components

```bash
sudo pacman -S waybar rofi-wayland dunst \
    swww wlogout wl-clipboard cliphist \
    grim slurp \
    brightnessctl playerctl pavucontrol \
    bluez bluez-utils blueman \
    networkmanager nm-applet
```

### 3. Enable Services

```bash
sudo systemctl enable sddm
sudo systemctl enable bluetooth
```

---

## Application Installation

### 1. Terminal and Shell

```bash
# Terminal
sudo pacman -S kitty

# Fish shell
sudo pacman -S fish
chsh -s /usr/bin/fish

# Fish tools
sudo pacman -S starship eza bat btop fastfetch
paru -S zoxide thefuck yazi
```

### 2. Applications

```bash
# File manager
sudo pacman -S thunar thunar-volman gvfs thunar-archive-plugin

# Media viewers
sudo pacman -S imv zathura zathura-pdf-mupdf mpv

# Archive tools
sudo pacman -S file-roller unzip unrar p7zip

# Browser
paru -S zen-browser

# Code editor
paru -S visual-studio-code-bin

# Notes
paru -S obsidian
```

### 3. Development Tools

```bash
# Git and GitHub CLI
sudo pacman -S git github-cli

# Python
sudo pacman -S python python-pip

# Docker
sudo pacman -S docker docker-compose
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Cloud tools (optional)
paru -S aws-cli-v2 terraform
```

---

## Theming

### 1. Install Fonts

```bash
sudo pacman -S ttf-firacode-nerd noto-fonts noto-fonts-emoji
```

### 2. Install GTK Theme

```bash
paru -S catppuccin-gtk-theme-macchiato papirus-icon-theme
```

### 3. Install Cursor Theme

```bash
paru -S catppuccin-cursors-macchiato
```

### 4. Install SDDM Theme

```bash
paru -S sddm-catppuccin-git

# Configure SDDM
sudo nano /etc/sddm.conf
# Add:
# [Theme]
# Current=catppuccin-macchiato
```

### 5. Apply Themes

**GTK:**
```bash
# GTK3
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=catppuccin-macchiato-mauve-standard+default
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=catppuccin-macchiato-dark-cursors
EOF

# GTK4
mkdir -p ~/.config/gtk-4.0
ln -sf ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini
```

---

## Final Configuration

### 1. Clone Dotfiles

```bash
cd ~/Projects
git clone https://github.com/Nicolas-Rigaudy/archeotech-dotfiles.git
cd archeotech-dotfiles
```

### 2. Deploy Configs (Manual Method)

> **Note:** Automated script coming soon!

```bash
# Backup existing configs
mkdir -p ~/config-backup
cp -r ~/.config/{hypr,waybar,kitty,rofi,fish,starship.toml} ~/config-backup/

# Copy dotfiles configs
# TODO: This will be automated in restore.sh
```

### 3. Configure Audio

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa wireplumber sof-firmware

# Start audio services
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
```

### 4. Reboot

```bash
reboot
```

You should now boot into SDDM with Catppuccin theme and log into Hyprland!

---

## Post-Install Checklist

After first boot into Hyprland:

- [ ] Audio works (test with `pavucontrol`)
- [ ] WiFi/Ethernet connects
- [ ] Bluetooth works (test with `blueman-manager`)
- [ ] Brightness keys work
- [ ] Volume keys work
- [ ] Screenshot works (`Super + S`)
- [ ] All keybindings respond (see [KEYBINDS.md](KEYBINDS.md))
- [ ] Waybar displays correctly
- [ ] Rofi launcher works (`Super + R`)
- [ ] Terminal opens (`Super + Q`)
- [ ] Lock screen works (`Super + L`)
- [ ] Monitor setup correct (check with `hyprctl monitors`)

---

## Troubleshooting

### Audio Not Working

```bash
# Install SOF firmware
sudo pacman -S sof-firmware
reboot
```

### SDDM Shows Wrong Keyboard Layout

```bash
# Create Xsetup script
sudo nano /usr/share/sddm/scripts/Xsetup
# Add: setxkbmap fr  # Or your layout
sudo chmod +x /usr/share/sddm/scripts/Xsetup
```

### Hyprland Keybinds Don't Match Layout

Add to `~/.config/hypr/hyprland.conf`:
```conf
input {
    resolve_binds_by_sym = true
}
```

### Clipboard History Empty

Add to `~/.config/hypr/hyprland.conf`:
```conf
exec-once = wl-paste --type text --watch cliphist store
exec-once = wl-paste --type image --watch cliphist store
```

---

## Next Steps

1. **Customize configs:** Explore `.config/hypr/hyprland.conf` for your preferences
2. **Add wallpapers:** Place wallpapers in `~/Pictures/Wallpapers/`
3. **Install work tools:** AWS CLI, Terraform, Docker containers, etc.
4. **Backup system:** Create snapshots with btrfs or timeshift

---

## Useful Resources

- [Arch Wiki](https://wiki.archlinux.org/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [This Project's README](../README.md)

---

**Last Updated:** 2025-11-28
**Estimated Install Time:** 2-4 hours (depending on experience)
**For:** archeotech-dotfiles
