#!/usr/bin/env bash
set -euo pipefail

SWAP_DIR="${SWAP_DIR:-/var/swap}"
SWAP_FILE="${SWAP_FILE:-/var/swap/swapfile}"
SWAP_SIZE="${SWAP_SIZE:-32G}"

echo "Creating swapfile:"
echo "  ${SWAP_FILE} (${SWAP_SIZE})"

# Ensure directory exists
sudo mkdir -p "${SWAP_DIR}"

# If swap is active, turn it off (idempotent)
sudo swapoff "${SWAP_FILE}" 2>/dev/null || true

# Remove old file if present
sudo rm -f "${SWAP_FILE}" 2>/dev/null || true

# Create swapfile using btrfs helper (preferred on btrfs)
if command -v btrfs >/dev/null 2>&1; then
  sudo btrfs filesystem mkswapfile --size "${SWAP_SIZE}" "${SWAP_FILE}"
else
  echo "ERROR: btrfs tool not found. Install btrfs-progs or ensure filesystem supports swapfile creation method."
  exit 1
fi

# Secure permissions
sudo chmod 600 "${SWAP_FILE}"

# Persist in fstab (remove prior lines, then add)
sudo sed -i '\|/var/swap/swapfile|d' /etc/fstab
echo "${SWAP_FILE} none swap defaults,nofail 0 0" | sudo tee -a /etc/fstab >/dev/null

# Set sane swappiness for gaming (avoid extreme values)
SWAPPINESS="${SWAPPINESS:-60}"
echo "vm.swappiness = ${SWAPPINESS}" | sudo tee /etc/sysctl.d/99-swappiness.conf >/dev/null
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf >/dev/null || true

# Enable now
sudo swapon "${SWAP_FILE}"

echo "Swap enabled."
sudo swapon --show
