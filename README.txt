THOMSEN PLYMOUTH THEME (system boot splash)

Install (Arch):  sudo pacman -S plymouth   then   sudo bash install.sh
Then reboot.

Quick test without rebooting (run from a text console, Ctrl+Alt+F3):
  sudo plymouthd; sudo plymouth --show-splash; sleep 8; sudo plymouth quit

Uninstall: remove "plymouth" from HOOKS in /etc/mkinitcpio.conf, remove "quiet splash"
from /etc/default/grub, then: sudo mkinitcpio -P && sudo grub-mkconfig -o /boot/grub/grub.cfg

Scales automatically with screen resolution (designed at 1080p).
Change the logo: replace logo.png (square, transparent) and re-run install.sh.
