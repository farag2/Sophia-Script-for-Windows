## Sophia Script Wrapper

Created by David from [BenchTweakGaming.com](https://benchtweakgaming.com/2020/10/10/windows-10-debloat-tool/).
This program creates a PowerShell script file that you can run to customize Windows based on Sophia Script. It serves as a front-end GUI for the Sophia Script. It is called a Wrapper.

## Wrapper Files

* `Sophia Script Wrapper.exe`: The GUI program.
* `config_Windows_1x.json`: JSON that contains the options (function names), Sophia preset and Windows Default preset, LTSC version.
* `before_after.json`: JSON that contains the options (function names) for before and after the user selections for PowerShell script output.
* `tooltip_Windows_1x.json`: ToolTips in JSON format.
* `tag.json`: tags in JSON format.
* `ui.json`: UI in JSON format.

# How to translate UI into another language

Copy and translate the `en-US` folder files in `Localizations` to your language. You also need to translate the `tag.json` from either the `ru-RU` or `de-DE` folders in `Localizations` to your language and submit to us to add the language entry.

# How to Use

Unzip all the files and import the `Sophia.ps1` preset file to import and to get the path for files to run. If you do not import `Sophia.ps1` then you can not run directly the PowerShell script you create and all controls in Wrapper are disabled.
