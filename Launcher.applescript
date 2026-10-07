use scripting additions

on run
    activate
    try
        set downloadsFolder to POSIX path of (path to downloads folder)
        set launcherPath to POSIX path of (path to me)
        set packageFolder to do shell script "/usr/bin/dirname " & quoted form of launcherPath
        set simulationPath to ""
        repeat with candidate in {packageFolder & "/NOAA_VES-V_v144_OSX.app", packageFolder & "/NOAA_VES-V_v144_OSX/NOAA_VES-V_v144_OSX.app", packageFolder & "/../NOAA_VES-V_v144_OSX/NOAA_VES-V_v144_OSX.app", downloadsFolder & "NOAA_VES-V_v144_OSX.app", downloadsFolder & "NOAA_VES-V_v144_OSX/NOAA_VES-V_v144_OSX.app"}
            try
                do shell script "/bin/test -d " & quoted form of (candidate as text)
                set simulationPath to candidate as text
                exit repeat
            end try
        end repeat
        if simulationPath is "" then
            set simulationPath to POSIX path of (choose file with prompt "Select the NOAA VES-V simulation app from your extracted download." of type {"com.apple.application-bundle"})
        end if
        set repairScript to launcherPath & "Contents/Resources/fix_and_run.command"
        do shell script "/bin/bash " & quoted form of repairScript & " " & quoted form of simulationPath
    on error errorMessage number errorNumber
        if errorNumber is not -128 then
            display alert "NOAA VES-V could not open" message errorMessage as critical
        end if
    end try
end run
