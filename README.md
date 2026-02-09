# BC-250 + Bazzite Baseline (No Hardware Tweaks)

Goal:
- Stable, reproducible baseline for BC-250 on Bazzite for TV gaming (tested with Sims 4)
- No overclocking
- No mitigations=off
- No governor stacks (Oberon / Skillfish not required)
- Idempotent scripts (safe to re-run)
- Stability > benchmarks

What this baseline does:
- Forces CEA 1080p60 output for TVs (avoids EDID / VESA issues)
- Disables zram so memory behavior is predictable
- Enables zswap (lz4) for controlled memory pressure handling
- Creates a 32 GB Btrfs swapfile at /var/swap/swapfile
- Locks AMD GPU DPM performance level to "high" (prevents clock-down stutter)
- Provides Gamescope launch helpers for Steam and Lutris

IMPORTANT:
- Commands must be run on the HOST OS
- Do NOT run inside Flatpak shells (RustDesk Flatpak, etc.)
- If you are inside a Flatpak shell, escape to host with:
  flatpak-spawn --host bash

INSTALL – COMPLETE END TO END (FOLLOW IN ORDER)

0) Clone repository and set permissions
# BC-250 + Bazzite Baseline (No Hardware Tweaks)

Goal:
- Stable, reproducible baseline for BC-250 on Bazzite for TV gaming (tested with Sims 4)
- No overclocking
- No mitigations=off
- No governor stacks (Oberon / Skillfish not required)
- Idempotent scripts (safe to re-run)
- Stability > benchmarks

What this baseline does:
- Forces CEA 1080p60 output for TVs (avoids EDID / VESA issues)
- Disables zram so memory behavior is predictable
- Enables zswap (lz4) for controlled memory pressure handling
- Creates a 32 GB Btrfs swapfile at /var/swap/swapfile
- Locks AMD GPU DPM performance level to "high" (prevents clock-down stutter)
- Provides Gamescope launch helpers for Steam and Lutris

IMPORTANT:
- Commands must be run on the HOST OS
- Do NOT run inside Flatpak shells (RustDesk Flatpak, etc.)
- If you are inside a Flatpak shell, escape to host with:
  flatpak-spawn --host bash

INSTALL – COMPLETE END TO END (FOLLOW IN ORDER)

0) Clone repository and set permissions
```bash
cd Documents
git clone https://github.com/DwarfNinjaV/bc250-bazzite-baseline.git
cd bc250-bazzite-baseline
chmod +x scripts/*.sh scripts/helpers/*.sh
```
1) Verify you are running on the host OS
```bash
./scripts/00-check-host.sh
```
This must succeed. If it fails, STOP.

2) Apply kernel arguments (display + disable zram + enable zswap)

NOTE: This step REQUIRES a reboot.
```bash
sudo ./scripts/10-kargs-display-zram-zswap.sh
systemctl reboot
```
3) AFTER REBOOT – create and enable the 32 GB swapfile
```bash
sudo ./scripts/20-swapfile-btrfs.sh
```
This creates:
- /var/swap/swapfile (32 GB)
- Enables it immediately
- Persists it in /etc/fstab
- Sets sane swappiness for gaming

4) Install and enable GPU DPM performance lock (recommended)
```bash
sudo ./scripts/30-gpu-dpm-high.sh --install-service
sudo systemctl enable --now bc250-gpu-dpm-high.service
```
This prevents GPU downclock stutter common on BC-250.

5) Verify everything is applied correctly
```bash
./scripts/40-verify.sh
```
Expected results:
- systemd.zram=0 present in kernel args
- zram module NOT loaded
- swapfile active (~32 GB)
- display reports 1920x1080
- GPU DPM performance level = high

TV SETTINGS (REQUIRED – NOT OPTIONAL)

On the HDMI input used by the BC-250:
- Overscan: OFF / 0%
- Aspect ratio: Just Scan / Screen Fit / 1:1
- Label HDMI input as PC if available

If screen edges are cut off, this is a TV configuration issue.

GAMESCOPE LAUNCH HELPERS (OPTIONAL BUT RECOMMENDED)

Steam:
```bash
scripts/helpers/gamescope-steam-1080p60.sh
```
Lutris:
```bash
scripts/helpers/gamescope-lutris-1080p60.sh
```
These force 1080p60 output to the TV and allow lower internal render resolution.

SIMS 4 – LUTRIS BASELINE CONFIGURATION

Runner:
- Wine-GE (not system wine)

Graphics / Runtime:
- DXVK: ON
- VKD3D: OFF
- Esync: ON
- Fsync: OFF

Environment variable:
RADV_PERFTEST=gpl

In-game settings:
- Fullscreen
- 1280x720 internal resolution
- VSync OFF (Gamescope handles pacing)

