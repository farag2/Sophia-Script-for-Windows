<div align="right">
  This page also in:
  <a title="Українська" href="README_uk-ua.md"><img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/></a>
</div>

# Sophia Script for Windows

<img src="./img/Sophia.png" alt="Sophia Script" width='350' align="right">

<img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Windows_10_Logo.svg" height="30px"/> &emsp; <img src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Windows_11_logo.svg" height="30px"/>

<p align="left">
  <a href="https://github.com/farag2/Sophia-Script-for-Windows/actions"><img src="https://img.shields.io/github/actions/workflow/status/farag2/Sophia-Script-for-Windows/Sophia.yml?label=GitHub%20Actions&logo=GitHub"></a>
  <img src="https://img.shields.io/badge/PowerShell%205.1%20&%207.3-Ready-blue.svg?color=5391FE&style=flat&logo=powershell">

  <a href="https://github.com/farag2/Sophia-Script-for-Windows/releases"><img src="https://img.shields.io/github/v/release/farag2/Sophia-Script-for-Windows"></a>
  <a href="https://github.com/farag2/Sophia-Script-for-Windows"><img src="https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/farag2/9852d6b9569a91bf69ceba8a94cc97f4/raw/SophiaScript.json"></a>

  <a href="https://github.com/farag2/Sophia-Script-for-Windows/releases"><img src="https://img.shields.io/github/downloads/farag2/Sophia-Script-for-Windows/total?label=downloads%20%28since%20May%202020%29"></a>
  <a href="https://community.chocolatey.org/packages/sophia"><img src="https://img.shields.io/chocolatey/dt/sophia?color=blue&label=chocolatey%20package"></a>

  <a href="https://twitter.com/tea_head_"><img src="https://img.shields.io/badge/Logo%20by-teahead-blue?style=flat&logo=Twitter"></a>
  <img src="https://img.shields.io/badge/Made%20with-149ce2.svg?color=149ce2"><img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/heart.svg" height="17px"/>

  [telegram-news-badge]: https://img.shields.io/badge/Sophia%20News-Telegram-blue?style=flat&logo=Telegram
  [telegram-news]: https://t.me/sophianews
  [telegram-group]: https://t.me/sophia_chat
  [telegram-group-badge]: https://img.shields.io/badge/Sophia%20Chat-Telegram-blue?style=flat&logo=Telegram

  [![Telegram][telegram-news-badge]][telegram-news]
  [![Telegram][telegram-group-badge]][telegram-group]

  [discord-news-badge]: https://discordapp.com/api/guilds/1006179075263561779/widget.png?style=shield
  [discord-link]: https://discord.gg/sSryhaEv79
  [![Discord][discord-news-badge]][discord-link]
</p>

<p align="left">
  <img title="English" src="https://upload.wikimedia.org/wikipedia/commons/a/a5/Flag_of_the_United_Kingdom_(1-2).svg" height="20px"/>
  &nbsp;
  <img title="中国人" src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Flag_of_the_People's_Republic_of_China.svg" height="20px"/>
  &nbsp;
  <img title="Deutsch" src="https://upload.wikimedia.org/wikipedia/commons/b/ba/Flag_of_Germany.svg" height="20px"/>
  &nbsp;
  <img title="Français" src="https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg" height="20px"/>
  &nbsp;
  <img title="Italiano" src="https://upload.wikimedia.org/wikipedia/commons/0/03/Flag_of_Italy.svg" height="20px"/>
  &nbsp;
  <img title="Русский" src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="20px"/>
  &nbsp;
  <img title="Українська" src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="20px"/>
  &nbsp;
  <img title="Türkçe" src="https://upload.wikimedia.org/wikipedia/commons/b/b4/Flag_of_Turkey.svg" height="20px"/>
  &nbsp;
  <img title="Español" src="https://upload.wikimedia.org/wikipedia/commons/9/9a/Flag_of_Spain.svg" height="20px"/>
  &nbsp;
  <img title="Português" src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg" height="20px"/>
  &nbsp;
  <img title="Magyar" src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Flag_of_Hungary.svg" height="20px"/>
  &nbsp;
  <img title="Polski" src="https://upload.wikimedia.org/wikipedia/commons/1/12/Flag_of_Poland.svg" height="20px"/>
