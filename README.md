🌐 [English](/README.md) | [Deutsche](/README_de-de.md) | [Русский](/README_ru-ru.md) | [Українська](/README_uk-ua.md)

<div align="center">

<img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/img/Sophia.png" alt="Sophia Script for Windows" width='150'>

# Sophia Script for Windows

The most powerful PowerShell module for fine-tuning Windows on GitHub

Made with <img src="./img/heart.svg" height="17px"/> of Windows

<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/actions"><img src="https://img.shields.io/github/actions/workflow/status/farag2/Sophia-Script-for-Windows/Sophia.yml?labelColor=151B23&color=151B23&style=for-the-badge&label=build&logo=GitHub"></a>
</kbd>
<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Arm-support-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=Arm&logoColor=white" href="#"></a>
</kbd>
<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Human%20Coded%20100%25-green?labelColor=151B23&color=151B23&style=for-the-badge" href="#"></a>
</kbd>

<br>

<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Badge_downloads.yml"><img src="https://img.shields.io/endpoint?labelColor=151B23&color=151B23&style=for-the-badge&url=https://gist.githubusercontent.com/farag2/25ddc72387f298503b752ad5b8d16eed/raw/SophiaScriptDownloadsCount.json"></a>
</kbd>
<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Badge_lines.yml"><img src="https://img.shields.io/endpoint?labelColor=151B23&color=151B23&style=for-the-badge&url=https://gist.githubusercontent.com/farag2/9852d6b9569a91bf69ceba8a94cc97f4/raw/SophiaScript.json"></a>
</kbd>

<br>

<kbd>
	<a href="https://t.me/sophianews"><img src="https://img.shields.io/badge/Sophia%20News-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=telegram&logoColor=white"></a>
</kbd>
<kbd>
	<a href="https://t.me/sophia_chat"><img src="https://img.shields.io/badge/Sophia%20Chat-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=telegram&logoColor=white"></a>
</kbd>
<kbd>
	<a href="https://discord.gg/sSryhaEv79"><img src="https://img.shields.io/badge/Discord-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=discord&logoColor=white" href="#"></a>
</kbd>

<br>
<br>

<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Download-green?labelColor=151B23&color=151B23&style=for-the-badge"></a>
</kbd>

<br>
<br>

<img src="./img/SophiaScript.gif" width='800'>

</div>

## Key features

* `Sophia Script for Windows` cares about your Windows stability and informs in case of finding a problem
* More than 150 unique functions to configure Windows using Microsoft's officially documented ways without making any harm to it
  * Every tweak has its corresponding function to restore default settings
