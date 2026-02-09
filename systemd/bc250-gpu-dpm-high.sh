#!/usr/bin/env bash
set -euo pipefail

# Lock AMDGPU performance level to high to prevent downclock stutter.
# This is intentionally simple and reversible.
if [[ -w /sys/class/drm/card0/device/power_dpm_force_performance_level ]]; then
  echo high > /sys/class/drm/card0/device/power_dpm_force_performance_level
fi

exit 0
