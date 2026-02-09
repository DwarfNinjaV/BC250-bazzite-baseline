#!/usr/bin/env bash
set -euo pipefail

# ---- CONFIG ----
# Set this to your actual connector name (common: DP-1, DP-2). Check with: ls /sys/class/drm | grep -E 'DP-|HDMI-'
OUTPUT="${OUTPUT:-DP-1}"

# TV-safe CEA mode. If you need the underscan fallback, change to 1824x1026@60e.
CEA_MODE="${CEA_MODE:-1920x1080@60e}"

# zswap settings
ZSWAP_POOL="${ZSWAP_POOL:-25}"
ZSWAP_COMP="${ZSWAP_COMP:-lz4}"

# ---- APPLY ----
echo "Applying rpm-ostree kargs:"
echo "  video=${OUTPUT}:${CEA_MODE}"
echo "  systemd.zram=0"
echo "  zswap.enabled=1 zswap.max_pool_percent=${ZSWAP_POOL} zswap.compressor=${ZSWAP_COMP}"

sudo rpm-ostree kargs \
  --append-if-missing="video=${OUTPUT}:${CEA_MODE}" \
  --append-if-missing="systemd.zram=0" \
  --append-if-missing="zswap.enabled=1" \
  --append-if-missing="zswap.max_pool_percent=${ZSWAP_POOL}" \
  --append-if-missing="zswap.compressor=${ZSWAP_COMP}"

echo
echo "Done. Reboot required:"
echo "  systemctl reboot"
