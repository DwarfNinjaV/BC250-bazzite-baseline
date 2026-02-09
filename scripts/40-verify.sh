#!/usr/bin/env bash
set -euo pipefail

echo "== rpm-ostree status =="
rpm-ostree status || true
echo

echo "== kargs =="
rpm-ostree kargs || true
echo

echo "== display =="
for p in /sys/class/drm/card0-*/status; do
  out="${p%/status}"
  name="${out##*/}"
  st="$(cat "$p" 2>/dev/null || true)"
  if [[ "$st" == "connected" ]]; then
    echo "Connected: ${name}"
    cat "${out}/modes" 2>/dev/null | head -n 10 || true
  fi
done
echo

echo "== zram =="
lsmod | grep -i zram || echo "zram module not loaded"
systemctl status systemd-zram-setup@zram0.service --no-pager 2>/dev/null || true
echo

echo "== swap =="
swapon --show || true
echo

echo "== swappiness =="
sysctl vm.swappiness || true
echo

echo "== GPU DPM level (if available) =="
cat /sys/class/drm/card0/device/power_dpm_force_performance_level 2>/dev/null || echo "not available"
