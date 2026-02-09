# Sims 4 (Lutris) – stable baseline

## Runner
- Prefer a recent Wine-GE runner in Lutris (not system wine).

## DXVK
- DXVK: ON
- VKD3D: OFF (Sims 4 is DX11)
- Esync: ON
- Fsync: OFF (baseline stability)

## Environment variables (Lutris)
Add:
- RADV_PERFTEST=gpl

Avoid:
- DXVK_ASYNC (not recommended for Sims 4 stability)

## Display
Run Lutris through Gamescope for a console-like experience:
scripts/helpers/gamescope-lutris-1080p60.sh

## In-game settings
- Fullscreen
- 1280x720 internal (Gamescope upscales to 1080p)
- VSync OFF (let Gamescope handle pacing)
