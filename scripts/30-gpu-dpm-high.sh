#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="bc250-gpu-dpm-high.service"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}"
HELPER_PATH="/usr/local/sbin/bc250-gpu-dpm-high.sh"

apply_now() {
  # Works on AMDGPU; if path differs, this will fail fast.
  echo high | sudo tee /sys/class/drm/card0/device/power_dpm_force_performance_level >/dev/null
  cat /sys/class/drm/card0/device/power_dpm_force_performance_level
}

install_service() {
  sudo install -m 0755 ./systemd/bc250-gpu-dpm-high.sh "${HELPER_PATH}"
  sudo install -m 0644 ./systemd/bc250-gpu-dpm-high.service "${SERVICE_PATH}"
  sudo systemctl daemon-reload
  echo "Installed ${SERVICE_NAME}. Enable with:"
  echo "  sudo systemctl enable --now ${SERVICE_NAME}"
}

case "${1:-}" in
  --install-service) install_service ;;
  *) apply_now ;;
esac
