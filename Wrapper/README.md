README.md for 'Sophia Script Wrapper v2.2' created by [BenchTweakGaming.com](https://benchtweakgaming.com/2020/10/10/windows-10-debloat-tool/).  
Created for [farag2 Windows 10 Sophia Script](https://github.com/farag2/Windows-10-Sophia-Script).

# INTRODUCTION

Please read this document to understand how to use this program.

[BenchTweakGaming.com](https://benchtweakgaming.com) now works with the [farag2 team](https://github.com/farag2).

This program create a PowerShell script file that you can run to tweak/'Debloat' Windows 10 based on farag2 Windows 10 Sophia Script. It serves as a front-end GUI for the Sophia Script. It is called a Wrapper.

The options are arranged in different tabs and there are 2 presets in the preset menu. The two presets: `Sophia`, `Windows Default`. `Sophia` is the recommended preset to use to debloat. Choose `Windows Default` to revert back to original Windows Default settings. You can also create your own Sophia script to share and open it up. There is a Opposite menu option to select the alternative selections. There are ToolTips balloon message popups for detailed info for each item. There are different languages in menu.

After choosing your options, you can directly run the PowerShell script from the program after creating your script. To do so, import preset `Sophia.ps1`, as this also gets the path for files to run directly, then fill in your choices, click the `Refresh Console` button and then click `Run Powershell` button. The `Run PowerShell` button  creates a PowerShell script called `Sophia_edited.ps1` in the same directory as `Sophia.ps1` and runs it.

OR save the PowerShell script as `Sophia.ps1` with the farag2 Sophia files and run it using the following commands.

Launch PowerShell (Run as administrator) and navigate to where your script is.

1. `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force`
2. `.\Sophia.ps1`

# WRAPPER FILES

All of settings are stored in JSON file stored in a folder 'Config'. There are currently 8 languages in JSON in 'Localizations' folder.

## Please help with translations for everyone to use or fix them and submit it to us.

1. `Sophia Script Wrapper.exe`: The GUI program.
2. `config.json`: JSON that contains the options (function names), Sophia preset and Windows Default preset. LTSC version.
3. `tooltip.json`: ToolTips in JSON format. Currently 8 languages EN, RU, DE, ES, FR, PT, ZH and VI translations.
4. `ui.json`: UI in JSON format. Currently 8 languages EN, RU, DE, ES, FR, PT, ZH and VI translations.

# INSTRUCTIONS

UNZIP all the files and import the `Sophia.ps1` preset file to import and to get the path for files to run. If you do not open `Sophia.ps1` then you can not run directly the PowerShell script you create (`Run PowerShell` button is disabled) and must run your script manually via PowerShell command line in console.
