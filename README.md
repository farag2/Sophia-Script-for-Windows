<div align="center">

<img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/img/Sophia.png" alt="Sophia Script for Windows" width='150'>

# Sophia Script for Windows

**Sophia Script for Windows is the most powerful PowerShell module for fine-tuning Windows**

[downloads-badge]: https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/farag2/25ddc72387f298503b752ad5b8d16eed/raw/SophiaScriptDownloadsCount.json
[lines-badge]: https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/farag2/9852d6b9569a91bf69ceba8a94cc97f4/raw/SophiaScript.json
[lines-link]: https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Badge_lines.yml
[badge-code]: https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Badge_downloads.yml

[![downloads][downloads-badge]][badge-code]
[![lines][lines-badge]][lines-link]

[telegram-news-badge]: https://img.shields.io/badge/Sophia%20News-Telegram-blue?style=flat&logo=Telegram
[telegram-news]: https://t.me/sophianews
[telegram-group]: https://t.me/sophia_chat
[telegram-group-badge]: https://img.shields.io/endpoint?color=neon&label=Sophia%20Chat&style=flat&url=https%3A%2F%2Ftg.sumanjay.workers.dev%2Fsophia_chat
[discord-news-badge]: https://discordapp.com/api/guilds/1006179075263561779/widget.png?style=shield
[discord-link]: https://discord.gg/sSryhaEv79

[![Telegram][telegram-news-badge]][telegram-news]
[![Telegram][telegram-group-badge]][telegram-group]
[![Discord][discord-news-badge]][discord-link]