MANUAL VERIFICATION COMMANDS

Check kernel args:
```bash
rpm-ostree kargs
```
Check zram:
```bash
lsmod | grep -i zram || echo "zram module not loaded"
```
Check swap:
```bash
swapon --show
cat /proc/swaps
```
Check swappiness:
```bash
sysctl vm.swappiness
```
Check GPU DPM level:
```bash
cat /sys/class/drm/card0/device/power_dpm_force_performance_level
```
ROLLBACK / RECOVERY

View kernel args:
```bash
rpm-ostree kargs
```
Disable GPU DPM service:
```bash
sudo systemctl disable --now bc250-gpu-dpm-high.service
```
Remove swapfile:
```bash
sudo swapoff /var/swap/swapfile
sudo sed -i '\|/var/swap/swapfile|d' /etc/fstab
sudo rm -f /var/swap/swapfile
sudo rmdir /var/swap 2>/dev/null || true
```
COMMON PROBLEMS

sudo not found:
- You are inside a Flatpak shell
- Run: flatpak-spawn --host bash

zram still active:
- Kernel args not applied or reboot skipped

Display cropped:
- TV overscan still enabled
```bash
git clone https://github.com/DwarfNinjaV/bc250-bazzite-baseline.git
cd bc250-bazzite-baseline
chmod +x scripts/*.sh scripts/helpers/*.sh
```
1) Verify you are running on the host OS
```bash
./scripts/00-check-host.sh
```
This must succeed. If it fails, STOP.

2) Apply kernel arguments (display + disable zram + enable zswap)

NOTE: This step REQUIRES a reboot.
```bash
sudo ./scripts/10-kargs-display-zram-zswap.sh
systemctl reboot
```
3) AFTER REBOOT – create and enable the 32 GB swapfile
```bash
sudo ./scripts/20-swapfile-btrfs.sh
```
This creates:
- /var/swap/swapfile (32 GB)
- Enables it immediately
- Persists it in /etc/fstab
- Sets sane swappiness for gaming

4) Install and enable GPU DPM performance lock (recommended)
```bash
sudo ./scripts/30-gpu-dpm-high.sh --install-service
sudo systemctl enable --now bc250-gpu-dpm-high.service
```
This prevents GPU downclock stutter common on BC-250.

5) Verify everything is applied correctly
```bash
./scripts/40-verify.sh
```
Expected results:
- systemd.zram=0 present in kernel args
- zram module NOT loaded
- swapfile active (~32 GB)
- display reports 1920x1080
- GPU DPM performance level = high

TV SETTINGS (REQUIRED – NOT OPTIONAL)

On the HDMI input used by the BC-250:
- Overscan: OFF / 0%
- Aspect ratio: Just Scan / Screen Fit / 1:1
- Label HDMI input as PC if available

If screen edges are cut off, this is a TV configuration issue.

GAMESCOPE LAUNCH HELPERS (OPTIONAL BUT RECOMMENDED)

Steam:
```bash
scripts/helpers/gamescope-steam-1080p60.sh
```
Lutris:
```bash
scripts/helpers/gamescope-lutris-1080p60.sh
```
These force 1080p60 output to the TV and allow lower internal render resolution.

SIMS 4 – LUTRIS BASELINE CONFIGURATION

Runner:
- Wine-GE (not system wine)

Graphics / Runtime:
- DXVK: ON
- VKD3D: OFF
- Esync: ON
- Fsync: OFF

Environment variable:
RADV_PERFTEST=gpl

In-game settings:
- Fullscreen
- 1280x720 internal resolution
- VSync OFF (Gamescope handles pacing)

MANUAL VERIFICATION COMMANDS

Check kernel args:
```bash
rpm-ostree kargs
```
Check zram:
```bash
lsmod | grep -i zram || echo "zram module not loaded"
```
Check swap:
```bash
swapon --show
cat /proc/swaps
```
Check swappiness:
```bash
sysctl vm.swappiness
```
Check GPU DPM level:
```bash
cat /sys/class/drm/card0/device/power_dpm_force_performance_level
```
ROLLBACK / RECOVERY

View kernel args:
```bash
rpm-ostree kargs
```
Disable GPU DPM service:
```bash
sudo systemctl disable --now bc250-gpu-dpm-high.service
```
Remove swapfile:
```bash
sudo swapoff /var/swap/swapfile
sudo sed -i '\|/var/swap/swapfile|d' /etc/fstab
sudo rm -f /var/swap/swapfile
sudo rmdir /var/swap 2>/dev/null || true
```
COMMON PROBLEMS

sudo not found:
- You are inside a Flatpak shell
- Run: flatpak-spawn --host bash

zram still active:
- Kernel args not applied or reboot skipped

Display cropped:
- TV overscan still enabled
