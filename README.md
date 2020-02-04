Windows 10 Setup Script
========================================================

## Contents
- [Overview](#overview)
- [Supported Windows version](#supported-windows-version)
- [Core features](#core-features)
- [Nota bene](#NB)
- [Usage](#usage)
- [FAQ](#faq)
- [Screenshots](#screenshots)
- [Microsoft Docs](#Microsoft-Docs)
- [PS](#ps)
  
## Overview
The PowerShell script is a set of tweaks for fine-tuning the OS and automating the routine tasks.

## Supported Windows versions
|Version|Code name|   Marketing name   |Build|  Arch  |   Editions   |
|:-----:|:-------:|:------------------:|:---:|:------:|:------------:|
| 1909  |  19H2   |November 2019 Update|18363|x64 only|Pro/Enterprise|
| 1903  |  19H1   |   May 2019 Update  |18362|x64 only|Pro/Enterprise|

## Core features
- Turn off diagnostics tracking services;
- Turn off diagnostics tracking scheduled tasks;
- Interactive prompts
  - [Screenshot](#screenshots)
- Multilingual support: English & Russian
- Uninstall all UWP apps from all accounts with exception apps list;
- Turn off Windows features;
- Create a task in the Task Scheduler to start Windows cleaning up;
- Create a task in the Task Scheduler to clear the $env:SystemRoot\SoftwareDistribution\Download folder;
- Add folder to exclude from Windows Defender Antivirus scan;
- Turn off per-user services;
- Add old style shortcut for "Devices and Printers" to the Start menu";
- Import Start menu layout from pre-saved reg file;
  - [Download](https://github.com/farag2/Windows-10-Setup-Script/tree/master/Start%20menu%20layout) pre-saved Startmenu.reg
  - [Screenshot](#screenshots)
- Unpin all Start menu tiles;
- Set location of the "Desktop", "Documents", "Downloads", "Music", "Pictures", and "Videos";
- Refresh desktop icons, environment variables and taskbar without restarting File Explorer;
- Many more File Explorer and context menu "deep" tweaks.

## NB
- PowerShell and PowerShell ISE must be run with elevated privileges;
- Set PowerShell execution policy <code>Set-ExecutionPolicy -ExecutionPolicy Bypass -Force</code> to be able to run .ps1 files.
  - Read more about [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
  
## Usage
To run the script:
- Download [up-to-date version](https://github.com/farag2/Setup-Windows-10/releases);
- Check whether file is encoded in **UTF-8 with BOM** and run it through powershell.exe.

or

- Copy the script code and paste it into [PowerShell ISE](https://docs.microsoft.com/en-us/powershell/scripting/components/ise/windows-powershell-integrated-scripting-environment--ise-).

## FAQ
Read the code you run carefully. Some functions are presented as an example only. You must be aware of the meaning of the functions in the code. **If you're not sure what the script does, do not run it**.
**Strongly recommended to run the script after fresh installation**. Some of functions can be run also on LTSB/LTSC and on older versions of Windows and PowerShell (not recommended to run on the x86 systems).

## Screenshots
- Startmenu

  ![Startmenu](https://github.com/farag2/Windows-10-Setup-Script/blob/master/Screenshots/Startmenu.png)

- Interactive promts

  ![Menu](https://github.com/farag2/Windows-10-Setup-Script/blob/master/Screenshots/read-host.png)


## Microsoft Docs
 - [Release information](https://docs.microsoft.com/en-us/windows/release-information)
 - [Known issues](https://docs.microsoft.com/en-us/windows/release-information/status-windows-10-1909)

## Ask a question on
 - [Habr](https://habr.com/en/post/465365/)
 - [Ru-Board](http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
 - [My Digital Life](https://forums.mydigitallife.net/threads/powershell-script-setup-windows-10.80139/)
 - [Reddit](https://www.reddit.com/r/Windows10/comments/ctg8jw/powershell_script_setup_windows_10/)

## PS
Collection of useful [scripts](https://gist.github.com/farag2)
