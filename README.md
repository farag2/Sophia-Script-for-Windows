## Contents
- [Overview](#overview)
- [Core features](#core-features)
- [Screenshots](#screenshots)
- [Usage](#usage)
- [Supported Windows version](#supported-windows-version)
- [FAQ](#faq)
- [Links](#links)
- [PS](#ps)
  
## Overview
This PowerShell script is for initial setup after fresh installation of Windows 10 and partially Windows Server 2016/2019. The script is a set of tweaks for fine-tuning the OS and automating the routine tasks.

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

### Screenshots
- Startmenu

  ![Startmenu](https://github.com/farag2/Windows-10-Setup-Script/blob/master/Screenshots/Startmenu.png)

- Interactive promts

  ![Menu](https://github.com/farag2/Windows-10-Setup-Script/blob/master/Screenshots/read-host.png)

## Usage
To run the script:
- Download [up-to-date version](https://github.com/farag2/Setup-Windows-10/releases);
- Change encoding to "UTF-8 with BOM" and run it through powershell.exe.

or

- Copy the script code and paste it into [PowerShell ISE](https://docs.microsoft.com/en-us/powershell/scripting/components/ise/windows-powershell-integrated-scripting-environment--ise-).

**NB**
- PowerShell and PowerShell ISE must be run with elevated privileges;
- Set PowerShell execution policy <code>Set-ExecutionPolicy Unrestricted -Force</code> to be able to run .ps1 files.
  - Read more about [execution policy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) 

## Supported Windows version
| Version |   Code name  |      Marketing name    | Build |
| :-----: | -------------| ---------------------- | :---: |
|  1903   |    19H1      |     May 2019 Update    | 18362 |

## FAQ
Read the code you run carefully. Some functions are presented as an example only. You must be aware of the meaning of the functions in the code. **If you're not sure what the script does, do not run it.**

The script was written for PowerShell 5.1 and for the current up-to-date version of Windows 10 Pro x64. Some of functions can be run also on LTSB/LTSC and on older versions of Windows and PowerShell (also on 32bit systems).

## Links
- Ask a question in
  - [Ru-Board](http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
  - [My Digital Life](https://forums.mydigitallife.net/threads/powershell-script-setup-windows-10.80139/)
  - [Reddit](https://www.reddit.com/r/Windows10/comments/ctg8jw/powershell_script_setup_windows_10/)

## PS
Collection of useful [scripts](https://gist.github.com/farag2)
