#!/usr/bin/env bash
# Installs the Thomsen Plymouth theme (Arch-based). Run: sudo bash install.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "Run as root: sudo bash install.sh"; exit 1; }

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="/usr/share/plymouth/themes/thomsen"

command -v plymouth-set-default-theme >/dev/null 2>&1 || { echo "Plymouth not installed. Run: sudo pacman -S plymouth"; exit 1; }

mkdir -p "$DEST"
cp "$SRC"/*.png "$SRC"/thomsen.plymouth "$SRC"/thomsen.script "$DEST"/

# 1) add the plymouth hook to mkinitcpio (after udev or systemd)
CONF=/etc/mkinitcpio.conf
if [ -f "$CONF" ] && ! grep -E '^HOOKS=' "$CONF" | grep -q plymouth; then
  cp "$CONF" "$CONF.bak"
  if grep -E '^HOOKS=' "$CONF" | grep -q systemd; then
    sed -i -E '/^HOOKS=/ s/\bsystemd\b/systemd plymouth/' "$CONF"
  else
    sed -i -E '/^HOOKS=/ s/\budev\b/udev plymouth/' "$CONF"
  fi
  echo "Added plymouth hook to $CONF (backup: $CONF.bak)"
fi

# 2) add quiet splash to the kernel command line
GCFG=/etc/default/grub
if [ -f "$GCFG" ] && ! grep -E '^GRUB_CMDLINE_LINUX_DEFAULT=' "$GCFG" | grep -q splash; then
  cp "$GCFG" "$GCFG.bak-plymouth"
  sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ s/"$/ quiet splash"/' "$GCFG"
  echo "Added 'quiet splash' to $GCFG (backup: $GCFG.bak-plymouth)"
fi

# 3) set theme + rebuild initramfs, then regenerate grub
plymouth-set-default-theme -R thomsen
if command -v update-grub >/dev/null 2>&1; then update-grub
elif command -v grub-mkconfig >/dev/null 2>&1; then grub-mkconfig -o /boot/grub/grub.cfg; fi

echo "Done. Reboot to see the splash. Press Esc during boot to see text output."
