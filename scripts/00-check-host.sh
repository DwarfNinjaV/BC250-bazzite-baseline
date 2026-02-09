#!/usr/bin/env bash
set -euo pipefail

# 00-check-host.sh
# Purpose: refuse to run inside a Flatpak/container shell and confirm host prerequisites.

die() {
  echo "ERROR: $*" >&2
  exit 1
}

echo "== bc250-bazzite-baseline :: host check =="

# If we're inside a Flatpak sandbox, this env var is typically set.
if [[ -n "${FLATPAK_ID-}" ]]; then
  die "Detected Flatpak sandbox (FLATPAK_ID=${FLATPAK_ID}). Open a HOST terminal, or run: flatpak-spawn --host bash"
fi

# rpm-ostree is the strongest indicator we're on the host OS for Bazzite/Atomic.
command -v rpm-ostree >/dev/null 2>&1 || die "rpm-ostree not found. You are likely not on the host shell (or not on an rpm-ostree based OS)."

# systemctl should exist on the host.
command -v systemctl >/dev/null 2>&1 || die "systemctl not found; this does not look like the host OS."

# Helpful context
echo "User: $(id -un) (uid=$(id -u))"
echo "Host: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Bazzite/ostree state:"
rpm-ostree status || true

# Check expected directories/paths we use later
[[ -d /sys/class/drm ]] || die "/sys/class/drm missing; unexpected environment."

# Print likely display connectors (for user to set OUTPUT=DP-1 etc.)
echo
echo "Detected DRM connectors:"
ls /sys/class/drm | grep -E 'card[0-9]+-(DP|HDMI|eDP)-' || echo "(none found)"

# Privilege note (Bazzite typically has sudo on host, but not guaranteed)
echo
if command -v sudo >/dev/null 2>&1; then
  echo "sudo: present"
else
  echo "sudo: NOT found. You must run commands as root or install sudo via rpm-ostree."
fi

echo
echo "OK: host checks passed."