[![build](https://img.shields.io/github/actions/workflow/status/farag2/Sophia-Script-for-Windows/Sophia.yml?label=build&logo=GitHub)](https://github.com/farag2/Sophia-Script-for-Windows/actions)
[![GitHub Release](https://img.shields.io/github/v/release/farag2/Sophia-Script-for-Windows?logo=GitHub)](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest)

[![uk-UA](https://img.shields.io/badge/lang-uk--UA-blue)](./docs/README_uk-ua.md)
[![de](https://img.shields.io/badge/lang-de-black)](./docs/README_de-de.md)
[![ru](https://img.shields.io/badge/lang-ru-red)](./docs/README_ru-ru.md)

<img src="./img/SophiaScript.png" alt="Sophia Script for Windows" width='800'>

</div>

## About Sophia Script

`Sophia Script for Windows` is the largest PowerShell module on `GitHub` for `Windows 10` & `Windows 11` for fine-tuning and automating the routine tasks. It offers more than 150 unique tweaks, and shows how Windows can be configured without making any harm to it.

Made with <img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/heart.svg" height="17px"/> of Windows.

> [!IMPORTANT]
> Every tweak in the preset file has its' corresponding function to restore the default settings. Running the script is best done on a fresh install because running it on wrong tweaked system may result in errors occurring.

> [!WARNING]
> It's allowed to be logged in as one admin user only during application startup.
>
> `Sophia Script for Windows` may not work on a homebrew Windows. Especially, if the homebrew image was created by OS makers being all thumbs who break Microsoft Defender and disable OS telemetry by purposely uprooting system components.

## Table of Contents

* [How to download](#how-to-download)
  * [Download via PowerShell](#download-via-powershell)
  * [Download via Chocolatey](#download-via-chocolatey)
  * [Download via WinGet](#download-via-winget)
  * [From release page](#from-release-page)
* [How to use](#how-to-use)
  * [How to run the specific function(s)](#how-to-run-the-specific-functions)
  * [Wrapper](#wrapper)
  * [How to revert changes](#how-to-revert-changes)
* [Donations](#donations)
* [System Requirements](#system-requirements)
* [Key features](#key-features)
* [Screenshots](#screenshots)
* [Videos](#videos)
* [How to translate](#how-to-translate)
* [Media](#media)
* [SophiApp 2](#sophiapp-2-c--winui-3)

## How to download

### Download via PowerShell

The command will download and expand the latest Sophia Script archive (`without running`) according which Windows and PowerShell versions it is run on. If you run it on, e.g., Windows 11 via PowerShell 5.1, it will download Sophia Script for `Windows 11 PowerShell 5.1`.

```powershell
iwr script.sophia.team -useb | iex
```

The command will download and expand the latest Sophia Script archive (`without running`) from the `last commit available` according which Windows and PowerShell versions it is run on.

```powershell
iwr sl.sophia.team -useb | iex
```

### Download via Chocolatey

The command will download and expand the latest Sophia Script archive (`without running`) according which Windows it is run on. If you run it on Windows 11, it will download Sophia Script for `Windows 11`. For `PowerShell 5.1` by default is not otherwise specified.

```powershell
choco install sophia --force -y
```

Download `Sophia Script for Windows` for `PowerShell 7`.

```powershell
choco install sophia --params "/PS7" --force -y
```

```powershell
# Uninstall Sophia Script
# Then remove downloaded folder manually
choco uninstall sophia --force -y
```

### Download via WinGet

The command downloads only `Windows 11 (PowerShell 5.1)` archive to your `Downloads` folder unlike the `Chocolatey` [script](#download-via-chocolatey) and expands it.

```powershell
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
winget install --id TeamSophia.SophiaScript --location $DownloadsFolder --accept-source-agreements --force
```

```powershell
# Uninstall Sophia Script
winget uninstall --id TeamSophia.SophiaScript --force
```

### From release page

Download an [archive](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest) according to your Windows and PowerShell versions.

## How to use

* Download archive and expand it;
* Look through the `Sophia.ps1` file to configure functions that you want to be run;
  * Place the `#` char before function if you don't want it to be run.
  * Remove the `#` char before function if you want it to be run.
* Copy the whole path to `Sophia.ps1`
  * On `Windows 10` press and hold the <kbd>Shift</kbd> key, right click on `Sophia.ps1`, and click on `Copy as path`;
  * On `Windows 11` right click on `Sophia.ps1` and click on `Copy as path`.
* Open `Windows PowerShell`
  * On `Windows 10` click `File` in the File Explorer, hover over `Open Windows PowerShell`, and select `Open Windows PowerShell as Administrator` [(how-to with screenshots)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/)
  * On `Windows 11` right-click on the <kbd>Windows</kbd> icon and open `Windows Terminal (Admin)`;
* Set execution policy to be able to run scripts only in the current PowerShell session;

```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

* Type `.\Sophia.ps1`and press <kbd>Enter</kbd>;

```powershell
  .\Sophia.ps1
```

### Windows 11

<https://github.com/user-attachments/assets/2654b005-9577-4e56-ac9e-501d3e8a18bd>

### Windows 10

<https://github.com/user-attachments/assets/f5bda68f-9509-41dc-b3b1-1518aeaee36f>

### How to run the specific function(s)

* Do all steps from [How to use](#how-to-use) section and stop at setting execution policy in `PowerShell`;
* [Dot source](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-) the `Import-TabCompletion.ps1` file first:

```powershell
# With a dot at the beginning
. .\Import-TabCompletion.ps1
```

* Now you can do like this (the quotation marks required)

```powershell
Sophia -Functions<TAB>
Sophia -Functions temp<TAB>
Sophia -Functions unin<TAB>
Sophia -Functions uwp<TAB>
Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

UninstallUWPApps, "PinToStart -UnpinAll"
```

Or use an old-style format without the <kbd>TAB</kbd> functions autocomplete (the quotation marks required)

```powershell
.\Sophia.ps1 -Functions CreateRestorePoint, "ScheduledTasks -Disable", "WindowsCapabilities -Uninstall"
```

<https://github.com/user-attachments/assets/ea90122a-bdb3-4687-bf8b-9b6e7af46826>

## Wrapper

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/Wrapper.png)

@BenchTweakGaming

* Download the [latest](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest) Wrapper version;
* Expand archive;
* Run `SophiaScriptWrapper.exe` and import `Sophia.ps1`;
  * `Sophia.ps1` has to be in `Sophia Script` folder;
  * The Wrapper has a real time UI rendering;
* Configure every function;
* Open the `Console Output` tab and press `Run PowerShell`.

## How to revert changes

* Do all steps from [How to use](#how-to-use) section and stop at setting execution policy in `PowerShell`;
* [Dot source](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-) the `Import-TabCompletion.ps1` file first:

```powershell
# With a dot at the beginning
. .\Import-TabCompletion.ps1
```

* Call functions from `Sophia.ps1` you want to revert like this.

```powershell
Sophia -Functions "DiagTrackService -Enable", UninstallUWPApps
```

## Donations

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/farag)⠀⠀⠀<a href="https://boosty.to/teamsophia"><img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/boosty.png" width='40'></a>

## System Requirements

[Windows-10]: https://support.microsoft.com/topic/windows-10-update-history-8127c2c6-6edf-4fdf-8b9f-0f7be1ef3562
[Windows-10-LTSC-2019]: https://support.microsoft.com/topic/windows-10-and-windows-server-2019-update-history-725fc2e1-4443-6831-a5ca-51ff5cbcb059
[Windows-10-LTSC-2021]: https://support.microsoft.com/topic/windows-10-update-history-857b8ccb-71e4-49e5-b3f6-7073197d98fb
[Windows-11-LTSC-2024]: https://support.microsoft.com/topic/windows-11-version-24h2-update-history-0929c747-1815-4543-8461-0160d16f15e5
[Windows-11-24h2]: https://support.microsoft.com/topic/windows-11-version-24h2-update-history-0929c747-1815-4543-8461-0160d16f15e5

|               Version                    |    Marketing name   |                  Build                |      Edition        |
|:-----------------------------------------|--------------------:|:-------------------------------------:|:-------------------:|
| Windows 11 24H2                          | 2024 Update         | [Latest stable][Windows-11-24h2]      | Home/Pro/Enterprise |
| Windows 10 x64 22H2                      | 2022 Update         | [Latest stable][Windows-10]           | Home/Pro/Enterprise |
| Windows 11 Enterprise LTSC 2024          | 2024 Update         | [Latest stable][Windows-11-LTSC-2024] | Enterprise          |
| Windows 10 x64 21H2 Enterprise LTSC 2021 | October 2021 Update | [Latest stable][Windows-10-LTSC-2021] | Enterprise          |
| Windows 10 x64 1809 Enterprise LTSC 2019 | October 2018 Update | [Latest stable][Windows-10-LTSC-2019] | Enterprise          |

## Key features

* All archives are being built via GitHub Actions [automatically](https://github.com/farag2/Sophia-Script-for-Windows/actions);
* Set up Privacy & Telemetry;
* Enable DNS-over-HTTPS for IPv4;
* Turn off diagnostics tracking scheduled tasks with pop-up form written in [WPF](#screenshots);
* Set up UI & Personalization;
* Uninstall OneDrive "correctly";
* Interactive [prompts](#change-user-folders-location-programmatically-using-the-interactive-menu);
* The <kbd>TAB</kbd> [completion](#the-tab-autocomplete-read-more-here) for functions and their arguments (if using the Import-TabCompletion.ps1 file);
* Change location of the user folders programmatically (without moving user files) within interactive menu using arrows to select a drive
  * Desktop
  * Documents
  * Downloads
  * Music
  * Pictures
  * Videos
* Install free (light and dark) "Windows 11 Cursors Concept v2" cursors from [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) on-the-fly;
* Uninstall UWP apps displaying thier localized packages names;
  * Script generates installed UWP apps list [dynamically](#localized-uwp-packages-names)
* Disable Windows features displaying friendly packages names with pop-up form written in [WPF](#screenshots);
* Uninstall Windows capabilities displaying friendly packages names with pop-up form written in [WPF](#screenshots);
* Download and install the [HEVC Video Extensions from Device Manufacturer](https://apps.microsoft.com/detail/9N4WGH0Z6VHQ) to be able to open [HEVC](https://en.wikipedia.org/wiki/H.265) format;
* Set an app as default one for specific extension without the "How do you want to open this" pop-up using special [function](https://github.com/DanysysTeam/PS-SFTA);
* Export all Windows associations. Associations will be exported as Application_Associations.json file in script root folder;
* Import exported JSON file after a clean installation. You have to install all apps according to an exported JSON file to restore all associations;
* Install any supported Linux distribution for WSL displaying friendly distro names with pop-up form written in [WPF](#screenshots);
* Create scheduled tasks with a native toast notification, where you will be able to run or [dismiss](#native-interactive-toasts-for-the-scheduled-tasks) tasks;
  * Create scheduled tasks `Windows Cleanup` and `Windows Cleanup Notification` for cleaning up Windows of unused files and Windows updates files;
  * Create a scheduled task `SoftwareDistribution` for cleaning up `%SystemRoot%\SoftwareDistribution\Download`;
  * Create a scheduled task `Temp` for cleaning up `%TEMP%`.
* Create tasks in the Task Scheduler to clear
  * `%SystemRoot%\SoftwareDistribution\Download`
  * `%TEMP%`
* Install the latest provided Microsoft Visual C++ 2015–2022 x86/x64;
* Install the latest provided .NET Desktop Runtime 8, 9 x86/x64;
* Configure the Windows security;
* Display all policy registry keys (even manually created ones) in the Local Group Policy Editor snap-in (gpedit.msc);
* Many more File Explorer and context menu "deep" tweaks.

## Screenshots

### The <kbd>TAB</kbd> autocomplete. Read more [here](#how-to-run-the-specific-functions)

https://user-images.githubusercontent.com/10544660/225270281-908abad1-d125-4cae-a19b-2cf80d5d2751.mp4

### Change user folders location programmatically using the interactive menu

https://user-images.githubusercontent.com/10544660/253818031-b7ce6bf1-d968-41ea-a5c0-27f6845de402.mp4

### Localized UWP packages names

![Image](https://i.imgur.com/xeiBbes.png) ![Image](https://i.imgur.com/0zj0h2S.png)

### Localized Windows features names

![Image](https://i.imgur.com/xlMR2mz.png) ![Image](https://i.imgur.com/yl9j9Vt.png)

### Download and install any supported Linux distribution in automatic mode

![Image](https://i.imgur.com/Xn5SqxE.png)

### Native interactive toasts for the scheduled tasks

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/Toasts.png)

## Videos

[![YT](https://img.youtube.com/vi/q_weQifFM58/0.jpg)](https://www.youtube.com/watch?v=q_weQifFM58)

[![YT](https://img.youtube.com/vi/8E6OT_QcHaU/1.jpg)](https://youtu.be/8E6OT_QcHaU?t=370) [![YT](https://img.youtube.com/vi/091SOihvx0k/1.jpg)](https://youtu.be/091SOihvx0k?t=490)

## How to translate

* Get your OS UI culture by invoking `$PSUICulture` in PowerShell;
* Create a folder with the UI culture name;
* Place your localized SophiaScript.psd1 file into this folder.

## Media

* [XDA](https://www.xda-developers.com/sophia-script-returns-control-windows-11)
* [4sysops](https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/)
* [gHacks](https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/)
* [Neowin](https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs)
* [Comss.ru](https://www.comss.ru/page.php?id=8019)
* [Habr](https://habr.com/company/skillfactory/blog/553800)
* [Deskmodder.de](https://www.deskmodder.de/blog/2021/08/07/sophia-script-for-windows-jetzt-fuer-windows-11-und-10/)
* [PCsoleil Informatique](https://www.pcsoleil.fr/successeur-de-win10-initial-setup-script-sophia-script-comment-lutiliser/)
* [Reddit (archived)](https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/)
  * PM [me](https://www.reddit.com/user/farag2/)
* [Ru-Board](https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
* [rutracker](https://rutracker.org/forum/viewtopic.php?t=5996011)
* [My Digital Life](https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/)

***

## SophiApp 2 (C# + WinUI 3)

[SophiApp 2.0](https://github.com/Sophia-Community/SophiApp) is in ongoing development. 🚀

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/0.gif)
![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/1.png)