* Fully open-source project
  * All archives are being built and uploaded using [GitHub Actions](https://github.com/farag2/Sophia-Script-for-Windows/actions)
* Configure Windows AI
* Configure Windows privacy, security, personalization
* Available via Scoop, Chocolatey, and WinGet
* ARM64 support
* PowerShell 7 support
* Has no conflict with [VAC](https://help.steampowered.com/faqs/view/571A-97DA-70E9-FF74#whatisvac)
* Uninstall UWP apps displaying their localized packages names
  * Script generates installed UWP apps list [dynamically](#screenshots)
* Applied registry policies will be displayed in the Local Group Policy Editor snap-in (gpedit.msc)
* Enable DNS-over-HTTPS using
  * [Cloudflare DNS](https://developers.cloudflare.com/1.1.1.1/setup/windows/)
  * [Google Public DNS](https://developers.google.com/speed/public-dns/docs/using)
  * [Quad9 DNS](https://quad9.net/service/service-addresses-and-features/)
  * [Comss.one DNS](https://www.comss.ru/page.php?id=7315)
  * [AdGuard DNS](https://adguard-dns.io/public-dns.html)
* Uninstall OneDrive
* Interactive [prompts and popups](#screenshots)
* <kbd>TAB</kbd> [completion](#how-to-run-the-specific-functions) for functions and their arguments (using Import-TabCompletion.ps1)
* Change location of the user folders (without moving user files) using an interactive menu
  * Desktop
  * Documents
  * Downloads
  * Music
  * Pictures
  * Videos
* Install free (light and dark) `Windows 11 Cursors Concept v2` cursors from [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) on-the-fly
  * Archive was downloaded to [Cursors](https://github.com/farag2/Sophia-Script-for-Windows/tree/master/Cursors) folder using [DeviantArt API](https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Cursors.yml)
* Set an app as default one for specific extension without `How do you want to open this` pop-up
* Export and import all Windows associations. You need to install all apps according to exported JSON file to restore all associations
* Install WSL Linux distribution with [pop-up](#screenshots) using friendly distro names
* Create scheduled tasks with a [native toast notification](#screenshots)
  * Create scheduled tasks `Windows Cleanup` and `Windows Cleanup Notification` for cleaning up Windows of unused files and Windows updates files
  * Create a scheduled task `SoftwareDistribution` for cleaning up `%SystemRoot%\SoftwareDistribution\Download`
  * Create a scheduled task `Temp` for cleaning up `%TEMP%`
* Install the latest provided Microsoft Visual C++ 2015–2026 x86/x64
* Install the latest provided .NET Desktop Runtime 8, 9, 10 x64
* Many more File Explorer and context menu tweaks

## Table of Contents

* [Key features](#key-features)
* [How to download](#how-to-download)
* [How to use](#how-to-use)
  * [How to run the specific function(s)](#how-to-run-the-specific-functions)
* [System Requirements](#system-requirements)
* [Screenshots](#screenshots)
* [How to translate](#how-to-translate)
* [SophiApp 2.0](#sophiapp-20-c--winui-3)

## How to download

### From release page

<table>
  <tbody>
    <tr>
      <td align="center">Windows 10</td>
      <td align="center">Windows 11</td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-PowerShell%207-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011-PowerShell%207-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-LTSC%202019-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011%20LTSC%202024-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-LTSC%202021-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011%20Arm-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011%20Arm-PowerShell%207-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="center" colspan="2"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Sophia%20Script%20Wrapper-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
  </tbody>
</table>

### Download via PowerShell

Download and expand to Downloads folder the latest `Sophia Script for Windows` version depending to your Windows and PowerShell versions you use.

```powershell
iwr script.sophia.team -useb | iex
```

Download and expand to Downloads folder the latest `Sophia Script for Windows` version from the last [commit](https://github.com/farag2/Sophia-Script-for-Windows/commits/master/) depending to your Windows and PowerShell versions you use.

```powershell
iwr sl.sophia.team -useb | iex
```

### Chocolatey

Download and expand to Downloads folder latest `Sophia Script for Windows` version depending to your Windows version you use.

```powershell
choco install sophia --force -y
```

Download and expand to Downloads folder latest `Sophia Script for Windows` version for PowerShell 7 depending to your Windows version you use.

```powershell
choco install sophia --params "/PS7" --force -y
```

```powershell
# Uninstall and then remove downloaded folder manually
choco uninstall sophia --force -y
```

### WinGet

Download and expand to Downloads folder latest `Sophia Script for Windows` version for Windows 11 and PowerShell 5.1 (SFX archive `sophiascript.exe`).

```powershell
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
winget install --id TeamSophia.SophiaScript --location $DownloadsFolder --accept-source-agreements --force

& "$DownloadsFolder\sophiascript.exe"
```

```powershell
# Uninstall Sophia Script for Windows
winget uninstall --id TeamSophia.SophiaScript --force
```

### Scoop

Download and expand to Downloads folder latest `Sophia Script for Windows` version for Windows 11 for PowerShell 5.1.

```powershell
# scoop bucket rm extras
scoop bucket add extras
scoop install sophia-script --no-cache
```

```powershell
# Uninstall Sophia Script for Windows
scoop uninstall sophia-script --purge
```

## How to use

<https://github.com/user-attachments/assets/5af5c234-5fb5-4e7e-a3d0-ae496a89e6ba>

* Download archive for your system and expand it
* Look through the `Sophia.ps1` file to configure functions that you want to be run
  * Place the `#` char before function if you don't want it to be run
  * Remove the `#` char before function if you want it to be run
* Copy path of downloaded `Sophia Script for Windows` folder
* Right click on `Windows` button, open Terminal (PowerShell) as admin, and paste copied path to folder

```batch
  cd path\to\folder
```

* Set execution policy to be able to run scripts only in the current PowerShell session

```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

* Type `.\Sophia.ps1`and press <kbd>Enter</kbd>

### How to run the specific function(s)

<https://github.com/user-attachments/assets/d70150d6-af8c-4933-9ec5-b2cf3bb1dd34>

* Do all steps from [How to use](#how-to-use) section and stop at setting execution policy in `PowerShell`
* [Dot source](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-) the `Import-TabCompletion.ps1` file first:

```powershell
# With a dot at the beginning
. .\Import-TabCompletion.ps1
```

* Сall any script function with name autocompletion using <kbd>TAB</kbd>

```powershell
Sophia -Functions<TAB>
Sophia -Functions temp<TAB>
Sophia -Functions unin<TAB>
Sophia -Functions uwp<TAB>
Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", Uninstall-UWPApps

Uninstall-UWPApps, "PinToStart -UnpinAll"
```

## Wrapper

<img src="./img/Wrapper.png" width='600'>

Wrapper is a `3rd party closed-source` wrapper for `Sophia Script for Windows`. It's fully maintained by [@BenchTweakGaming](https://github.com/BenchTweakGaming).

Read more [here](./Wrapper/README.md)

## System Requirements

[Windows-10]: https://support.microsoft.com/topic/windows-10-update-history-8127c2c6-6edf-4fdf-8b9f-0f7be1ef3562
[Windows-10-LTSC-2019]: https://support.microsoft.com/topic/windows-10-and-windows-server-2019-update-history-725fc2e1-4443-6831-a5ca-51ff5cbcb059
[Windows-10-LTSC-2021]: https://support.microsoft.com/topic/windows-10-update-history-857b8ccb-71e4-49e5-b3f6-7073197d98fb
[Windows-11-LTSC-2024]: https://support.microsoft.com/topic/windows-11-version-24h2-update-history-0929c747-1815-4543-8461-0160d16f15e5
[Windows-11-24h2]: https://support.microsoft.com/topic/windows-11-version-25h2-update-history-99c7f493-df2a-4832-bd2d-6706baa0dec0

|               Version                    |                  Build                |      Edition        |
|:-----------------------------------------|:-------------------------------------:|:-------------------:|
| Windows 11 24H2/25H2+                    | [Latest stable][Windows-11-24h2]      | Home/Pro/Enterprise |
| Windows 10 x64 22H2                      | [Latest stable][Windows-10]           | Home/Pro/Enterprise |
| Windows 11 Enterprise LTSC 2024          | [Latest stable][Windows-11-LTSC-2024] | Enterprise          |
| Windows 10 x64 21H2 Enterprise LTSC 2021 | [Latest stable][Windows-10-LTSC-2021] | Enterprise          |
| Windows 10 x64 1809 Enterprise LTSC 2019 | [Latest stable][Windows-10-LTSC-2019] | Enterprise          |

## Screenshots

<div class="row">
  <img src="./img/uwpapps.png" width='314'>
  <img src="./img/WSL.png" width='350'>
</div>

<img src="./img/Toasts.png" width='400'>

## How to translate

* Get your OS UI culture by invoking `$PSUICulture` in PowerShell
* Create a folder with the UI culture name
* Place your localized SophiaScript.psd1 file into this folder

## Media

<details>
<a href="https://www.xda-developers.com/sophia-script-returns-control-windows-11">XDA</a>

<a href="https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/">4sysops</a>

<a href="https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/">gHacks</a>

<a href="https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs">Neowin</a>

<a href="https://www.comss.ru/page.php?id=8019">Comss.ru</a>

<a href="https://habr.com/company/skillfactory/blog/553800">Habr</a>

<a href="https://www.deskmodder.de/blog/2021/08/07/sophia-script-for-windows-jetzt-fuer-windows-11-und-10/)">Deskmodder.de</a>

<a href="https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15">Ru-Board</a>

<a href="https://rutracker.org/forum/viewtopic.php?t=5996011">rutracker</a>

<a href="https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/">My Digital Life</a>
</details>

***

## SophiApp 2.0 (C# + WinUI 3)

[SophiApp 2.0](https://github.com/Sophia-Community/SophiApp) is in ongoing development. 🚀

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/0.gif)
![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/1.png)
