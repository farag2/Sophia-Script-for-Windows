# Sophia Script for Windows

<img src="./img/Sophia.png" alt="Sophia Script" width='350' align="right">

**The largest PowerShell module on `GitHub` for `Windows 10` & `Windows 11` fine-tuning and automating the routine tasks** :trophy:

<img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Windows_10_Logo.svg" height="30px"/> &emsp; <img src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Windows_11_logo.svg" height="30px"/>

<p align="left">
  <a href="https://github.com/farag2/Sophia-Script-for-Windows/actions"><img src="https://img.shields.io/github/workflow/status/farag2/Sophia-Script-for-Windows/Build?label=GitHub%20Actions&logo=GitHub"></a>
  <img src="https://img.shields.io/badge/PowerShell%205.1%20&%207.1-Ready-blue.svg?color=5391FE&style=flat&logo=powershell">

  <a href="https://github.com/farag2/Sophia-Script-for-Windows/releases"><img src="https://img.shields.io/github/downloads/farag2/Sophia-Script-for-Windows/total?label=downloads%20%28since%20May%202020%29"></a>
  <a href="https://github.com/farag2/Sophia-Script-for-Windows/releases"><img src="https://img.shields.io/github/v/release/farag2/Sophia-Script-for-Windows"></a>

  <a href="https://twitter.com/tea_head_"><img src="https://img.shields.io/badge/Logo%20by-teahead-blue?style=flat&logo=Twitter"></a>
  <img src="https://img.shields.io/badge/Made%20with-149ce2.svg?color=149ce2"><img src="https://github.com/websemantics/bragit/blob/master/demo/img/heart.svg" height="17px"/>

  <a href="https://t.me/SophiaNews"><img src="https://img.shields.io/badge/Sophia%20News-Telegram-blue?style=flat&logo=Telegram"></a>
  <a href="https://t.me/Sophia_Chat"><img src="https://img.shields.io/badge/Sophia%20Chat-Telegram-blue?style=flat&logo=Telegram"></a>
</p>

Available in: <img src="https://upload.wikimedia.org/wikipedia/commons/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Flag_of_the_People's_Republic_of_China.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/b/ba/Flag_of_Germany.svg" height="11px"/>
<img src="https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/0/03/Flag_of_Italy.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/b/b4/Flag_of_Turkey.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/9/9a/Flag_of_Spain.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Flag_of_Hungary.svg" height="11px"/>

<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://i.imgur.com/B8KGCa7.jpeg" width=220px height=55px></a>

***

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Q5Q51QUJC)

<a href="https://yoomoney.ru/to/4100116615568835"><img src="https://yoomoney.ru/i/shop/iomoney_logo_color_example.png" width=220px height=46px></a>

***

<p align="center">
	&bull;
	<a href="#screenshots">Screenshots</a>
	&bull;
	<a href="#sophia-script-in-action">Videos</a>
	&bull;
	<a href="#core-features">Core features</a>
	&bull;
	<a href="#how-to-use">How to use</a>
	&bull;
	<a href="#how-to-translate">How to translate</a>
	&bull;
	<a href="#supported-windows-versions">Supported Windows 10 & 11 versions</a>
	&bull;
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/blob/master/CHANGELOG.md">Changelog</a>
</p>

***

<table>
	<tr>
		<td>
			<a href="https://rutracker.org/forum/viewtopic.php?t=5996011">
				<img src="https://static.t-ru.org/logo/logo-3.svg" height="100px">
			</a>
		</td>
		<td>
			<a href="https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/">
				<img src="https://i.imgur.com/cZ32Hkt.png">
			</a>
		</td>
		<td>
			<a href="https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/">
				<img src="https://i.imgur.com/K4f8VBo.png">
			</a>
		</td>
		<td>
			<a href="https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs">
				<img src="https://i.imgur.com/5fILFqz.png">
			</a>
		</td>
		<td>
			<a href="https://www.comss.ru/page.php?id=8019">
				<img src="https://cdn.comss.net/img/logo51.png">
			</a>
		</td>
		<td>
			<a href="https://habr.com/company/skillfactory/blog/553800">
				<img src="https://i.imgur.com/cXWLr4I.png">
			</a>
		</td>
		<td>
			<a href="https://www.deskmodder.de/blog/2021/08/07/sophia-script-for-windows-jetzt-fuer-windows-11-und-10//">
				<img src="https://i.imgur.com/6sAI2wZ.png">
			</a>
		</td>
	</tr>