</p>

***

<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/SSdownloadbutton.svg" width=220px height=55px></a>

***

<p align="center">
 &bull;
 <a href="#donations">Donations</a>
 &bull;
 <a href="#system-requirements">System Requirements</a>
 &bull;
 <a href="#screenshots">Screenshots</a>
 &bull;
 <a href="#videos">Videos</a>
 &bull;
 <a href="#key-features">Key features</a>
 &bull;
 <a href="#how-to-use">How to use</a>
 &bull;
 <a href="#how-to-translate">How to translate</a>
 &bull;
 <a href="#sophiapp-community-edition-c--wpf">SophiApp</a>
 &bull;
 <a href="https://github.com/farag2/Sophia-Script-for-Windows/blob/master/CHANGELOG.md">Changelog</a>
</p>

## About Sophia Script

![Typing SVG](https://readme-typing-svg.herokuapp.com?font=Fira+Code&size30&pause=1000&width=435&lines=Made+with+%E2%9D%A4%EF%B8%8F+of+Windows%C2%AE)

> **Note**: Sophia Script for Windows is the largest PowerShell module on `GitHub` for `Windows 10` & `Windows 11` for fine-tuning and automating the routine tasks. It offers more than 150 unique tweaks, and shows how Windows can be configured without making any harm to it.

## Before running

> **Note**: Due to the fact that the script includes more than **150** functions with different arguments, you must read the entire **Sophia.ps1** carefully and **comment out/uncomment** those functions that you do/do not want to be executed (without need to edit the code), or use [Wrapper](https://github.com/farag2/Sophia-Script-for-Windows#benchtweakgaming-sophia-script-wrapper). Every tweak in the preset file has its' corresponding function to **restore the default settings**. Running the script is best done on a fresh install because running it on **wrong** tweaked system may result in errors occurring.

## Donations

<a href="https://yoomoney.ru/to/4100116615568835"><img src="https://yoomoney.ru/i/shop/iomoney_logo_color_example.png" width=220px height=46px align="left">
</a><a href="https://ko-fi.com/farag"><img src="https://www.ko-fi.com/img/githubbutton_sm.svg" width=220px height=46px align="left"></a>

| ![ko-fi](https://img.shields.io/badge/tether-168363?style=for-the-badge&logo=tether&logoColor=white) |
|:----------------------------------------------------------------------------------------------------:|
|                                         USDT (TRC20)                                                 |
|                             `TQtMjdocUWbKAeg1kLtB4ApjAVHt1v8Rtf`                                     |

## System Requirements

|               Version                |    Marketing name   |    Build    | Arch |      Editions       |
|:-------------------------------------|--------------------:|:-----------:|:----:|:-------------------:|
| Windows 11 Insider Preview 23H2      | 2023 Update         | 22509+      |      | Home/Pro/Enterprise |
| Windows 11 22H2                      | 2022 Update         | 22621.1344+ |      | Home/Pro/Enterprise |
| Windows 10 22H2                      | 2022 Update         | 19045.2364+ | x64  | Home/Pro/Enterprise |
| Windows 10 21H2 Enterprise LTSC 2021 | October 2021 Update | 19044.2604+ | x64  | Enterprise          |
| Windows 10 1809 Enterprise LTSC 2019 | October 2018 Update | 17763.4010+ | x64  | Enterprise          |

### Warning

* It's allowed to be logged in as one admin user only during application startup.
* 🔥🔥🔥`Sophia Script for Windows` may not work on a homebrew Windows. Especially, if the homebrew image was created by OS makers being all thumbs who break Microsoft Defender and disable OS telemetry by purposely uprooting system components

## Key features

* Set up Privacy & Telemetry;
* Enable DNS-over-HTTPS for IPv4;
* Turn off diagnostics tracking scheduled tasks with pop-up form written in [WPF](#screenshots);
* Set up UI & Personalization;
* Uninstall OneDrive "correctly";
* Interactive [prompts](#change-user-folders-location-programmatically-using-the-interactive-menu);
* The <kbd>TAB</kbd> [completion](#the-tab-autocomplete-read-more-here) for functions and their arguments (if using the Functions.ps1 file);
* Change %TEMP% environment variable path to %SystemDrive%\Temp;
* Change location of the user folders programmatically (without moving user files) within interactive menu using arrows to select a drive
  * "Desktop"
  * "Documents"
  * "Downloads"
  * "Music"
  * "Pictures"
  * "Videos"
* Install free (light and dark) "Windows 11 Cursors Concept v2" cursors from [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) on-the-fly;
* Uninstall UWP apps displaying  packages names;
  * Generate installed UWP apps list dynamically
* Restore the default uninstalled UWP apps for current user displaying [localized](#localized-uwp-packages-names) packages names;
* The <kbd>TAB</kbd> [autocompletion](#the-tab-autocomplete-read-more-here) for function and its' arguments by typing first letters;
* Disable Windows features displaying friendly packages names with pop-up form written in [WPF](#screenshots);
* Uninstall Windows capabilities displaying friendly packages names with pop-up form written in [WPF](#screenshots);
* Download and install the [HEVC Video Extensions from Device Manufacturer](https://www.microsoft.com/p/hevc-video-extensions-from-device-manufacturer/9n4wgh0z6vhq) to be able to open [HEVC](https://en.wikipedia.org/wiki/H.265) format;
* Register app, calculate hash, and set as default for specific extension without the "How do you want to open this" pop-up using special [function](https://github.com/DanysysTeam/PS-SFTA);
* Install any supported Linux distrobution for WSL displaying friendly distro names with pop-up form written in [WPF](#screenshots);
* Create a `Windows Cleanup` and `Windows Cleanup Notification` scheduled tasks for Windows cleaning up unused files and updates;
  * A native toast notification will be displayed where you can choose to snooze, run the cleanup task or [dismiss](#native-interactive-toasts-for-the-scheduled-tasks)
* Create tasks in the Task Scheduler to clear
  * `%SystemRoot%\SoftwareDistribution\Download`
  * `%TEMP%`
* Pin shortcuts to Start via pure PowerShell
  * Three shortcuts are pre-configured to be pinned: Control Panel, "old style" Devices and Printers, and Windows PowerShell
* Unpin all Start menu tiles;
* Turn on Controlled folder access and add protected folders using dialog menu;
* Add exclusion folder from Microsoft Defender Antivirus scanning using dialog menu;
* Add exclusion file from Microsoft Defender Antivirus scanning using dialog menu;
* Refresh desktop icons, environment variables and taskbar without restarting File Explorer;
* Configure the Windows security;
* Many more File Explorer and context menu "deep" tweaks.

## Screenshots

### The <kbd>TAB</kbd> autocomplete. Read more [here](#how-to-run-the-specific-functions)

https://user-images.githubusercontent.com/10544660/225270281-908abad1-d125-4cae-a19b-2cf80d5d2751.mp4

### Change user folders location programmatically using the interactive menu

https://user-images.githubusercontent.com/10544660/225270532-8f0694d3-0b9e-44df-8a48-677212d62315.mp4

### Localized UWP packages names

![Image](https://i.imgur.com/xeiBbes.png) ![Image](https://i.imgur.com/0zj0h2S.png)

### Localized Windows features names

![Image](https://i.imgur.com/xlMR2mz.png) ![Image](https://i.imgur.com/yl9j9Vt.png)

### Download and install any supported Linux distribution in automatic mode

![Image](https://i.imgur.com/Xn5SqxE.png)

### Native interactive toasts for the scheduled tasks

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/Toasts.png)

### @BenchTweakGaming Sophia Script Wrapper

![Wrapper](https://i.imgur.com/x0W7zqm.png)

## Videos

[![YT](https://img.youtube.com/vi/q_weQifFM58/0.jpg)](https://www.youtube.com/watch?v=q_weQifFM58)

[![YT](https://img.youtube.com/vi/8E6OT_QcHaU/1.jpg)](https://youtu.be/8E6OT_QcHaU?t=370) [![YT](https://img.youtube.com/vi/091SOihvx0k/1.jpg)](https://youtu.be/091SOihvx0k?t=490)

## How to use

* Choose the right script version for your `Windows`;
* Download [up-to-date version](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest);
* Expand the archive;
* Open folder with the expanded archive;
* Look through the `Sophia.ps1` file to configure functions that you want to be run;
  * Place the "#" char before function if you don't want it to be run.
  * Remove the "#" char before function if you want it to be run.
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

* Run `Sophia.ps1`
  * On `Windows 11` paste copied path to `Sophia.ps1` from the previous step (with [&](https://en.wikipedia.org/wiki/Ampersand));

   ```powershell
   & <path_from_buffer>
   ```

  * On `Windows 11`

   ```powershell
   .\Sophia.ps1
   ```

## How to use Wrapper

* Download and expand the archive;
* Run `SophiaScriptWrapper.exe` and import `Sophia.ps1`;
  * The Wrapper has a real time UI rendering;
* Configure every function;
* Open the `Console Output` tab and press `Run PowerShell`.

***

### How to run the specific function(s)

To run the specific function(s) [dot source](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator) the `Functions.ps1` file first:

```powershell
# With a dot at the beginning
. .\Functions.ps1
```

* Now you can do like this (the quotation marks required)

```powershell
Sophia -FunctionsTAB
Sophia -Functions temp<TAB>
Sophia -Functions unin<TAB>
Sophia -Functions uwp<TAB>
Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

UninstallUWPApps, "PinToStart -UnpinAll"
```

Or use an old-style format without the TAB functions autocomplete (the quotation marks required)

```powershell
.\Sophia.ps1 -Functions CreateRestorePoint, "ScheduledTasks -Disable", "WindowsCapabilities -Uninstall"
```

***

## How to download Sophia Script via PowerShell

* Download the always latest Sophia Script archive by invoking (`not as administrator too`) in PowerShell

```powershell
irm script.sophi.app -useb | iex
```

* The command will download and expand the latest Sophia Script archive (`without running`) according which Windows and PowerShell versions it is run on. If you run it on, e.g., Windows 11 via PowerShell 5.1, it will download Sophia Script for `Windows 11 PowerShell 5.1`.

## How to translate

* Get your OS UI culture by invoking `$PSUICulture` in PowerShell;
* Create a folder with the UI culture name;
* Place your localized Sophia.psd1 file into this folder.

## Media

* [![Discord](https://discordapp.com/api/guilds/1006179075263561779/widget.png?style=shield)](https://discord.gg/sSryhaEv79)
* [Telegram discussion group](https://t.me/sophia_chat)
* [Telegram channel](https://t.me/sophianews)
* [Ru-Board](https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
* [rutracker](https://rutracker.org/forum/viewtopic.php?t=5996011)
* [My Digital Life](https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/)
* [4sysops](https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/)
* [gHacks Technology News](https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/)
* [Neowin: Tech News, Reviews & Betas](https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs)
* [Comss.ru](https://www.comss.ru/page.php?id=8019)
* [Habr](https://habr.com/company/skillfactory/blog/553800)
* [Deskmodder.d](https://www.deskmodder.de/blog/2021/08/07/sophia-script-for-windows-jetzt-fuer-windows-11-und-10/)
* [PCsoleil Informatique](https://www.pcsoleil.fr/successeur-de-win10-initial-setup-script-sophia-script-comment-lutiliser/)
* [Reddit (archived)](https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/)
  * PM [me](https://www.reddit.com/user/farag2/)

***

## SophiApp Community Edition (C# + WPF)

[SophiApp](https://github.com/Sophia-Community/SophiApp) is the full GUI version of `Sophia Script for Windows` and ready for use. It is in ongoing improvements with version 2.0 in development 🚀

![Image](https://github.com/Sophia-Community/SophiApp/raw/master/img/0.gif)
![Image](https://github.com/Sophia-Community/SophiApp/raw/master/img/1.png)
