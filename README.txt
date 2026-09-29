# 🎨 Thomsen Plymouth Theme

![Thomsen Plymouth Theme Preview](preview.png)

An animated, custom Plymouth boot splash theme built for **Fedora Linux**.

---

## 🛠️ Requirements

This theme relies on Plymouth's script plugin engine to render graphics during startup:

- **Fedora Linux** (or any Dracut-based Linux distribution)
- `plymouth-plugin-script` package


## 📖 Manual Installation

### 1. Install dependencies
```bash
sudo dnf install -y plymouth-plugin-script
```

### 2. Copy theme files
```bash
sudo mkdir -p /usr/share/plymouth/themes/Thomsen-Plymouth-Theme
sudo cp -r ./* /usr/share/plymouth/themes/Thomsen-Plymouth-Theme/
```

### 3. Set standard theme
```bash
sudo plymouth-set-default-theme Thomsen-Plymouth-Theme
```

### 4. Rebuild initramfs
```bash
sudo dracut --regenerate-all --force
```

---

## ⚙️ Kernel Configuration

Plymouth requires `rhgb` (Red Hat Graphical Boot) and `quiet` parameters in your boot configuration.

1. Check if parameters are active:
   ```bash
   cat /proc/cmdline
   ```

2. Enable them if missing:
   ```bash
   sudo grubby --update-kernel=ALL --args="rhgb quiet"
   ```

---

## 🛠️ Troubleshooting

### Black Screen or Late Graphics Load (NVIDIA GPUs)
Enable DRM Kernel Mode Setting (KMS) so graphics drivers load early in `initramfs`:
```bash
sudo grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"
sudo dracut --regenerate-all --force
```

### Plymouth Skips Directly to Login Screen
On fast NVMe SSDs, disable Plymouth's display delay by adding `ShowDelay=0` under `[Daemon]` in `/etc/plymouth/plymouthd.conf`:
```ini
[Daemon]
Theme=Thomsen-Plymouth-Theme
ShowDelay=0
```
Then regenerate initramfs:
```bash
sudo dracut --regenerate-all --force
```

---
