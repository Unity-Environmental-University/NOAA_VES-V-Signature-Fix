#!/bin/bash

# Change to the directory where this script is located
cd "$(dirname "$0")"

echo "NOAA VES-V App Fixer"
echo "===================="
echo ""

APP_PATH="NOAA_VES-V_v144_OSX.app"
EXECUTABLE="$APP_PATH/Contents/MacOS/NOAA_VES-V"

# Check if app exists
if [ ! -d "$APP_PATH" ]; then
    echo "Error: $APP_PATH not found in current directory"
    echo "Please run this script from the folder containing the app"
    exit 1
fi

echo "Step 1/4: Removing quarantine flag..."
xattr -d com.apple.quarantine "$APP_PATH" 2>/dev/null
echo "✓ Done"

echo ""
echo "Step 2/4: Removing broken signature..."
codesign --remove-signature "$APP_PATH" 2>/dev/null
echo "✓ Done"

echo ""
echo "Step 3/4: Adding execute permissions..."
chmod +x "$EXECUTABLE"
echo "✓ Done"

echo ""
echo "Step 4/4: Re-signing with ad-hoc signature..."
codesign -s - --force --deep "$APP_PATH" 2>&1 | grep -v "replacing existing signature"
echo "✓ Done"

echo ""
echo "===================="
echo "App fixed! Opening now..."
echo ""

open "$APP_PATH"
