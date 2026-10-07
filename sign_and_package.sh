#!/bin/bash
# Run on the distributor's Mac with a Developer ID Application identity
# and a notarytool keychain profile already configured.
set -euo pipefail

if [ "$#" -ne 2 ]; then
    printf 'Usage: bash sign_and_package.sh "Developer ID Application: Your Name (TEAMID)" "notarytool-profile"\n' >&2
    exit 1
fi
IDENTITY="$1"
NOTARY_PROFILE="$2"
case "$IDENTITY" in
    "Developer ID Application: "*) ;;
    *) printf 'Use a Developer ID Application identity.\n' >&2; exit 1 ;;
esac

PACKAGE_DIR="$(cd -- "$(dirname -- "$0")" && pwd -P)"
APP="$PACKAGE_DIR/NOAA VES-V Launcher.app"
SUBMISSION="$PACKAGE_DIR/NOAA-VES-V-Launcher-notarization.zip"
RELEASE="$PACKAGE_DIR/NOAA-VES-V-Launcher-students.zip"

if [ -e "$RELEASE" ]; then
    printf 'Move the existing student ZIP aside before making a new release.\n' >&2
    exit 1
fi

# Compile a fresh app so the embedded script matches this source package.
/usr/bin/osacompile -o "$APP" "$PACKAGE_DIR/Launcher.applescript"
/bin/cp "$PACKAGE_DIR/fix_and_run.command" "$APP/Contents/Resources/fix_and_run.command"
/bin/chmod 755 "$APP/Contents/Resources/fix_and_run.command"
for key in CFBundleIdentifier CFBundleVersion CFBundleShortVersionString LSMinimumSystemVersion; do
    /usr/libexec/PlistBuddy -c "Delete :$key" "$APP/Contents/Info.plist" 2>/dev/null || true
done
/usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string local.noaavesv.launcher' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Add :CFBundleVersion string 2' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Add :CFBundleShortVersionString string 2.0' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Add :LSMinimumSystemVersion string 10.13' "$APP/Contents/Info.plist"
/usr/bin/codesign --force --options runtime --timestamp --sign "$IDENTITY" "$APP"
/usr/bin/codesign --verify --deep --strict "$APP"
/usr/bin/ditto -c -k --keepParent --norsrc "$APP" "$SUBMISSION"

# Synchronous submission must succeed before a student artifact is produced.
xcrun notarytool submit "$SUBMISSION" --keychain-profile "$NOTARY_PROFILE" --wait
xcrun stapler staple "$APP"
xcrun stapler validate "$APP"
/usr/sbin/spctl --assess --type execute --verbose=2 "$APP"
/usr/bin/ditto -c -k --keepParent --norsrc "$APP" "$RELEASE"
printf '\nStudent download ready: %s\n' "$RELEASE"
