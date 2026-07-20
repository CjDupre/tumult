#!/usr/bin/env bash
# capture a build's preview.png:  tools/capture.sh <build-dir> [warp-frames]
#
# headless chrome cannot fast-forward requestAnimationFrame (a 60s
# --virtual-time-budget yields ~4 frames), so stateful builds accept
# ?warp=N and pre-run N simulation frames before first paint.
set -euo pipefail
cd "$(dirname "$0")/.."

build="${1:?usage: tools/capture.sh <build-dir> [warp-frames]}"
warp="${2:-1800}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

"$CHROME" --headless=new --hide-scrollbars --window-size=1600,940 \
  --virtual-time-budget=20000 \
  --screenshot="builds/${build}/preview.png" \
  "file://$PWD/builds/${build}/index.html?warp=${warp}" 2>/dev/null

sips --cropToHeightWidth 840 1600 "builds/${build}/preview.png" >/dev/null
echo "builds/${build}/preview.png (warp=${warp})"
