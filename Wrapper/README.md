## Sophia Script Wrapper

Created by @BenchTweakGaming

This program creates a PowerShell script file that you can run to customize Windows based on Sophia Script. It serves as a front-end GUI for the Sophia Script. It is called a Wrapper.

## How to use

* Download the [latest](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest) Wrapper version
* Expand archive
* Run `SophiaScriptWrapper.exe` and import `Sophia.ps1`
  * `Sophia.ps1` has to be in `Sophia Script` folder
  * The Wrapper has a real time UI rendering
* Configure every function
* Open the `Console Output` tab and press `Run PowerShell`

## Wrapper Files

* `Sophia Script Wrapper.exe`: The GUI program.
* `wrapper_config.json`: JSON that contains the configuration settings for the GUI program
* `wrapper_localizations.json`: JSON that contains the configuration settings for the all the language settings
* `wrapper_accessibility_scales` : JSON that contains the configuration settings for the all the accessibilty scale settings in different languages
* `Set-ConsoleFont.ps1`: PS1 that is run to set PS console to correct font when running PS version 5.x
* `config_Windows_1x.json`: JSON that contains the options (function names), Sophia preset and Windows Default preset, LTSC version
* `before_after.json`: JSON that contains the options (function names) for before and after the user selections for PowerShell script output
* `tooltip_Windows_1x.json`: JSON that contains translations for ToolTips/comments above functions
* `tag.json`: JSON that contains translations for tags
* `ui.json`: JSON that contains translations for UI

# How to translate UI into another language

* Copy and translate the `en-US` folder files in `Localizations` to your language
* You also need to translate the `tag.json` from either the `ru-RU` or `de-DE` folders in `Localizations` to your language
* Edit the `wrapper_localizations.json` file to add the language entry with control sizing

