#!/bin/bash
# Distribute in the supplied ZIP so Finder receives the execute permission.
set -euo pipefail

fail() {
    printf '\nRepair stopped: %s\n' "$1" >&2
    printf 'The simulation has not been successfully repaired and opened.\n' >&2
    if [ -t 0 ]; then
        printf 'Press Return to close this window.\n' >&2
        read -r _ || true
    fi
    exit 1
}
trap 'fail "A command failed on line $LINENO. See the message above."' ERR

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd -P)"
APP_NAME="NOAA_VES-V_v144_OSX.app"
APP_PATH="${1:-}"

# Support placing the script beside the app, or extracting both downloads
# into the same Downloads folder without moving the launcher out of its folder.
if [ -z "$APP_PATH" ]; then
for candidate in \
    "$SCRIPT_DIR/$APP_NAME" \
    "$SCRIPT_DIR/NOAA_VES-V_v144_OSX/$APP_NAME" \
    "$SCRIPT_DIR/../NOAA_VES-V_v144_OSX/$APP_NAME" \
    "$SCRIPT_DIR/../$APP_NAME"; do
    if [ -d "$candidate" ]; then
        APP_PATH="$candidate"
        break
    fi
done
fi

if [ -z "$APP_PATH" ]; then
    fail "Cannot find $APP_NAME. Extract the simulation ZIP and place this launcher beside the app."
fi

EXECUTABLE="$APP_PATH/Contents/MacOS/NOAA_VES-V"
[ -f "$EXECUTABLE" ] || fail "The simulation download is incomplete: its executable is missing."
[ -w "$APP_PATH" ] || fail "The app is not writable. Move it to a folder you own, such as Downloads."

printf 'NOAA VES-V local repair\n======================\n\n'
printf 'App: %s\n\n' "$APP_PATH"
printf '1/4: Restoring executable permission...\n'
/bin/chmod u+x "$EXECUTABLE"

printf '2/4: Replacing the signature with a local ad hoc signature...\n'
/usr/bin/codesign --force --deep --sign - "$APP_PATH"

printf '3/4: Checking the repaired signature...\n'
/usr/bin/codesign --verify --deep --strict "$APP_PATH"

printf '4/4: Removing download quarantine from this app...\n'
/usr/bin/xattr -dr com.apple.quarantine "$APP_PATH"

printf '\nRepair completed. Requesting launch...\n'
/usr/bin/open "$APP_PATH"
printf 'Launch request sent.\n'
