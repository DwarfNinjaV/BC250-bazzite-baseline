# BC-250 + Bazzite Baseline (No Hardware Tweaks)

This repo applies a stable, reproducible baseline for BC-250 gaming on Bazzite:
- Forces CEA 1080p60 output for TVs (no VESA weird modes)
- Disables zram (so memory behavior is predictable)
- Enables zswap (lz4) for better memory pressure handling
- Creates an optional 32G btrfs swapfile at /var/swap/swapfile
- Locks AMD DPM performance level to `high` (reduces clock-down stutter)
- Provides Gamescope launch helpers for Steam and Lutris

## Safety / philosophy
- No overclocking
- No "mitigations=off"
- No governor stacks (oberon/skillfish) required
- Idempotent scripts (safe to re-run)

## Prereqs
- You must run these scripts on the HOST, not inside a Flatpak sandbox.
- Bazzite (rpm-ostree based).

## Quick start

### 1) Clone
```bash
git clone https://github.com/<you>/bc250-bazzite-baseline.git
cd bc250-bazzite-baseline
chmod +x scripts/*.sh scripts/helpers/*.sh
