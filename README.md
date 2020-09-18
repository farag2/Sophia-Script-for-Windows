<div align="center">
  <h1>Windows 10 Setup Script</h1>

**"Windows 10 Setup Script" is a set of tweaks for OS fine-tuning and automating the routine tasks** 🏆

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/b88d2880e17a4844bef470f2e7929c6b)](https://www.codacy.com/manual/farag2/Windows-10-Setup-Script)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/farag2/Windows-10-Setup-Script)
![GitHub All Releases](https://img.shields.io/github/downloads/farag2/Windows-10-Setup-Script/total)
[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Q5Q51QUJC)
</div>

|              |                 |                |                |                |                |
|--------------|-----------------|----------------|----------------|----------------|----------------|
| [![YT](https://i.imgur.com/mADOh3c.png)](https://youtu.be/8E6OT_QcHaU?t=370) | [![YT](https://i.imgur.com/mADOh3c.png)](https://youtu.be/WK_A9c-m2PQ) | [![ghacks](https://i.imgur.com/K4f8VBo.png)](https://www.ghacks.net/2020/08/19/run-windows-10-setup-script-after-installation-to-customize-the-os/) | [![neowin](https://i.imgur.com/5fILFqz.png)](https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs) | [![comss](https://cdn.comss.net/img/logo51.png)](https://www.comss.ru/page.php?id=7889) | [![habr](https://i.imgur.com/cXWLr4I.png)](https://habr.com/en/post/465365/) |


## FAQ

* Due to the fact that the script includes about 150 functions, you must read the entire script and comment out those sections that you do not want to be executed otherwise likely you will enable features that you do not want to be enabled.
* Running the script is best done on a fresh install because running it on tweaked system may result in errors occurring.
* Some third-party antiviruses flag this script or its' part as malicious one. This is a false positive due to [$EncodedScript](https://github.com/farag2/Windows-10-Setup-Script/blob/0f9bbee7e1d43f487eb0855e0d1e44ff569fc4a9/200x/2004.ps1#L2837) variable. You can read more about in "Create a task to clean up unused files and Windows updates in the Task Scheduler" section. You might need to disable tamper protection from your antivirus settings, re-enable it after running the script, and reboot.

## Screenshots

<details>
  <summary>Screenshots</summary>
  
![Image](https://i.imgur.com/OjWeooZ.png)
![Image](https://i.imgur.com/BDOoE4B.png)
![Image](https://i.imgur.com/stEsBkN.png)
</details>

## Videos

<details>
  <summary>Videos</summary>

[![Image](http://img.youtube.com/vi/8MzuDLNH9QU/0.jpg)](http://www.youtube.com/watch?v=8MzuDLNH9QU)
[![Image](http://img.youtube.com/vi/cjyi9nX8sFA/0.jpg)](http://www.youtube.com/watch?v=cjyi9nX8sFA)
</details>

## Core features

* Set up Privacy & Telemetry;
* Turn off diagnostics tracking scheduled tasks;
* Set up UI & Personalization;
* Uninstall OneDrive "correctly";
* Interactive prompts;
* Change %TEMP% environment variable path to %SystemDrive%\Temp
* Change location of the user folders programmatically (without moving user files) within interactive menu using up/down arrows and Enter key to make a selection
  * "Desktop";
  * "Documents";
  * "Downloads";
  * "Music";
  * "Pictures"
  * "Videos.
* Uninstall UWP apps from all accounts with exception apps list with pop-up form written in [WPF](#Screenshots);
* Turn off Windows features;
* Remove Windows capabilities with pop-up form written in [WPF](#Screenshots);
* Create a Windows cleaning up task in the Task Scheduler;
  * A toast notification will pop up a minute before the task [starts](#Screenshots)
* Create tasks in the Task Scheduler to clear
  * %SystemRoot%\SoftwareDistribution\Download
  * %TEMP%
* Unpin all Start menu tiles;
* Pin shortcuts to Start menu using [syspin.exe](http://www.technosys.net/products/utils/pintotaskbar)
  * Three shortcuts are preconfigured to be pinned: Control Panel, "old style" Devices and Printers, and Command Prompt
* Turn on Controlled folder access and add protected folders using dialog menu;
* Add exclusion folder from Microsoft Defender Antivirus scanning using dialog menu;
* Add exclusion file from Microsoft Defender Antivirus scanning using dialog menu;
* Refresh desktop icons, environment variables and taskbar without restarting File Explorer;
* Many more File Explorer and context menu "deep" tweaks.

## Usage

To run the script:

* Download [up-to-date version](https://github.com/farag2/Setup-Windows-10/releases);
* Expand the archive;
* Check whether .ps1 is encoded in **UTF-8 with BOM**;
* Set execution policy to be able to run scripts only in the current PowerShell session

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Run .ps1 file via powershell.exe with elevated privileges;
  * or launch Start.cmd as Administrator.

## Supported Windows 10 versions

|Version|Code name|   Marketing name   |Build | Arch |      Editions     |
|:-----:|:-------:|:------------------:|:----:|:----:|:-----------------:|
| 2004  |  20H1   |   May 2020 Update  |19041 |  x64 |Home/Pro/Enterprise|
| 1909  |  19H2   |November 2019 Update|18363 |  x64 |Home/Pro/Enterprise|
| 1903  |  19H1   |   May 2019 Update  |18362 |  x64 |Home/Pro/Enterprise|
| 1809  |         |LTSC Enterprise 2019|17763 |  x64 |   Enterprise      |

## GUI version (C#)

[oz-zo](https://github.com/oz-zo) still cooking (moved to the private repository)

## 21H1 test version
https://gist.github.com/farag2/5a6d9952247aefe42ba81a9d95507765

## Microsoft Docs

* [Release information](https://docs.microsoft.com/en-us/windows/release-information)
* [Known issues for 2004](https://docs.microsoft.com/ru-ru/windows/release-information/status-windows-10-2004)

## Ask a question on

* [Ru-Board](http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
* [4PDA](https://4pda.ru/forum/index.php?s=&showtopic=523489&view=findpost&p=95909388)
* [My Digital Life](https://forums.mydigitallife.net/threads/powershell-script-setup-windows-10.81675/)
* [Reddit](https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/)
