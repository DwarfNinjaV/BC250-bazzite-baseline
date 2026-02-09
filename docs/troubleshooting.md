# Troubleshooting

## "sudo not found" / "rpm-ostree not found"
You are probably inside a Flatpak/container shell (common with RustDesk flatpak).
Run:
flatpak-spawn --host bash

## zram still active after applying kargs
Check:
rpm-ostree kargs
You must see: systemd.zram=0
Then reboot.

## TV edges cut off (overscan)
On TV input:
- Overscan OFF / 0%
- Aspect ratio "Just Scan" / "Screen Fit" / "1:1"
- Label HDMI input as "PC" if available

## Swapfile not active
Check:
swapon --show
If missing, re-run scripts/20-swapfile-btrfs.sh
