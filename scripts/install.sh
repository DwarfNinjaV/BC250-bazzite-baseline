#!/usr/bin/env bash
set -euo pipefail

# BC-250 + Bazzite Baseline Installer
# - Phase 1: apply rpm-ostree kargs (requires reboot)
# - Phase 2: create/enable 32G swapfile + optional DPM service

die() { echo "ERROR: $*" >&2; exit 1; }

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Refuse Flatpak sandbox
if [[ -n "${FLATPAK_ID-}" ]]; then
  die "Detected Flatpak sandbox. Run on host terminal or: flatpak-spawn --host bash"
fi

command -v rpm-ostree >/dev/null 2>&1 || die "rpm-ostree not found (not on host / not rpm-ostree OS)."
command -v systemctl  >/dev/null 2>&1 || die "systemctl not found."

# Config (override via env)
OUTPUT="${OUTPUT:-DP-1}"
CEA_MODE="${CEA_MODE:-1920x1080@60e}"
SWAP_SIZE="${SWAP_SIZE:-32G}"
SWAPPINESS="${SWAPPINESS:-60}"

echo "== BC-250 Baseline Installer =="
echo "OUTPUT=${OUTPUT}"
echo "CEA_MODE=${CEA_MODE}"
echo "SWAP_SIZE=${SWAP_SIZE}"
echo "SWAPPINESS=${SWAPPINESS}"
echo

# Phase 1: ensure required kargs exist
echo ">> Applying kargs (display + zram off + zswap)..."
sudo OUTPUT="${OUTPUT}" CEA_MODE="${CEA_MODE}" "${ROOT_DIR}/scripts/10-kargs-display-zram-zswap.sh"

echo
echo ">> Checking whether a reboot is required..."
if rpm-ostree status | grep -qi "PendingDeployment"; then
  echo "Reboot required to apply rpm-ostree changes."
  echo "Run: systemctl reboot"
  exit 0
fi

# If no pending deployment reported, we still recommend reboot after kargs change.
echo "NOTE: If this is the first time applying kargs, reboot is recommended."
echo

# Phase 2: swapfile (default ON)
echo ">> Creating/enabling swapfile..."
sudo SWAP_SIZE="${SWAP_SIZE}" SWAPPINESS="${SWAPPINESS}" "${ROOT_DIR}/scripts/20-swapfile-btrfs.sh"

echo
echo ">> Verification:"
"${ROOT_DIR}/scripts/40-verify.sh"

echo
echo "Install complete."
echo "If you just changed kargs, reboot once for zram/zswap/display kargs to take effect:"
echo "  systemctl reboot"
