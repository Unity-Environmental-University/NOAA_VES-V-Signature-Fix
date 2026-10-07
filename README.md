# NOAA VES-V macOS Launcher

A double-click launcher that repairs and opens NOAA's VES-V v1.44 simulation on macOS. This community repair tool is separate from NOAA's simulation.

## Students: download and open

1. Download the **macOS v1.44 simulation ZIP** from [NOAA's download page](https://github.com/nmfs-ost/VES-V/blob/master/Executables.md).
2. Download **[NOAA-VES-V-Launcher-students.zip](https://github.com/Unity-Environmental-University/NOAA_VES-V-Signature-Fix/releases/latest/download/NOAA-VES-V-Launcher-students.zip)** from the latest release.
3. Extract both ZIPs in **Downloads**.
4. Double-click **NOAA VES-V Launcher.app**.

The launcher finds the simulation in Downloads and repairs and opens it. If the simulation is elsewhere, select **NOAA_VES-V_v144_OSX.app** when asked.

Students do not need Terminal or `chmod`. The release launcher is Developer ID signed and Apple notarized, with its notarization ticket attached. macOS may show its normal first-open confirmation; managed computers can impose additional restrictions.

Use the **launcher ZIP release attachment**, rather than GitHub's source-code ZIP or a loose `.command` file. Downloading a loose script can lose its execute permission.

## What the repair does

The launcher restores the simulation's executable permission, replaces its signature with a local ad hoc signature, verifies that signature, removes download quarantine from that simulation app, and requests launch. It stops and displays an error if a repair step fails.

Only use it with a simulation download you trust. This repair does not verify the simulation publisher's identity or scan it for malware.

## Source and building

- `Launcher.applescript` provides the app interface, simulation lookup, and file picker.
- `fix_and_run.command` performs the local repair and remains available for manual use.
- `sign_and_package.sh` builds, signs, notarizes, and packages the launcher.
- `LICENSE` contains the project's license.

Distributors need macOS, Xcode tools, a Developer ID Application certificate with its private key, and a configured `notarytool` keychain profile.

```bash
bash sign_and_package.sh "Developer ID Application: Your Name (TEAMID)" "your-profile-name"
```

The build signs with hardened runtime and a timestamp, submits to Apple, attaches the accepted notarization ticket, and checks Gatekeeper acceptance before producing `NOAA-VES-V-Launcher-students.zip`. Credentials stay in Keychain; the script takes a profile name rather than a password. Move an existing output ZIP aside before rebuilding.

## Releases

Commit the source and attach the final launcher ZIP to a GitHub Release. Generated apps, ZIPs, and the local `dist` folder are ignored by Git. Do not alter the app bundle after signing and notarization.

For each release, upload and download the asset again, compare its checksum, verify the extracted signature and notarization ticket, and assess it with Gatekeeper with download quarantine present. Check that the downloaded launcher opens an extracted simulation. A check on one Mac does not establish compatibility with every macOS version or verify all gameplay.

The v2.0.0 release was uploaded and downloaded through GitHub Releases with matching SHA-256, then passed signature, notarization-ticket, and quarantined Gatekeeper checks. On macOS 27.0.1 (Apple silicon), the downloaded launcher opened the simulation through both automatic Downloads lookup and the file picker. Full gameplay and other macOS versions have not been tested.
