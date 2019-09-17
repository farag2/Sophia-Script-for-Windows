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
- [Links](#links)
- [PS](#ps)
  
## Overview
The PowerShell script is a set of tweaks for fine-tuning the OS and automating the routine tasks.

## Supported Windows version
|Version|Code name|Marketing name |Build|Arch|PowerShell|
|:-----:|:-------:|:-------------:|:---:|:--:|:--------:|
| 1903  |  19H1   |May 2019 Update|18362|x64 |   5.1    |

## Core features
- Turn off diagnostics tracking services;
- Turn off diagnostics tracking scheduled tasks;
- Interactive prompts
  - [Screenshot](#screenshots)
- Uninstall all UWP apps from all accounts with exception apps list;
- Turn off Windows features;
- Create scheduled task with the disk cleanup tool in Task Scheduler;
- Create task to clean out the "$env:SystemRoot\SoftwareDistribution\Download" folder in Task Scheduler;
- Create scheduled task with the $env:TEMP folder cleanup in Task Scheduler;
- Add folder to exclude from Windows Defender Antivirus scan;
- Turn off per-user services;
- Create old style shortcut for "Devices and Printers";
- Import Start menu layout from pre-saved reg file;
  - Download pre-saved Startmenu.reg
  - [Screenshot](#screenshots)
- Unpin all Start menu tiles;
- Set location of the "Desktop", "Documents" "Downloads" "Music", "Pictures", and "Videos";
- Refresh desktop icons, environment variables and taskbar without restarting File Explorer;
- Many more File Explorer and context menu "deep" tweaks.

## NB
- PowerShell and PowerShell ISE must be run with elevated privileges;
- Set PowerShell execution policy <code>Set-ExecutionPolicy Unrestricted -Force</code> to be able to run .ps1 files.
  - Read more about [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) 
  
## Usage
To run the script:
- Download [up-to-date version](https://github.com/farag2/Setup-Windows-10/releases);
- Check whether file is encoded in **UTF-8 with BOM** and run it through powershell.exe.

or

- Copy the script code and paste it into [PowerShell ISE](https://docs.microsoft.com/en-us/powershell/scripting/components/ise/windows-powershell-integrated-scripting-environment--ise-).

## FAQ
Read the code you run carefully. Some functions are presented as an example only. You must be aware of the meaning of the functions in the code. **If you're not sure what the script does, do not run it.**
Some of functions can be run also on LTSB/LTSC and on older versions of Windows and PowerShell (also on 32bit systems).

### Screenshots
- Startmenu

  ![Startmenu](https://github.com/farag2/Windows-10-Setup-Script/blob/master/Screenshots/Startmenu.png)

- Interactive promts

  ![Menu](https://github.com/farag2/Windows-10-Setup-Script/blob/master/Screenshots/read-host.png)


## Links
### Ask a question in
 - [Habr](https://habr.com/ru/post/465365/)
 - [Ru-Board](http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
 - [My Digital Life](https://forums.mydigitallife.net/threads/powershell-script-setup-windows-10.80139/)
 - [Reddit](https://www.reddit.com/r/Windows10/comments/ctg8jw/powershell_script_setup_windows_10/)

## PS
Collection of useful [scripts](https://gist.github.com/farag2)
