#!/usr/bin/env bash
set -euo pipefail

# Output: 1080p60 TV-safe
# Internal render can be lower for performance. Change -w/-h if desired.
gamescope -W 1920 -H 1080 -w 1280 -h 720 -r 60 --rt -- steam