</table>

## :fire: Before running :fire:

* Due to the fact that the script includes more than **150** functions with different arguments, you must read the entire **Sophia.ps1** carefully and **comment out/uncomment** those functions that you do/do not want to be executed. Every tweak in the preset file has its' corresponding function to **restore the default settings**.
* Running the script is best done on a fresh install because running it on **wrong** tweaked system may result in errors occurring.

## Minimum supported Windows versions

# Windows 11

|Version|   Build   |      Editions     | Script version |
|:-----:|:---------:|:-----------------:|:--------------:|
| 21H2  | 22000.282 |Home/Pro/Enterprise|[6.0.6](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest)|

# Windows 10

|Version|    Marketing name   | Build | Arch|      Editions          | Script version |
|:-----:|:-------------------:|:----------:|:---:|:----------------------:|:--------------:|
| 21H2  | October 2021 Update | 19044.1151 | x64 |Home/Pro/Enterprise|[5.12.5](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest)|
| 21H1  | May 2021 Update     | 19043.1151 | x64 |Home/Pro/Enterprise|[5.12.5](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest)|
| 20H2  | October 2020 Update | 19042.1151 | x64 |Home/Pro/Enterprise|[5.12.5](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest)|
| 2004  | May 2020 Update     | 19041.1151 | x64 |Home/Pro/Enterprise|[5.12.5](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest)|
| 1809  | Enterprise LTSC 2019| 17763      | x64 |   Enterprise      |[5.2.16](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest)|

## Screenshots

### The TAB autocomplete. Read more [here](#how-to-run-the-specific-functions)

![Image](./img/Autocomplete.gif)

### Change user folders location programmatically using the interactive menu

