<div align="center">
  <h1>Sophia Script</h1>

**A PowerShell module for Windows 10 fine-tuning and automating the routine tasks** :trophy:

![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-brightgreen.svg)
![PowerShell](https://img.shields.io/badge/PowerShell%207.1-Ready-blue?style=flat)
![PowerShell](https://img.shields.io/badge/PowerShell-7.1-blue.svg)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/b1ce4ce852f148a88c47ea33ad172044)](https://www.codacy.com/manual/farag2/Windows-10-Sophia-Script)
[![Github stats](https://img.shields.io/github/downloads/farag2/Windows-10-Setup-Script/total.svg?label=downloads%20%28since%20May%202020%29)](https://github.com/farag2/Windows-10-Sophia-Script/releases)
![latest version](https://img.shields.io/github/v/release/farag2/Windows-10-Sophia-Script)

Available in: :uk: :cn: :de: :fr: :it: :ru: :ukraine: :tr: :es:

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Q5Q51QUJC)
</div>

<hr>
<p align="center">
	&bull;
	<a href="https://github.com/farag2/Windows-10-Sophia-Script/releases"><b>DOWNLOAD</b></a>
	&bull;
	<a href="#screenshots">Screenshots</a>
	&bull;
	<a href="#sophia-script-in-action">Video</a>
	&bull;
	<a href="#core-features">Core features</a>
	&bull;
	<a href="#usage">Usage</a>
	&bull;
	<a href="#how-to-translate">How to translate</a>
	&bull;
	<a href="#supported-windows-10-versions">Supported Windows 10 versions</a>
</p>
<hr>

<table>
	<tr>
		<td>
			<a href="https://youtu.be/8E6OT_QcHaU?t=370">
				<img alt="Qries" src="https://i.imgur.com/mADOh3c.png">
			</a>
		</td>
		<td>
			<a href="https://benchtweakgaming.com/2020/11/12/windows-10-debloat-tool/">
				<img alt="Qries" src="https://benchtweakgaming.com/wp-content/uploads/2020/10/cropped-LOGO_btg_CLEAN_WITH_WORDS_90PX_CUT-3.png">
			</a>
		</td>
		<td>
			<a href="https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/">
				<img alt="Qries" src="https://i.imgur.com/cZ32Hkt.png">
			</a>
		</td>
		<td>
			<a href="https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/">
				<img alt="Qries" src="https://i.imgur.com/K4f8VBo.png">
			</a>
		</td>
		<td>
			<a href="https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs">
				<img alt="Qries" src="https://i.imgur.com/5fILFqz.png">
			</a>
		</td>
		<td>
			<a href="https://www.comss.ru/page.php?id=8019">
				<img alt="Qries" src="https://cdn.comss.net/img/logo51.png">
			</a>
		</td>
		<td>
			<a href="https://habr.com/en/post/521202">
				<img alt="Qries" src="https://i.imgur.com/cXWLr4I.png">
			</a>
		</td>
		<td>
			<a href="https://www.deskmodder.de/blog/2020/09/25/windows-10-sophia-script-windows-10-feintuning-mit-powershell/">
				<img alt="Qries" src="https://i.imgur.com/6sAI2wZ.png">
			</a>
		</td>
	</tr>
</table>

## ⚠️ Before running ⚠️

* Due to the fact that the script includes more than **150** functions with different arguments, you must read the entire **Sophia.ps1** carefully and **comment out/uncomment** those functions that you do/do not want to be executed. Every tweak in the preset file has its' corresponding function to **restore the default settings**.
* Running the script is best done on a fresh install because running it on **wrong** tweaked system may result in errors occurring.

## Supported Windows 10 versions

|Version|Code name|   Marketing name   |Build | Arch |      Editions     | Script version |
|:-----:|:-------:|:------------------:|:----:|:----:|:-----------------:|:--------------:|
| 2009  |  20H2   |October 2020 Update |19042 |  x64 |Home/Pro/Enterprise|[5.3](https://github.com/farag2/Windows-10-Sophia-Script/releases/latest)|
| 2004  |  20H1   |   May 2020 Update  |19041 |  x64 |Home/Pro/Enterprise|[5.3](https://github.com/farag2/Windows-10-Sophia-Script/releases/latest)|
| 1809  |         |LTSC Enterprise 2019|17763 |  x64 |   Enterprise      |[4.5](https://github.com/farag2/Windows-10-Sophia-Script/tree/master/LTSC)|

## Screenshots

<details>
  <summary>Screenshots</summary>
  
![Image](https://i.imgur.com/5up2HrJ.png)
![Image](https://i.imgur.com/AXY12aJ.png)
</details>

## Sophia Script in Action

[![YT](https://i.imgur.com/mADOh3c.png)](https://youtu.be/TpYxw3FYoNk)

## Core features

* Set up Privacy & Telemetry;
* Turn off diagnostics tracking scheduled tasks with pop-up form written in [WPF](#Screenshots);
* Set up UI & Personalization;
* Uninstall OneDrive "correctly";
* Interactive prompts;
* Change %TEMP% environment variable path to %SystemDrive%\Temp
* Change location of the user folders programmatically (without moving user files) within interactive menu using arrows to select a drive
  * "Desktop";
  * "Documents";
  * "Downloads";
  * "Music";
  * "Pictures"
  * "Videos.
* Uninstall UWP apps from all accounts with exception apps list with pop-up form written in [WPF](#Screenshots);
* Disable Windows features;
* Install and setup WSL
* Remove Windows capabilities with pop-up form written in [WPF](#Screenshots);
* Create a Windows cleaning up task in the Task Scheduler;
  * A toast notification will pop up a minute before the task [starts](#Screenshots)
* Create tasks in the Task Scheduler to clear
  * ```%SystemRoot%\SoftwareDistribution\Download```
  * ```%TEMP%```
* Unpin all Start menu tiles;
* Pin shortcuts to Start menu using [syspin.exe](http://www.technosys.net/products/utils/pintotaskbar)
  * Three shortcuts are preconfigured to be pinned: Control Panel, "old style" Devices and Printers, and Command Prompt
* Turn on Controlled folder access and add protected folders using dialog menu;
* Add exclusion folder from Microsoft Defender Antivirus scanning using dialog menu;
* Add exclusion file from Microsoft Defender Antivirus scanning using dialog menu;
* Refresh desktop icons, environment variables and taskbar without restarting File Explorer;
* Setup Windows 10 security;
* Many more File Explorer and context menu "deep" tweaks.

## Usage

To run the script:

* Download [up-to-date version](https://github.com/farag2/Windows-10-Sophia-Script/releases/latest);
* Expand the archive;
* Open folder with the expanded archive;
* Look through the ```.\Sophia.ps1``` file to configure functions that you want to be ran;
  * Comment out function with the ```#``` char if you don't want it to be ran;
  * Uncomment function by removing the ```#``` char if you want it to be ran.
* Click "File" in File Explorer, hover over "Open Windows PowerShell", and select "Open Windows PowerShell as Administrator" [(how-to with screenshots)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/);
* Set execution policy to be able to run scripts only in the current PowerShell session

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Type ```.\Sophia.ps1```
* Press Enter

## How to translate

* Get your OS UI culture byCommunity Edition

   ```powershell
   $PSUICulture
   ```

* Create a folder with the UI culture name;
* Place your localized Sophia.psd1 file into this folder

## Ask a question on

* [Ru-Board](http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
* [My Digital Life](https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/)
* [Reddit (archived)](https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/)

## SophiApp Community Edition (C# + WPF)

Internal build by [oz-zo](https://github.com/oz-zo) being compiled in the private repository every Suturday within Github Actions
