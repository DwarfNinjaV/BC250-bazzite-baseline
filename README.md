# BC-250 + Bazzite Baseline (No Hardware Tweaks)

This repo applies a stable, reproducible baseline for BC-250 gaming on Bazzite:

- Forces **CEA 1080p60** output for TVs (avoids VESA/EDID issues)
- Disables **zram** so memory behavior is predictable
- Enables **zswap (lz4)** for controlled memory pressure handling
- Creates a **32G Btrfs swapfile** at `/var/swap/swapfile`
- Locks AMD GPU **DPM performance level to `high`** (prevents downclock stutter)
- Provides **Gamescope launch helpers** for Steam and Lutris

---

## Safety / Philosophy

- No overclocking
- No `mitigations=off`
- No governor stacks (Oberon / Skillfish not required)
- Idempotent scripts (safe to re-run)
- Stability > benchmarks

This is meant to be **boring and reliable**, especially for TV gaming.

---

## Prerequisites

- **Bazzite** (rpm-ostree based)
- Run on the **HOST OS**
  - ❌ Do **not** run inside Flatpak shells (RustDesk Flatpak, etc.)
  - If needed: `flatpak-spawn --host bash`

---

## Quick Start

### 1) Clone and prepare
```bash
git clone https://github.com/DwarfNinjaV/bc250-bazzite-baseline.git
cd bc250-bazzite-baseline
chmod +x scripts/*.sh scripts/helpers/*.sh