![Image](https://i.imgur.com/gJFAEOk.png)

### Localized UWP packages names

![Image](https://i.imgur.com/xeiBbes.png) ![Image](https://i.imgur.com/0zj0h2S.png)

### Localized Windows features names

![Image](https://i.imgur.com/xlMR2mz.png) ![Image](https://i.imgur.com/yl9j9Vt.png)

### Download and install any supported Linux distribution in automatic mode

![Image](https://i.imgur.com/j2KLZm0.png)
 
### Native interactive toasts for the scheduled tasks

![Image](https://i.imgur.com/jornXGR.png)

![Image](https://i.imgur.com/9s7Noud.png)

### David's Sophia Script Wrapper

![Wrapper](https://i.imgur.com/DRRQPJh.png)

## Videos

[![YT](https://img.youtube.com/vi/f529ucAipI8/0.jpg)](https://youtu.be/f529ucAipI8) [![YT](https://img.youtube.com/vi/MiQ85tVXQQA/0.jpg)](https://youtu.be/MiQ85tVXQQA)

[![YT](https://img.youtube.com/vi/8E6OT_QcHaU/1.jpg)](https://youtu.be/8E6OT_QcHaU?t=370) [![YT](https://img.youtube.com/vi/091SOihvx0k/1.jpg)](http://youtu.be/091SOihvx0k?t=490)

## Core features

* Set up Privacy & Telemetry;
* Turn off diagnostics tracking scheduled tasks with pop-up form written in [WPF](#Screenshots);
* Set up UI & Personalization;
* Uninstall OneDrive "correctly";
* Interactive [prompts](#change-user-folders-location-programmatically-using-the-interactive-menu);
* The [TAB](#the-tab-autocomplete-read-more-here) completion for functions and their arguments (if using the Functions.ps1 file);
* Change %TEMP% environment variable path to %SystemDrive%\Temp
* Change location of the user folders programmatically (without moving user files) within interactive menu using arrows to select a drive
  * "Desktop";
  * "Documents";
  * "Downloads";
  * "Music";
  * "Pictures"
  * "Videos.
* Uninstall UWP apps displaying  packages names;
  * Generate installed UWP apps list dynamically
* Restore the default uninstalled UWP apps for current user displaying [localized](#localized-uwp-apps-names) packages names;
* The <kbd>TAB</kbd> [autocompletion](#the-tab-autocomplete-read-more-here) for function and its' arguments by typing first letters
* Disable Windows features displaying friendly packages names with pop-up form written in [WPF](#Screenshots);
* Uninstall Windows capabilities displaying friendly packages names with pop-up form written in [WPF](#Screenshots);
* Download and install the [HEVC Video Extensions from Device Manufacturer](https://www.microsoft.com/p/hevc-video-extensions-from-device-manufacturer/9n4wgh0z6vhq) from Microsoft server using <https://store.rg-adguard.net> parser to be able to open .heic and .heif formats;
* Register app, calculate hash, and set as default for specific extension without the "How do you want to open this" pop-up using special [function](https://github.com/DanysysTeam/PS-SFTA);
* Install any supported Linux distrobution for WSL displaying friendly distro names with pop-up form written in [WPF](#Screenshots);
* Create a `Windows Cleanup` and `Windows Cleanup Notification` scheduled tasks for Windows cleaning up unused files and updates;
  * A native toast notification will be displayed where you can choose to snooze, run the cleanup task or [dismiss](#native-interactive-toasts-for-the-windows-cleanup-scheduled-task)
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

## How to use

* Choose the right script version for your `Windows`;
* Download [up-to-date version](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest);
* Expand the archive;
* Open folder with the expanded archive;
* Look through the `Sophia.ps1` file to configure functions that you want to be run;
  * Place the "#" char before function if you don't want it to be run;
  * Remove the "#" char before function if you want it to be run.
* On `Windows 10` click `File` in File Explorer, hover over `Open Windows PowerShell`, and select `Open Windows PowerShell as Administrator` [(how-to with screenshots)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/);
* On `Windows 11` right-click on the <kbd>Windows</kbd> icon and select `Windows Terminal (Admin)`. Then change the current location

  ```powershell
  Set-Location -Path "Path\To\Sophia\Folder"
  ```

* Set execution policy to be able to run scripts only in the current PowerShell session

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Type `.\Sophia.ps1` <kbd>Enter</kbd> to run the whole preset file.

## How to use Wrapper

* Download and expand the archive;
* Run `SophiaScriptWrapper.exe` and import Sophia.ps1;
  * The Wrapper has a real time UI rendering;
* Configure every function;
* Open the `Console Output` tab and press `Run PowerShell`.

***

### How to run the specific function(s)

To run the specific function(s) [dot source](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-) the `Functions.ps1` file first:

```powershell
# With a dot at the beginning
. .\Functions.ps1
```

* Now you can do like this (the quotation marks required)

```powershell
Sophia -Functions <tab>
Sophia -Functions temp<tab>
Sophia -Functions unin<tab>
Sophia -Functions uwp<tab>
Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

UninstallUWPApps, "PinToStart -UnpinAll"
```

Or use an old-style format without the TAB functions autocomplete (the quotation marks required)

```powershell
.\Sophia.ps1 -Functions CreateRestorePoint, "ScheduledTasks -Disable", "WindowsCapabilities -Uninstall"
```

***

## How to download Sophia Script via PowerShell

* Download the always latest Sophia Script archive by invoking (`not as administrator too`) in PowerShell console

```powershell
irm script.sophi.app | iex
```

or without using aliases

```powershell
Invoke-RestMethod -Uri script.sophi.app | Invoke-Expression
```

* The command will download and expand the archive (`without running`) the latest Sophia Script according which Windows and PowerShell versions it is run on. For example, if you run it on Windows 11 via PowerShell 5.1, it will download Sophia Script for `Windows 11 PowerShell 5.1`.

# Supported variations to launch the command on

* Windows 10
  * PowerShell 5.1;
  * PowerShell 7.1;
* Windows 11
  * PowerShell 5.1;
  * PowerShell 7.1;

## How to translate

* Get your OS UI culture by `$PSUICulture`
* Create a folder with the UI culture name;
* Place your localized Sophia.psd1 file into this folder.

## Ask a question on

* [Telegram discussion group](https://t.me/sophia_chat)
* [Telegram channel](https://t.me/sophianews)
* [Ru-Board](http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
* [rutracker](https://rutracker.org/forum/viewtopic.php?t=5996011)
* [My Digital Life](https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/)
* [Reddit (archived)](https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/)
  * PM [me](https://www.reddit.com/user/farag2/)

## SophiApp Community Edition (C# + WPF)

[SophiApp](https://github.com/Sophia-Community/SophiApp) is in active development 🚀
