NOAA VES-V v1.44 - macOS Installation Instructions
==================================================

This app requires a one-time fix to run on macOS due to signature issues.

DOWNLOAD THE SIMULATION
------------------------
https://github.com/nmfs-ost/VES-V/blob/master/Executables.md

HOW TO INSTALL:
---------------
1. Place the "fix_and_run.command" file in the same folder as the app.
2. Double-click "fix_and_run.command"
3. Done! The app will automatically launch.

FIRST TIME ONLY: If macOS blocks the script with a security warning:
  - Right-click "fix_and_run.command" and choose "Open"
  - Click "Open" in the security dialog
  - The script will run and launch the app


WHAT THE SCRIPT DOES:
---------------------
The script automatically fixes the app by:
- Removing macOS quarantine flag (tells macOS you trust this app)
- Fixing file permissions
- Re-signing with a local signature

This is completely safe and only affects this app on your computer.
The script finds the app automatically - no need to move files around.


MANUAL METHOD (If script doesn't work):
----------------------------------------
Right-click "NOAA_VES-V_v144_OSX.app" → choose "Open" → click "Open"


TROUBLESHOOTING:
----------------
Problem: Script shows "command not found" errors
Solution: Open Terminal and run these commands:
  cd [drag the folder here and press Enter]
  sed -i '' 's/\r$//' fix_and_run.command

Then double-click fix_and_run.command again

Problem: Nothing happens when double-clicking the script
Solution: Right-click fix_and_run.command → Get Info →
         Open With → Terminal → Change All


ABOUT:
------
This is official government software from NOAA Fisheries.
The signature issue occurs during download/extraction and is safe to fix.
