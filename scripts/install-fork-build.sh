#!/bin/zsh
# Installs the latest local build from release/ over /Applications/T3 Code (Beta).app and reopens it.
# Run from Terminal.app, not from inside T3 Code: it quits T3 Code first.
set -e
REPO="${0:A:h:h}"
APP="/Applications/T3 Code (Beta).app"
STAGE="$REPO/release/staged"
ZIP=$(ls -t "$REPO"/release/T3-Code-*-arm64.zip 2>/dev/null | head -1)

[ -n "$ZIP" ] || { echo "No build in $REPO/release. Run: vp run dist:desktop:dmg:arm64"; exit 1; }
echo "Unpacking $ZIP..."
rm -rf "$STAGE" && mkdir -p "$STAGE"
ditto -x -k "$ZIP" "$STAGE"
NEW="$STAGE/T3 Code (Beta).app"
[ -d "$NEW" ] || { echo "Build has no 'T3 Code (Beta).app'"; exit 1; }

echo "Quitting T3 Code..."
osascript -e 'quit app "T3 Code (Beta)"' || true
for i in {1..30}; do
  pgrep -f "$APP/Contents/MacOS" >/dev/null || break
  sleep 1
done
if pgrep -f "$APP/Contents/MacOS" >/dev/null; then
  echo "T3 Code is still running. Quit it fully (Cmd+Q) and run this again."
  exit 1
fi

if [ -d "$APP" ]; then
  OLD="$HOME/.Trash/T3 Code (Beta) previous $(date +%Y%m%d-%H%M%S).app"
  echo "Moving the current app to the Trash: $OLD"
  mv "$APP" "$OLD"
fi
echo "Installing your build..."
ditto "$NEW" "$APP"
open "$APP"
echo "Done. To go back: drag the previous app out of the Trash into /Applications."
