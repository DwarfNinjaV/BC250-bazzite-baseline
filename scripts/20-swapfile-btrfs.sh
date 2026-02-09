#!/usr/bin/env bash
set -euo pipefail

SWAP_DIR="${SWAP_DIR:-/var/swap}"
SWAP_FILE="${SWAP_FILE:-/var/swap/swapfile}"
SWAP_SIZE="${SWAP_SIZE:-32G}"
SWAPPINESS="${SWAPPINESS:-60}"

echo "Creating swapfile:"
echo "  File: ${SWAP_FILE}"
echo "  Size: ${SWAP_SIZE}"
echo "  Swappiness: ${SWAPPINESS}"

sudo mkdir -p "${SWAP_DIR}"

# Turn off existing swapfile if present
sudo swapoff "${SWAP_FILE}" 2>/dev/null || true

# Remove old swapfile
sudo rm -f "${SWAP_FILE}" 2>/dev/null || true

# Create btrfs swapfile
command -v btrfs >/dev/null 2>&1 || { echo "ERROR: btrfs not found"; exit 1; }
sudo btrfs filesystem mkswapfile --size "${SWAP_SIZE}" "${SWAP_FILE}"

sudo chmod 600 "${SWAP_FILE}"

# Persist in fstab (remove old entry, append new)
sudo sed -i '\|/var/swap/swapfile|d' /etc/fstab
echo "${SWAP_FILE} none swap defaults,nofail 0 0" | sudo tee -a /etc/fstab >/dev/null

# Apply swappiness
echo "vm.swappiness = ${SWAPPINESS}" | sudo tee /etc/sysctl.d/99-swappiness.conf >/dev/null
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf >/dev/null || true

# Enable swap now
sudo swapon "${SWAP_FILE}"

echo "Swap enabled:"
sudo swapon --show
